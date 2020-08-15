import 'package:fans/models/user.dart';

import '../../../cloudbase.dart';
import '../ClientApiFunctionCommand.dart';

class QueryUserCommand extends ClientApiFunctionCommand<User> {
  QueryUserCommand(String userId) : super({'uid': userId});

  @override
  String get commandName => 'user:query';

  @override
  User deserializer(data, CloudBaseResponse response) {
    if (response.code == null && data is Map) {
      return User.fromJson(data);
    } else if (response.message is String) {
      throw new UnimplementedError(response.message);
    }

    throw new UnimplementedError('请求失败');
  }
}
