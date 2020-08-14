import 'dart:async';

import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/moment-like-history.dart';
import 'package:snsmax/provider/AppAuthProvider.dart';

import 'collection.dart';

class MomentHasLikedProvider
    extends BaseCollectionProvider<String, MomentLikeHistory> {
  static MomentHasLikedProvider _instance;
  static Map<String, RealtimeListener> _watchers = {};

  MomentHasLikedProvider._() {
    AppAuthProvider().addListener(_listener);
  }

  factory MomentHasLikedProvider() {
    if (_instance is! MomentHasLikedProvider) {
      _instance = MomentHasLikedProvider._();
    }

    return _instance;
  }

  @override
  String get collectionName => 'moment-liked-histories';

  @override
  String toCollectionId(MomentLikeHistory element) {
    return element.momentId;
  }

  @override
  String toDocId(MomentLikeHistory element) {
    return element.id;
  }

  @override
  bool get usingCustomWatchDoc => true;

  @override
  Future<MomentLikeHistory> customWatchDoc(String key) {
    final userId = AppAuthProvider().uid;
    if (userId == null || userId.isEmpty || _watchers.containsKey(key)) {
      return null;
    } else if (containsKey(key)) {
      return Future.value(collections[key]);
    }

    final completer = Completer<MomentLikeHistory>();
    _watchers.putIfAbsent(key, () {
      return CloudBase().database.collection(collectionName).where({
        "momentId": key,
        "userId": userId,
      }).watch(onChange: (Snapshot snapshot) {
        onChange(snapshot);
        if (!completer.isCompleted) {
          completer.complete(collections[key]);
        }
      });
    });

    return completer.future;
  }

  @override
  void remove(String key) {
    [...values].where((element) => element.id == key).forEach((element) {
      super.remove(element.momentId);
    });
  }

  void _listener() {
    final userId = AppAuthProvider().uid;
    if (userId == null || userId.isEmpty) {
      _watchers.values.forEach((element) => element.close());
      _watchers.clear();
      return clear();
    }
  }

  @override
  MomentLikeHistory formObject(Object value) {
    return super.formObject(value) ?? MomentLikeHistory.fromJson(value);
  }

  @override
  void watcher(Iterable<MomentLikeHistory> elements) {
    super.watcher(elements);
  }
}
