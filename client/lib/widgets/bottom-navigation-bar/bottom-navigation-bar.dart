import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:snsmax/l10n/localization.dart';

class BottomNavigationBar extends StatefulWidget {
  final PageController controller;

  const BottomNavigationBar({@required this.controller, Key key})
      : super(key: key);

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
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: UnconstrainedBox(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 10)
              .copyWith(bottom: padding.bottom > 0 ? 0 : 20, top: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor,
            borderRadius: const BorderRadius.all(const Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).hoverColor,
                offset: Offset(0,
                    Theme.of(context).brightness == Brightness.dark ? 0.5 : 2),
                blurRadius:
                    Theme.of(context).brightness == Brightness.dark ? 1 : 4,
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).hoverColor,
                offset: Offset(0,
                    Theme.of(context).brightness == Brightness.dark ? 0.5 : 2),
                blurRadius:
                    Theme.of(context).brightness == Brightness.dark ? 0 : 4,
              ),
            ],
          ),
          child: GNav(
            selectedIndex: index,
            gap: 10,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            iconSize: 24,
            activeColor: Theme.of(context).primaryColor,
            tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
            tabs: tabsBuilder(context),
            onTabChange: onTabChange,
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
