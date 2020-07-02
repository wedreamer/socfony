import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:snsmax/widgets/bottom-navigation-bar/bottom-navigation-bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('222'),
      bottomNavigationBar: BottomNavigationBar(
        controller: controller,
      ),
    );
  }
}
