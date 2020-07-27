import 'package:snsmax/cloudbase.dart';

class MomentLikeToggleCommand extends CloudBaseFunctionBaseCommand<void> {
  const MomentLikeToggleCommand(String momentId) : super(momentId);

  @override
  String get command => 'likeToggle';

  @override
  void deserializer(data, CloudBaseResponse response) {}

  @override
  // TODO: implement functionName
  String get functionName => 'snsmax-moment';
}
