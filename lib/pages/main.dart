//import 'package:fans/widgets/bottom-navigation-bar/bottom-navigation-bar.dart';
import 'package:fans/widgets/MainMessageTabView.dart';
import 'package:fans/widgets/explore/layout.dart';
import 'package:fans/widgets/home/layout.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

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
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
          const MainHomeLayout(),
          const MainExploreLayout(),
          const MainMessageTabView(),
        ],
      ),
      bottomNavigationBar: _NavigationBar(controller: controller),
    );
  }
}

class _NavigationBar extends StatefulWidget {
  const _NavigationBar({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  __NavigationBarState createState() => __NavigationBarState();
}

class __NavigationBarState extends State<_NavigationBar> {
  int index;

  @override
  void initState() {
    index = widget.controller.initialPage;
    widget.controller.addListener(() {
      setState(() {
        index = widget.controller.page.toInt();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (value) {
        widget.controller.jumpToPage(value);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          title: Text('Fans'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          title: Text('发现'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text('消息'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('我的'),
        ),
      ],
    );
  }
}
