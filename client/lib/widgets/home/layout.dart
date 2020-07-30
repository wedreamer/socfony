import 'package:flutter/material.dart';
import 'package:snsmax/pages/publish.dart';
import 'package:snsmax/widgets/custom-underline-tab-indicator.dart';
import 'package:snsmax/widgets/home/RecommendTabView.dart';

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
          indicator: CustomUnderlineTabIndicator(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 3.0,
            ),
            insets: EdgeInsets.only(bottom: 4.0),
          ),
          indicatorWeight: 0,
          isScrollable: true,
          unselectedLabelStyle: Theme.of(context).textTheme.subtitle1,
          unselectedLabelColor: Theme.of(context).textTheme.subtitle1.color,
          labelStyle: Theme.of(context).textTheme.headline6,
          labelColor: Theme.of(context).primaryColor,
        ),
        centerTitle: true,
        actions: actionsBuilder(context),
        leading: FlatButton(
          onPressed: () {},
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
      color: Theme.of(context).primaryColor,
      icon: Transform.rotate(
        child: Icon(Icons.send),
        angle: 125.0,
      ),
      tooltip: "发布动态",
    );
  }

  onSendMoment() {
    PublishPage.route(context);
  }
}
