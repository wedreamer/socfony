import 'package:flutter/material.dart';
import 'package:snsmax/widgets/home/new-moments.dart';

class MainHomeLayout extends StatefulWidget {
  const MainHomeLayout({Key key}): super(key: key);

  @override
  _MainHomeLayoutState createState() => _MainHomeLayoutState();
}

class _MainHomeLayoutState extends State<MainHomeLayout> with SingleTickerProviderStateMixin<MainHomeLayout>, AutomaticKeepAliveClientMixin<MainHomeLayout> {
  TabController controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: controller,
          tabs: tabBarBuilder(context),
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          indicator: const UnderlineTabIndicator(borderSide: BorderSide.none),
          unselectedLabelStyle: Theme.of(context).textTheme.subtitle1,
          unselectedLabelColor: Theme.of(context).textTheme.subtitle1.color,
          labelStyle: Theme.of(context).textTheme.headline6,
          labelColor: Theme.of(context).primaryColor,
        ),
        centerTitle: false,
        actions: actionsBuilder(context),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          const HomeNewMoments(),
          Text('2')
        ],
      ),
    );
  }

  List<Widget> tabBarBuilder(BuildContext context) {
    return [
      Tab(text: '最新',),
      Tab(text: '推荐',)
    ];
  }
  
  Widget leadingBuilder(BuildContext context) {
    return IconButton(icon: Icon(Icons.search), onPressed: () {});
  }

  List<Widget> actionsBuilder(BuildContext context) {
    return [
      leadingBuilder(context),
      sendMomentActionBuilder(context),
    ];
  }

  Widget sendMomentActionBuilder(BuildContext context) {
    return FlatButton.icon(
      onPressed: () {},
      textColor: Theme.of(context).primaryColor,
      icon: Icon(Icons.camera_alt),
      label: Text("发动态"),
    );
  }
}
