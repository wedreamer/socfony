import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/moment-like-history.dart';
import 'package:snsmax/models/user.dart';
import 'package:snsmax/provider/auth.dart';
import 'package:snsmax/provider/collections/moments.dart';

import 'collection.dart';

class MomentLikeHistoriesProvider
    extends BaseCollectionProvider<String, MomentLikeHistory> {
  static MomentLikeHistoriesProvider _instance;
  static Map<String, RealtimeListener> _watchers = {};

  MomentLikeHistoriesProvider._() {
    AuthProvider().addListener(_listener);
    MomentsCollection().addListener(_listener);
  }

  factory MomentLikeHistoriesProvider() {
    if (_instance is! MomentLikeHistoriesProvider) {
      _instance = MomentLikeHistoriesProvider._();
    }

    return _instance;
  }

  @override
  String get collectionName => 'moment-liked-histories';

  @override
  String toCollectionId(MomentLikeHistory element) => element.momentId;

  @override
  String toDocId(MomentLikeHistory element) => element.momentId;

  @override
  MomentLikeHistory formObject(Object value) {
    return super.formObject(value) ?? MomentLikeHistory.fromJson(value);
  }

  @override
  void dispose() {
    AuthProvider().removeListener(_listener);
    MomentsCollection().removeListener(_listener);
    super.dispose();
  }

  @override
  void clear() {
    super.clear();
    _watchers.values.forEach((element) => element.close());
    _watchers.clear();
  }

  void _listener() {
    final user = AuthProvider().user;
    if (user is! User) {
      return clear();
    }

    final momentIds = MomentsCollection()
        .collections
        .keys
        .where((element) => !_watchers.containsKey(element))
        .toList();
    for (final id in momentIds) {
      final watcher = CloudBase()
          .database
          .collection(collectionName)
          .where({"userId": user.id, "momentId": id}).watch(
        onChange: _onChange,
      );
      _watchers.putIfAbsent(id, () => watcher);
    }
  }

  void _onChange(Snapshot snapshot) {
    for (final element in snapshot.docChanges) {
      final doc = formObject(element.doc);
      if (element.dataType == 'remove') {
        remove(doc.momentId);
        continue;
      }

      originInsertOrUpdate([doc]);
      notifyListeners();
    }
  }

  @override
  void watcher(Iterable<MomentLikeHistory> elements) {}
}
