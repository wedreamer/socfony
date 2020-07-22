import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:snsmax/provider/auth.dart';
import 'package:snsmax/provider/cached-network-file.dart';
import 'package:snsmax/provider/collections/moments.dart';
import 'package:snsmax/provider/collections/users.dart';

class RootProvider extends StatelessWidget {
  const RootProvider({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MomentsCollection()),
        ChangeNotifierProvider(create: (_) => UsersCollection()),
        ChangeNotifierProvider(create: (_) => CachedNetworkFileProvider()),
      ],
      child: child,
    );
  }
}
