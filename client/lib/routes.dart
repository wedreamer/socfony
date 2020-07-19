import 'package:flutter/material.dart';
import 'package:snsmax/pages/main.dart';
import 'package:snsmax/pages/vote-setter.dart';

final Map<String, WidgetBuilder> routes = {
  'main': (BuildContext context) => const MainPage(),
  "vote-setter": (_) => VoteSetterPage.routeBuilder(_),
};
