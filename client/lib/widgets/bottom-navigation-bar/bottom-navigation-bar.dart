import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:snsmax/l10n/localization.dart';

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

  @override
  void dispose() {
    widget.controller.removeListener(indexListener);
    super.dispose();
  }

  void indexListener() {
    setState(() {
      index = widget.controller.page.toInt();
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
                onTabChange: onTabChange,
              )
            ),
          ),
        ),
      ),
    );
  }

  List<GButton> tabsBuilder(BuildContext context) {
    return [
      GButton(
        icon: Icons.camera,
        text: AppLocalizations.of(context).navigationBar.moment,
      ),
      GButton(
        icon: Icons.explore,
        text: AppLocalizations.of(context).navigationBar.explore,
      ),
      GButton(
        icon: Icons.notifications,
        text: AppLocalizations.of(context).navigationBar.notification,
      ),
      GButton(
        icon: Icons.person,
        text: AppLocalizations.of(context).navigationBar.me,
      )
    ];
  }

  void onTabChange(int page) {
    widget.controller.jumpToPage(page);
  }
}
