import 'package:fans/cloudbase/function/FunctionSmsMockHttp.dart';
import 'package:fans/cloudbase/function/FunctionMockHttp.dart';

class TcbSmsCommand {
  const TcbSmsCommand._();

  static Future<void> sendCode(String phone) async {
    FunctionMockHttpResponse response =
        await FunctionSmsMockHttp('send', {'phone': phone}).send();
    Map data = response.rawResponse;
    if (data['code'] != 'SEND_SUCCESS') {
      throw UnimplementedError(data['msg']);
    }
  }

  static Future<String> createLoginTicket(String phone, String code) async {
    FunctionMockHttpResponse response = await FunctionSmsMockHttp('login', {
      'phone': phone,
      'smsCode': code,
    }).send();
    Map data = response.rawResponse;
    if (data['code'] != 'LOGIN_SUCCESS') {
      throw UnimplementedError(data['msg']);
    }

    return data['res'];
  }
}
