import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/user.dart';

class QueryCurrentUserCommand extends CloudBaseFunctionBaseCommand<User> {
  static QueryCurrentUserCommand _instance;

  QueryCurrentUserCommand._();

  factory QueryCurrentUserCommand() {
    if (_instance is! QueryCurrentUserCommand) {
      _instance = QueryCurrentUserCommand._();
    }

    return _instance;
  }

  @override
  String get command => 'currentUser';

  @override
  User deserializer(data, CloudBaseResponse response) {
    return User.fromJson(data);
  }

  @override
  String get functionName => 'auth';

  static Future<User> run() {
    final command = QueryCurrentUserCommand();

    return CloudBase().command(command);
  }
}
