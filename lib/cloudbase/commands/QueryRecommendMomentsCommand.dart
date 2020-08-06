import 'package:snsmax/cloudbase.dart';

class QueryRecommendMomentsCommand
    extends CloudBaseFunctionBaseCommand<Iterable<String>> {
  QueryRecommendMomentsCommand([int offset = 0]) : super(offset);

  @override
  String get command => 'recommendMoments';

  @override
  Iterable<String> deserializer(data, CloudBaseResponse response) {
    return (data as Iterable).map((e) => e.toString());
  }

  @override
  String get functionName => 'snsmax-moment';

  static Future<Iterable<String>> run([int offset = 0]) {
    final command = QueryRecommendMomentsCommand(offset);
    return CloudBase().command(command);
  }
}
