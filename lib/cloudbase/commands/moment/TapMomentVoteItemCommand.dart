import 'package:snsmax/cloudbase/commands/ClientApiFunctionCommand.dart';

import '../../../cloudbase.dart';

class TapMomentVoteItemCommand extends ClientApiFunctionCommand<void> {
  @override
  String get commandName => 'moment:tapVoteItem';

  TapMomentVoteItemCommand(String momentId, String voteItem)
      : super({'momentId': momentId, 'vote': voteItem});

  @override
  deserializer(data, CloudBaseResponse response) {
    print(response);
    if (response.code != null) {
      throw UnimplementedError(response.message ?? '操作失败');
    }
  }
}
