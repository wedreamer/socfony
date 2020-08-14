import '../../../cloudbase.dart' show CloudBaseResponse;
import 'SmsBaseCommand.dart';

class SmsLoginCommand extends SmsBaseCommand<String> {
  SmsLoginCommand(String phone, String code)
      : super({'phone': phone, 'smsCode': code});

  @override
  String get commandName => 'login';

  @override
  String deserializer(data, CloudBaseResponse response) {
    print(data);
    if (data['code'] == 'LOGIN_SUCCESS') {
      return data['res'];
    }

    throw UnimplementedError(data['msg']);
  }
}
