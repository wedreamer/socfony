import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'cached-network-file.dart';
import 'collections/moments.dart';
import 'collections/users.dart';
import 'moment-like-histories-provider.dart';

class RootProvider extends StatelessWidget {
  const RootProvider({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MomentsCollection()),
        ChangeNotifierProvider(create: (_) => UsersCollection()),
        ChangeNotifierProvider(create: (_) => CachedNetworkFileProvider()),
        ChangeNotifierProvider(create: (_) => MomentLikeHistoriesProvider()),
      ],
      child: child,
    );
  }
}
