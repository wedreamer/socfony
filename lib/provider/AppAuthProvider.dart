import 'package:fans/cloudbase/database/TcbDbCollectionsProvider.dart';
import 'package:fans/cloudbase/database/TcbUserMockDbDocQuery.dart';
import 'package:flutter/widgets.dart';
import 'package:fans/cloudbase.dart';

final _cloudbase = CloudBase();
final _auth = _cloudbase.auth;

class AppAuthProvider with ChangeNotifier {
  CloudBaseAuthState _state;
  CloudBaseAuthState get state => _state;

  String _uid;
  String get uid => _uid;

  static AppAuthProvider _instance;

  AppAuthProvider._();

  factory AppAuthProvider() {
    if (_instance is! AppAuthProvider) {
      _instance = AppAuthProvider._();
    }

    return _instance;
  }

  AppAuthProvider reset(CloudBaseAuthState state, String uid) {
    _uid = uid;
    _state = state;

    notifyListeners();

    return this;
  }

  Future<AppAuthProvider> fetch() async {
    final stateUser = await _auth.getUserInfo();
    final state = await _auth.getAuthState();
    final user = await TcbUserMockDbDocQuery.query(stateUser.uuid);

    reset(state, user.id);

    TcbDbCollectionsProvider()
        .updateDocs(kCloudUserHttpMockDbCollectionName, [user]);

    return this;
  }

  static init([bool hasRethrow = false]) async {
    try {
      AppAuthProvider().fetch();
    } catch (e) {
      if (hasRethrow) {
        rethrow;
      }
    }
  }
}
