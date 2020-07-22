import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/user.dart';

class AuthProvider with ChangeNotifier {
  User _user;

  User get user => _user;

  static RealtimeListener _watcher;

  set user(User user) {
    _user = user;
    notifyListeners();
    _watcher?.close();
    _watcher = CloudBase().database.collection('users').doc(user.id).watch(
      onChange: (Snapshot snapshot) {
        List<User> users = snapshot.docs.map((e) => User.fromJson(e)).toList();
        if (users.isNotEmpty) {
          _user = users.last;
          notifyListeners();
        }
      },
    );
  }
}
