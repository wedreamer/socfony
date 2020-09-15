import 'package:fans/cloudbase/database/TcbDbCollectionsProvider.dart';
import 'package:fans/models/user.dart';

class TcbUserMockDbDocQuery {
  const TcbUserMockDbDocQuery._();

  static void register() {
    TcbDbCollectionsProvider.registerQuery<User>('users', query);
  }

  static Future<User> query(_, String userId) async {
    //
  }
}
