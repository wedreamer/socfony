import 'package:flutter/material.dart';

class MainExploreLayout extends StatefulWidget {
  const MainExploreLayout({Key key}) : super(key: key);

  @override
  _MainExploreLayoutState createState() => _MainExploreLayoutState();
}

class _MainExploreLayoutState extends State<MainExploreLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('推荐'),
      ),
    );
  }
}
