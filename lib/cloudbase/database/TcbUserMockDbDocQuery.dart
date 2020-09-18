import 'package:fans/cloudbase/database/TcbDbCollectionsProvider.dart';
import 'package:fans/cloudbase/function/function-mock-http.dart';
import 'package:fans/models/user.dart';

const String kCloudUserHttpMockDbCollectionName = 'mock://users';

class TcbUserMockDbDocQuery {
  const TcbUserMockDbDocQuery._();

  static void register() {
    TcbDbCollectionsProvider.registerQuery<User>(
      kCloudUserHttpMockDbCollectionName,
      (_, String userId) async => await query(userId),
    );
  }

  static Future<User> query(String userId) async {
    final response = await FunctionMockHttp(
      method: 'get',
      path: '/users/$userId',
    ).send();
    if (response.statusCode == 200) {
      return User.fromJson(response.toJsonDecode());
    }

    throw UnimplementedError(response.toJsonDecode()['message']);
  }
}
