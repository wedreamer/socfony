import 'package:snsmax/cloudbase/commands/ClientApiFunctionCommand.dart';

import '../../../cloudbase.dart';

class ToggleLikeMomentCommand extends ClientApiFunctionCommand<void> {
  ToggleLikeMomentCommand(String momentId) : super({'momentId': momentId});

  @override
  String get commandName => 'moment:toggleLike';

  @override
  void deserializer(data, CloudBaseResponse response) {
    if (response.code != null) {
      throw UnimplementedError(response.message ?? '操作失败');
    }
  }
}
