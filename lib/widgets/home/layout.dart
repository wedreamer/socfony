import 'package:flutter/material.dart';
import 'package:fans/pages/publish.dart';
import 'package:fans/widgets/home/RecommendTabView.dart';

import 'CityMomentsTabView.dart';
import 'FollowingMomentsWidget.dart';

class MainHomeLayout extends StatefulWidget {
  const MainHomeLayout({Key key}) : super(key: key);

  @override
  _MainHomeLayoutState createState() => _MainHomeLayoutState();
}

class _MainHomeLayoutState extends State<MainHomeLayout>
    with
        SingleTickerProviderStateMixin<MainHomeLayout>,
        AutomaticKeepAliveClientMixin<MainHomeLayout> {
  TabController controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: controller,
          tabs: tabBarBuilder(context),
          isScrollable: true,
          unselectedLabelStyle: Theme.of(context).textTheme.subtitle1,
          labelStyle: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        actions: actionsBuilder(context),
        leading: FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, 'TopicSquare');
          },
          child: Text('话题'),
          padding: EdgeInsets.zero,
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          FollowingMomentsWidget(),
          RecommendTabView(),
          CityMomentsTabView(),
        ],
      ),
    );
  }

  List<Widget> tabBarBuilder(BuildContext context) {
    return [
      Tab(text: '关注'),
      Tab(text: '推荐'),
      Tab(text: '同城'),
    ];
  }

  List<Widget> actionsBuilder(BuildContext context) {
    return [
      sendMomentActionBuilder(context),
    ];
  }

  Widget sendMomentActionBuilder(BuildContext context) {
    return IconButton(
      onPressed: onSendMoment,
      icon: Transform.rotate(
        child: Icon(Icons.send),
        angle: 125.0,
      ),
      tooltip: "发布动态",
      color: Theme.of(context).primaryColor,
    );
  }

  onSendMoment() {
    PublishPage.route(context);
  }
}
