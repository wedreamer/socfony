import 'package:fans/cloudbase/commands/ClientApiFunctionCommand.dart';

import '../../../cloudbase.dart';

class QueryFollowingMomentsCommand
    extends ClientApiFunctionCommand<Iterable<String>> {
  QueryFollowingMomentsCommand({int limit = 20, int offset = 0})
      : super({'limit': limit, 'offset': offset});

  @override
  String get commandName => 'moment:followingToMoments';

  @override
  Iterable<String> deserializer(data, CloudBaseResponse response) {
    if (response.code == null && data is Iterable) {
      return data.map((e) => e.toString());
    }

    throw new UnimplementedError(response.message);
  }
}
