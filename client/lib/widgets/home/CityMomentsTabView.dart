import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CityMomentsTabView extends StatefulWidget {
  @override
  _CityMomentsTabViewState createState() => _CityMomentsTabViewState();
}

class _CityMomentsTabViewState extends State<CityMomentsTabView> {
  ScrollController scrollController;
  RefreshController refreshController;

  @override
  void initState() {
    scrollController = ScrollController();
    refreshController = RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        child: SmartRefresher(
          controller: refreshController,
          scrollController: scrollController,
          enablePullDown: false,
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Card(
                  elevation: 0,
                  shape: StadiumBorder(),
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: ListTile(
                    onTap: () {},
                    dense: true,
                    title: Text('成都市'),
                    leading: Icon(Icons.location_on),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
