import 'package:fans/cloudbase/function/FunctionMockHttp.dart';

class FunctionMomentQuery {
  const FunctionMomentQuery._();

  static Future<List<String>> queryFollowingMomentIds({
    int limit = 15,
    int offset = 0,
  }) async {
    FunctionMockHttp http = FunctionMockHttp(
      method: 'get',
      path: '/moment-business/following',
      query: {
        'limit': limit,
        'offset': offset,
      },
    );
    final response = await http.send();
    if (response.statusCode == 200) {
      return response.toJsonDecode<List>().cast<String>().toList();
    }

    throw UnimplementedError(response.toJsonDecode()['message']);
  }

  static Future<List<String>> queryRecommendMomentIds({
    int limit = 15,
    int offset = 0,
  }) async {
    FunctionMockHttp http = FunctionMockHttp(
      method: 'get',
      path: '/moment-business/recommend',
      query: {
        'limit': limit,
        'offset': offset,
      },
    );
    final response = await http.send();
    if (response.statusCode == 200) {
      return response.toJsonDecode<List>().cast<String>().toList();
    }

    throw UnimplementedError(response.toJsonDecode()['message']);
  }

  static Future<void> currentUserLikeMoment(String momentId) async {
    final http = FunctionMockHttp(
      path: '/user/liked/moments/$momentId',
      method: 'put',
    );
    await http.send();
  }

  static Future<void> currentUserUnlikeMoment(String momentId) async {
    final http = FunctionMockHttp(
      path: '/user/liked/moments/$momentId',
      method: 'delete',
    );
    await http.send();
  }

  static Future<void> currentUserSelectVote(
    String momentId,
    String vote,
  ) async {
    final http = FunctionMockHttp(
        path: '/moments/$momentId/vote',
        method: 'put',
        body: '{"vote": "$vote"}',
        headers: {"content-type": "application/json"});
    await http.send();
  }
}
