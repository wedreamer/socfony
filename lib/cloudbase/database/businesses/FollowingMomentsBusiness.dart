import 'package:flutter/foundation.dart';
import 'package:fans/cloudbase/commands/moment/QueryFollowingMomentsCommand.dart';
import 'package:fans/provider/AppAuthProvider.dart';

class FollowingMomentsBusiness with ChangeNotifier {
  static FollowingMomentsBusiness _instance;

  Iterable<String> _ids;
  Iterable<String> get ids => _ids ?? [];

  FollowingMomentsBusiness._() {
    AppAuthProvider().addListener(() {
      final userId = AppAuthProvider().uid;
      if (userId == null || userId.isEmpty) {
        this
          .._ids = []
          ..notifyListeners();
      }
    });
  }

  factory FollowingMomentsBusiness() {
    if (_instance is! FollowingMomentsBusiness) {
      _instance = FollowingMomentsBusiness._();
    }

    return _instance;
  }

  Future<int> refresh() async {
    _ids = await QueryFollowingMomentsCommand().run();
    notifyListeners();

    return ids.length;
  }

  Future<int> loadMore() async {
    final ids =
        await QueryFollowingMomentsCommand(offset: this.ids?.length ?? 0).run();

    _ids = this.ids.toList()
      ..addAll(ids)
      ..toSet().toList();

    notifyListeners();

    return ids.length;
  }
}
