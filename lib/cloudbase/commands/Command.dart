import '../../cloudbase.dart';

abstract class Command<T> {
  String get functionName;
  String get commandName;

  final Map<String, dynamic> data;

  Object get options => {
        'command': commandName,
        'data': data,
      };

  const Command([this.data]);

  Future<T> run() async {
    final result = await CloudBase().callFunction(functionName, options);

    return deserializer(result.data, result);
  }

  T deserializer(dynamic data, CloudBaseResponse response);
}
