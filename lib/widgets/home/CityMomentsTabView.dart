import 'package:fans/widgets/cloudbase/database/collections/TcbDbMomentDocBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fans/cloudbase/businesses/HomeGeoNearMomentsBusiness.dart';
import 'package:fans/models/moment.dart';
import 'package:fans/widgets/empty.dart';

import '../MomentListTile.dart';

class CityMomentsTabView extends StatefulWidget {
  @override
  _CityMomentsTabViewState createState() => _CityMomentsTabViewState();
}

class _CityMomentsTabViewState extends State<CityMomentsTabView>
    with AutomaticKeepAliveClientMixin<CityMomentsTabView> {
  ScrollController scrollController;
  EasyRefreshController refreshController;
  HomeGeoNearMomentsBusiness business;
  Position position;

  @override
  void initState() {
    scrollController = ScrollController();
    refreshController = refreshController = EasyRefreshController();
    business = HomeGeoNearMomentsBusiness();
    super.initState();
  }

  @override
  void setState([fn]) {
    fn = fn ?? () {};
    mounted ? super.setState(fn) : fn();
  }

  Future<void> onRefresh() async {
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      final int length = await business.refresh(position);
      refreshController.finishRefreshCallBack(
        success: true,
        noMore: length <= 0,
      );
    } catch (e) {
      setState(() {
        refreshController.finishRefreshCallBack(success: false);
      });
    }
  }

  Future<void> onLoadMore() async {
    try {
      final length = await business.loadMore(position);
      refreshController.finishLoadCallBack(success: true, noMore: length <= 0);
    } catch (e) {
      setState(() {
        refreshController.finishLoadCallBack(success: false);
      });
    }
  }

  bool get isPhone {
    return MediaQuery.of(context).size.shortestSide < 600;
  }

  bool get isPortrait {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  StaggeredTile get staggeredTile {
    if (isPhone && isPortrait) {
      return const StaggeredTile.fit(6);
    } else if (isPhone && !isPortrait) {
      return const StaggeredTile.fit(3);
    }

    return const StaggeredTile.fit(2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        child: EasyRefresh(
          controller: refreshController,
          scrollController: scrollController,
          emptyWidget: buildSliverEmptyCard(context),
          onRefresh: onRefresh,
          onLoad: onLoadMore,
          firstRefresh: false,
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(
                    top: staggeredTile.crossAxisCellCount == 6 ? 0 : 12),
              ),
              // if (business.ids?.length is int && business.ids.length > 0)
              SliverStaggeredGrid.countBuilder(
                itemCount: business.ids?.length ?? 1,
                itemBuilder: childBuilder,
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: staggeredTile.crossAxisCellCount == 6 ? 8 : 12,
                staggeredTileBuilder: (int index) => staggeredTile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget childBuilder(BuildContext context, int index) {
    final id = business.ids.toList().elementAt(index);
    return TcbDbMomentDocBuilder(
      momentId: id,
      builder: (BuildContext context, AsyncSnapshot<Moment> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return MomentListTile(snapshot.data);
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget buildSliverEmptyCard(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        children: <Widget>[
          SizedBox(height: 12),
          ListTile(
            title: Text('当前城市还没有动态哦'),
            subtitle: Text('你可以下拉刷新检查是否有新动态，或者来成为这个城市的开拓者吧'),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton.icon(
                shape: StadiumBorder(),
                onPressed: refreshController.callRefresh,
                icon: Icon(Icons.refresh),
                label: Text('刷新'),
              ),
              RaisedButton.icon(
                color: Theme.of(context).primaryColor,
                shape: StadiumBorder(),
                onPressed: refreshController.callRefresh,
                icon: Transform.rotate(
                  child: Icon(Icons.send),
                  angle: 125.0,
                ),
                label: Text('发动态'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget geoLocatorWidgetBuilder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.location_on),
            Text(
              '定位中...',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
        SizedBox(height: 12),
        GFLoader(type: GFLoaderType.circle),
      ],
    );
  }

  Widget noPositioningPermissionWidgetBuilder(BuildContext context) {
    return Empty(
      type: EmptyTypes.ghost,
      child: Column(
        children: <Widget>[
          SizedBox(height: 12),
          SizedBox(
            width: 260,
            child: Text(
              '未开启位置权限，「同城」功能需要你开启位置权限来确定你当前的位置！\n请开启权限后点击下方「重新获取」按钮',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 12),
          RaisedButton.icon(
            onPressed: refreshController.callRefresh,
            icon: Icon(Icons.refresh),
            label: Text('重新获取'),
            shape: StadiumBorder(),
          )
        ],
      ),
    );
  }

  Widget noPositionWidgetBuilder(BuildContext context) {
    return Empty(
      type: EmptyTypes.ghost,
      child: Column(
        children: <Widget>[
          SizedBox(height: 12),
          SizedBox(
            width: 260,
            child: Text(
              '可能由于网络原因获取位置失败，请点击下方「重新获取」按钮重试\n如果依旧失败，请确保网络良好情况下重启 App',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 12),
          RaisedButton.icon(
            onPressed: refreshController.callRefresh,
            icon: Icon(Icons.refresh),
            label: Text('重新获取'),
            shape: StadiumBorder(),
          )
        ],
      ),
    );
  }
}
