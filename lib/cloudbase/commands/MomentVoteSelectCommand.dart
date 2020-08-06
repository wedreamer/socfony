import 'package:snsmax/cloudbase.dart';

class MomentVoteSelectCommand extends CloudBaseFunctionBaseCommand<void> {
  MomentVoteSelectCommand(String momentId, String vote)
      : super({"momentId": momentId, "vote": vote});

  @override
  String get command => 'selectVote';

  @override
  void deserializer(data, CloudBaseResponse response) {}

  @override
  String get functionName => 'snsmax-moment';
}
