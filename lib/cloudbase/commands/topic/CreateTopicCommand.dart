import 'package:fans/cloudbase/commands/ClientApiFunctionCommand.dart';
import 'package:fans/models/Topic.dart';

import '../../../cloudbase.dart';

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
}

class CreateTopicCommand extends ClientApiFunctionCommand<String> {
  CreateTopicCommand(CreateTopicCommandController controller)
      : super(controller.toData());

  @override
  String get commandName => 'topic:create';

  @override
  String deserializer(data, CloudBaseResponse response) {
    if (data is Map && data['success'] == true) {
      return data['docId'];
    }

    throw UnimplementedError(response.message ?? '创建失败');
  }
}
