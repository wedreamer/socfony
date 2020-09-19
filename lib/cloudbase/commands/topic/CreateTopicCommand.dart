import 'dart:convert' show jsonEncode;

import 'package:fans/cloudbase/function/FunctionMockHttp.dart';
import 'package:fans/models/Topic.dart';

class CreateTopicCommandController {
  String cover;
  String name;
  String description;
  String title;
  TopicJoinType joinType = TopicJoinType.freely;
  TopicPostType postType = TopicPostType.any;

  Map<String, dynamic> toData() {
    return {
      'cover': cover,
      'name': name,
      'title': title,
      'description': description,
      'joinType': joinType.name,
      'postType': postType.name,
    };
  }

  @override
  String toString() {
    return jsonEncode(toData());
  }
}

class CreateTopicCommand {
  final CreateTopicCommandController controller;

  const CreateTopicCommand(this.controller);

  Future<String> send() async {
    final http = FunctionMockHttp(
      method: 'post',
      path: '/topics',
      body: controller.toString(),
      headers: {'Content-Type': 'application/json'},
    );

    final response = await http.send();
    final result = response.toJsonDecode();
    if (response.statusCode == 201) {
      return result['id'];
    }
    throw UnimplementedError(result['message']);
  }
}
