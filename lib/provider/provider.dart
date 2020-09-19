import 'package:fans/cloudbase/database/TcbDbCollectionsProvider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'AppAuthProvider.dart';
import 'MomentVoteHasSelectedProvider.dart';

class RootProvider extends StatelessWidget {
  const RootProvider({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppAuthProvider()),
        ChangeNotifierProvider.value(value: MomentVoteHasSelectedProvider()),
        ChangeNotifierProvider.value(value: TcbDbCollectionsProvider()),
      ],
      child: child,
    );
  }
}
