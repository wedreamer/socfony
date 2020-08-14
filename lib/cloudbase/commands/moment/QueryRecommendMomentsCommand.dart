import 'package:snsmax/cloudbase.dart';

import '../ClientApiFunctionCommand.dart';

class QueryRecommendMomentsCommand
    extends ClientApiFunctionCommand<Iterable<String>> {
  QueryRecommendMomentsCommand({int limit = 20, int offset = 0})
      : super({'limit': limit, 'offset': offset});

  @override
  Iterable<String> deserializer(data, CloudBaseResponse response) {
    return (data as Iterable).map((e) => e.toString());
  }

  @override
  String get commandName => 'moment:recommentMoments';
}
