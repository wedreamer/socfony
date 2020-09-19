import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:fans/cloudbase.dart';
import 'package:fans/models/BaseModel.dart';
import 'package:fans/models/serializers.dart';
import 'package:flutter/foundation.dart';

typedef Future<T> TcbDbCollectionsQueryDocQuery<T extends AbstractBaseModel>(
    TcbDbCollectionsProvider provider, String docId);

class TcbDbCollectionsProvider extends ChangeNotifier {
  static TcbDbCollectionsProvider _instance;

  Map<String, Map<String, dynamic>> _collections = {};

  Map<String, Map<String, dynamic>> get collections => _collections;

  Map<String, Future> _futures = {};

  Map<String, Future> get futures => _futures;

  static Map<String, TcbDbCollectionsQueryDocQuery> _queries = {};

  TcbDbCollectionsProvider._();

  static void registerQuery<T extends AbstractBaseModel>(
      String collectionName, TcbDbCollectionsQueryDocQuery<T> query) {
    _queries[collectionName] = query;
  }

  factory TcbDbCollectionsProvider() {
    if (_instance is! TcbDbCollectionsProvider) {
      _instance = TcbDbCollectionsProvider._();
    }

    return _instance;
  }

  Map<String, T> findCollection<T extends AbstractBaseModel>(
      String collectionName) {
    Map<String, T> collection =
        (collections[collectionName] ?? {}).cast<String, T>();
    if (!collections.containsKey(collectionName)) {
      _collections[collectionName] = {}.cast<String, T>();
    }

    return collection;
  }

  T findDoc<T extends AbstractBaseModel>(String collectionName, String docId) {
    Map<String, T> collection = findCollection<T>(collectionName);
    if (collection.containsKey(docId)) {
      return collection[docId];
    }

    return null;
  }

  T whereFindDoc<T extends AbstractBaseModel>(
    String collectionName,
    Map<String, dynamic> where,
  ) {
    if (where == null || where.isEmpty) {
      return null;
    }
    Iterable<T> collection = findCollection<T>(collectionName).values;

    if (collection.isEmpty) {
      return null;
    }

    try {
      return collection.firstWhere((element) {
        final object = element.toJson();
        return where
            .map((key, value) => MapEntry(key, object[key] == value))
            .values
            .where((element) => !element)
            .isEmpty;
      });
    } catch (_e) {
      return null;
    }
  }

  Future<T> whereQueryDoc<T extends AbstractBaseModel>(
    String collectionName,
    Map<String, dynamic> where,
  ) async {
    T doc = whereFindDoc(collectionName, where);
    if (doc is T) {
      return doc;
    }

    String futureKey = '$collectionName/${where.toString()}';
    if (_futures.containsKey(futureKey)) {
      return await _futures[futureKey];
    }

    Completer<T> completer = Completer<T>();
    CloudBase().database.collection(collectionName).where(where).watch(
      onChange: (Snapshot snapshot) {
        _onDocsChange<T>(collectionName, snapshot);
        if (!completer.isCompleted) {
          completer.complete(whereFindDoc(collectionName, where));
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );

    _futures[futureKey] = completer.future;

    return await _futures[futureKey];
  }

  Future<T> queryDoc<T extends AbstractBaseModel>(
      String collectionName, String docId) async {
    String futureKey = '$collectionName/$docId';
    T doc = findDoc<T>(collectionName, docId);
    if (doc is T) {
      return doc;
    } else if (_futures.containsKey(futureKey)) {
      return await _futures[futureKey];
    } else if (_queries.containsKey(collectionName)) {
      TcbDbCollectionsQueryDocQuery<T> query = _queries[collectionName];
      Future<T> future = query(this, docId);
      _futures[futureKey] = future;
      T doc = await future;
      updateDocs<T>(collectionName, [doc]);

      return doc;
    }

    Completer<T> completer = Completer<T>();
    CloudBase().database.collection(collectionName).doc(docId).watch(
      onChange: (Snapshot snapshot) {
        _onDocsChange<T>(collectionName, snapshot);

        if (!completer.isCompleted) {
          completer.complete(findDoc(collectionName, docId));
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );

    _futures[futureKey] = completer.future;

    return await _futures[futureKey];
  }

  void updateDocs<T extends AbstractBaseModel>(
      String collectionName, Iterable<T> docs) {
    findCollection(collectionName);

    if (docs.isEmpty) {
      return;
    }

    docs.forEach((element) {
      _collections[collectionName][element.id] = element;
    });

    notifyListeners();
  }

  void removeDocs<T extends AbstractBaseModel>(
    String collectionName,
    Iterable<String> ids,
  ) {
    if (ids.isEmpty) {
      return null;
    }
    ids.forEach((element) {
      _collections[collectionName].remove(element);
    });

    notifyListeners();
  }

  void _onDocsChange<T extends AbstractBaseModel>(
      String collectionName, Snapshot snapshot) {
    Iterable<T> docs = snapshot.docChanges
        .where((element) => element.dataType != 'remove')
        .map<T>(
          (e) => serializers.deserialize(e.doc, specifiedType: FullType(T)),
        );
    Iterable<String> needRemoveIds = snapshot.docChanges
        .where((element) => element.dataType == 'remove')
        .map((e) => e.docId);
    updateDocs<T>(collectionName, docs);
    removeDocs(collectionName, needRemoveIds);
  }
}
