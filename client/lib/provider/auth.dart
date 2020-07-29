import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _user;

  String get user => _user;
  set user(String user) {
    _user = user;
    notifyListeners();
  }

  static AuthProvider _instance;

  AuthProvider._();

  factory AuthProvider() {
    if (_instance is! AuthProvider) {
      _instance = AuthProvider._();
    }

    return _instance;
  }
}
