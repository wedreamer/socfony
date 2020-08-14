import '../../../cloudbase.dart';
import 'SmsBaseCommand.dart';

class SmsSendPhoneCodeCommand extends SmsBaseCommand<String> {
  SmsSendPhoneCodeCommand(String phone) : super({'phone': phone});

  @override
  String get commandName => 'send';

  @override
  String deserializer(data, CloudBaseResponse response) {
    if (data['code'] != 'SEND_SUCCESS') {
      throw new UnimplementedError(data['msg']);
    }

    return data['msg'];
  }
}
