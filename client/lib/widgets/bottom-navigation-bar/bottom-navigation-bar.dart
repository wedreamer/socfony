import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigationBar extends StatefulWidget {
  final PageController controller;

  const BottomNavigationBar({@required this.controller, Key key}): super(key: key);

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(indexListener);
  }

  void indexListener() {
    setState(() {
      index = widget.controller.page as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarColor,
              borderRadius: const BorderRadius.all(const Radius.circular(100)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: GNav(
                selectedIndex: index,
                gap: 10,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                iconSize: 24,
                activeColor: Theme.of(context).primaryColor,
                tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
                tabs: tabsBuilder(context),
                onTabChange: (int index) {
                  setState(() {
                    this.index = index;
                  });
//              widget.controller.jumpToPage(index);
                },
              )
            ),
          ),
        ),
      ),
    );
//    print(horizontal);
    return SafeArea(child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
//        color: Theme.of(context).bottomAppBarColor,
        borderRadius: const BorderRadius.all(const Radius.circular(100)),
      ),
      child: Container(
        width: 300,
          color: Theme.of(context).bottomAppBarColor,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: GNav(
            selectedIndex: index,
            gap: 10,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            iconSize: 24,
            activeColor: Theme.of(context).primaryColor,
            tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
            tabs: tabsBuilder(context),
            onTabChange: (int index) {
              setState(() {
                this.index = index;
              });
//              widget.controller.jumpToPage(index);
            },
          )
      ),
    ));
  }

  List<GButton> tabsBuilder(BuildContext context) {
    return [
      GButton(
        icon: Icons.home,
        text: '首页',
      ),
      GButton(
        icon: Icons.explore,
        text: '发现',
      ),
      GButton(
        icon: Icons.notifications,
        text: '消息',
      ),
      GButton(
        icon: Icons.person,
        text: '我的',
      )
    ];
  }
}
