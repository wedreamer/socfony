import 'package:snsmax/cloudbase.dart';

class QueryFollowingMomentCommand
    extends CloudBaseFunctionBaseCommand<Iterable<String>> {
  const QueryFollowingMomentCommand([int offset = 0]) : super(offset);

  @override
  String get command => 'followingMoments';

  @override
  String get functionName => 'snsmax-moment';

  @override
  Iterable<String> deserializer(data, CloudBaseResponse response) {
    return (data as List)?.map((e) => e.toString());
  }
}
