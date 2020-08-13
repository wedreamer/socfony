import '../Command.dart';
import 'dart:convert' show jsonEncode;

abstract class SmsBaseCommand<T> extends Command<T> {
  SmsBaseCommand(Map<String, dynamic> data) : super(data);

  @override
  Object get options {
    return {
      'body': jsonEncode({
        'cmd': commandName,
        ...data,
      }),
    };
  }

  @override
  String get functionName => 'tcb-sms-auth-ext';
}
