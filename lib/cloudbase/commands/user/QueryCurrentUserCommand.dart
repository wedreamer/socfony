import 'QueryUserCommand.dart';

class QueryCurrentUserCommand extends QueryUserCommand {
  QueryCurrentUserCommand() : super(null);

  @override
  String get commandName => 'user:current';
}
