import 'dart:convert' as convert show base64Decode, jsonDecode;

import '../../cloudbase.dart';

class FunctionMockHttpResponse {
  /// 内容是否经过 Base64 编码
  bool isBase64Encoded;

  /// 响应的 Http 状态码
  int statusCode;

  /// 响应的请求头内容
  Map<String, dynamic> headers;

  /// 响应的内容
  String body;

  final dynamic rawResponse;

  String toBase64Decode() {
    if (!isBase64Encoded) {
      return body;
    }

    return convert.base64Decode(body).toString();
  }

  dynamic toJsonDecode() {
    return convert.jsonDecode(toBase64Decode());
  }

  FunctionMockHttpResponse(
    this.rawResponse, {
    this.body,
    this.headers,
    this.isBase64Encoded,
    this.statusCode,
  }) {
    if (rawResponse['body'] is String && this.body == null) {
      this.body = rawResponse['body'];
    }
    if (rawResponse['headers'] is Map && this.headers == null) {
      this.headers = rawResponse['headers'];
    }
    if (rawResponse['isBase64Encoded'] is bool &&
        this.isBase64Encoded == null) {
      this.isBase64Encoded = rawResponse['isBase64Encoded'];
    }
    if (rawResponse['statusCode'] is int && this.statusCode == null) {
      this.statusCode = rawResponse['statusCode'];
    }
  }
}

class FunctionMockHttp {
  /// 模拟的 Http 请求地址
  final String path;

  /// 模拟的 Http 请求方式
  final String method;

  /// 需要请求的 Headers
  final Map<String, dynamic> headers;

  /// Body 内容是否进行了 Base64 编码处理
  final bool isBase64Encoded;

  /// 传输的内容字符串
  final String body;

  String get fnName => 'server';

  const FunctionMockHttp({
    this.method,
    this.path,
    this.body,
    this.headers = const {},
    this.isBase64Encoded = false,
  });

  Future<FunctionMockHttpResponse> send() async {
    CloudBaseResponse response = await CloudBase().callFunction(fnName, {
      'path': path,
      'httpMethod': method.toUpperCase(),
      'isBase64Encoded': isBase64Encoded,
      'body': body,
    });

    if (response.data is Map) {
      return FunctionMockHttpResponse(response.data);
    }

    throw UnimplementedError('返回内容不是合法的 Http mock 内容');
  }
}
