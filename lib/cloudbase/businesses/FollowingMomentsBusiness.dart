import 'package:fans/cloudbase/function/FunctionMomentQuery.dart';
import 'package:flutter/foundation.dart';

class FollowingMomentsBusiness with ChangeNotifier {
  static FollowingMomentsBusiness _instance;

  Iterable<String> _ids;
  Iterable<String> get ids => _ids ?? [];

  FollowingMomentsBusiness._();

  factory FollowingMomentsBusiness() {
    if (_instance is! FollowingMomentsBusiness) {
      _instance = FollowingMomentsBusiness._();
    }

    return _instance;
  }

  Future<int> refresh() async {
    _ids = await FunctionMomentQuery.queryFollowingMomentIds();
    notifyListeners();

    return ids.length;
  }

  Future<int> loadMore() async {
    final ids = await FunctionMomentQuery.queryFollowingMomentIds(
      offset: this.ids?.length ?? 0,
    );

    _ids = this.ids.toList()
      ..addAll(ids)
      ..toSet().toList();

    notifyListeners();

    return ids.length;
  }
}
