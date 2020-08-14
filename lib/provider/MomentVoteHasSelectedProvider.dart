import 'dart:async';

import 'package:snsmax/models/MomentVoteUserSelected.dart';
import 'package:snsmax/provider/collection.dart';

import '../cloudbase.dart';
import 'AppAuthProvider.dart';

class MomentVoteHasSelectedProvider
    extends BaseCollectionProvider<String, MomentVoteUserSelected> {
  static MomentVoteHasSelectedProvider _instance;
  static Map<String, RealtimeListener> _watchers = {};

  MomentVoteHasSelectedProvider._() {
    AppAuthProvider().addListener(_listener);
  }

  factory MomentVoteHasSelectedProvider() {
    if (_instance is! MomentVoteHasSelectedProvider) {
      _instance = MomentVoteHasSelectedProvider._();
    }

    return _instance;
  }

  @override
  String get collectionName => 'moment-vote-user-selected';

  @override
  String toCollectionId(MomentVoteUserSelected element) {
    return element.momentId;
  }

  @override
  String toDocId(MomentVoteUserSelected element) {
    return element.id;
  }

  @override
  MomentVoteUserSelected formObject(Object value) {
    return super.formObject(value) ?? MomentVoteUserSelected.fromJson(value);
  }

  @override
  void watcher(Iterable<MomentVoteUserSelected> elements) {}

  @override
  bool get usingCustomWatchDoc => true;

  @override
  Future<MomentVoteUserSelected> customWatchDoc(String key) {
    final userId = AppAuthProvider().uid;
    if (userId == null || userId.isEmpty || _watchers.containsKey(key)) {
      return null;
    } else if (containsKey(key)) {
      return Future.value(collections[key]);
    }

    final completer = Completer<MomentVoteUserSelected>();
    _watchers.putIfAbsent(key, () {
      return CloudBase()
          .database
          .collection(collectionName)
          .where(
            {
              "momentId": key,
              "userId": userId,
            },
          )
          .limit(1)
          .watch(onChange: (Snapshot snapshot) {
            onChange(snapshot);
            if (!completer.isCompleted) {
              completer.complete(collections[key]);
            }
          });
    });

    return completer.future;
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
  void remove(String key) {
    [...values].where((element) => element.id == key).forEach((element) {
      super.remove(element.momentId);
    });
  }
}
