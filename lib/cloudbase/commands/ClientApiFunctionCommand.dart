import 'Command.dart';

abstract class ClientApiFunctionCommand<T> extends Command<T> {
  @override
  String get functionName => 'app-api';

  ClientApiFunctionCommand(Map<String, dynamic> data) : super(data);
}
