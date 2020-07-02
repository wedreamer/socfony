import 'package:flutter/material.dart';

class MainHomeLayout extends StatefulWidget {
  const MainHomeLayout({Key key}): super(key: key);

  @override
  _MainHomeLayoutState createState() => _MainHomeLayoutState();
}

class _MainHomeLayoutState extends State<MainHomeLayout> with SingleTickerProviderStateMixin<MainHomeLayout> {
  TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: controller,
          tabs: tabBarBuilder(context),
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
        ),
        centerTitle: true,
        leading: leadingBuilder(context),
        actions: actionsBuilder(context),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          Text('1'),
          Text('2')
        ],
      ),
    );
  }

  List<Widget> tabBarBuilder(BuildContext context) {
    return [
      Text('最新'),
      Text('推荐'),
    ];
  }
  
  Widget leadingBuilder(BuildContext context) {
    return IconButton(icon: Icon(Icons.search), onPressed: () {});
  }

  List<Widget> actionsBuilder(BuildContext context) {
    return [
      sendMomentActionBuilder(context)
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
