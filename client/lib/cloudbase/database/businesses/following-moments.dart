import 'package:flutter/foundation.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/cloudbase/commands/QueryFollowingMomentCommand.dart';
import 'package:snsmax/provider/auth.dart';

class FollowingMomentsBusiness with ChangeNotifier {
  static FollowingMomentsBusiness _instance;

  Iterable<String> _ids;
  Iterable<String> get ids => _ids;

  FollowingMomentsBusiness._() {
    AuthProvider().addListener(() {
      final userId = AuthProvider().user;
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

  Future<void> refresh() async {
    final command = QueryFollowingMomentCommand();
    _ids = await CloudBase().command(command);

    notifyListeners();
  }

  Future<void> loadMore() async {
    final command = QueryFollowingMomentCommand(this.ids.length);
    final ids = await CloudBase().command(command);

    _ids = ids.toList()
      ..addAll(ids)
      ..toSet().toList();

    notifyListeners();
  }
}
