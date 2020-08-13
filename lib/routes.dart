import 'package:flutter/material.dart';
import 'package:snsmax/pages/login.dart';

import 'pages/CreateTopicPage.dart';
import 'pages/TopicSquare.dart';
import 'pages/main.dart';
import 'pages/vote-setter.dart';

const String R_initialRoute = 'Login';

final Map<String, WidgetBuilder> routes = {
  'main': (BuildContext context) => const MainPage(),
  "vote-setter": (_) => VoteSetterPage.routeBuilder(_),
  "TopicSquare": (_) => TopicSquare(),
  "CreateTopicPage": (_) => CreateTopicPage(),
  "Login": (_) => LoginPage(),
};
