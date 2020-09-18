import 'dart:convert';

import 'package:fans/cloudbase/function/FunctionMockHttp.dart';

class FunctionSmsMockHttp extends FunctionMockHttp {
  @override
  String get fnName => 'tcb-sms-auth-ext';

  @override
  String get method => 'post';

  @override
  bool get isBase64Encoded => false;

  @override
  String get path => '/';

  final Map<String, dynamic> _body;

  final String cmd;

  @override
  String get body {
    return jsonEncode({
      'cmd': cmd,
      ..._body,
    });
  }

  const FunctionSmsMockHttp(this.cmd, this._body);
}
