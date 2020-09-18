import 'package:fans/widgets/cloudbase/database/collections/TcbDbMomentDocBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fans/cloudbase/database/businesses/HomeGeoNearMomentsBusiness.dart';
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
  RefreshController refreshController;
  HomeGeoNearMomentsBusiness business;
  Position position;
  bool showGeoLocator;
  bool noPositioningPermission;

  @override
  void initState() {
    showGeoLocator = true;
    scrollController = ScrollController();
    refreshController = RefreshController(initialRefresh: true);
    business = HomeGeoNearMomentsBusiness();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      geoLocator();
    });
    super.initState();
  }

  @override
  void setState([fn]) {
    fn = fn ?? () {};
    mounted ? super.setState(fn) : fn();
  }

  Future<void> onRefresh() async {
    try {
      await business.refresh(position);
      setState(() {
        refreshController.refreshCompleted(resetFooterState: true);
      });
    } catch (e) {
      setState(() {
        refreshController.refreshFailed();
      });
    }
  }

  Future<void> onLoadMore() async {
    try {
      final length = await business.loadMore(position);
      setState(() {
        length > 0
            ? refreshController.loadComplete()
            : refreshController.loadNoData();
      });
    } catch (e) {
      setState(() {
        refreshController.loadFailed();
      });
    }
  }

  Future<void> geoLocator() async {
    setState(() {
      showGeoLocator = true;
    });
    try {
      final Position value = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      setState(() {
        position = value;
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        setState(() {
          noPositioningPermission = true;
        });
      } else {
        setState(() {
          position = null;
        });
      }
    } catch (e) {
      setState(() {
        position = null;
      });
    } finally {
      setState(() {
        showGeoLocator = false;
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

    if (showGeoLocator == true) {
      return geoLocatorWidgetBuilder(context);
    } else if (noPositioningPermission == true) {
      return noPositioningPermissionWidgetBuilder(context);
    } else if (position == null) {
      return noPositionWidgetBuilder(context);
    }

    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        child: SmartRefresher(
          controller: refreshController,
          scrollController: scrollController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: onRefresh,
          onLoading: onLoadMore,
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(
                    top: staggeredTile.crossAxisCellCount == 6 ? 0 : 12),
              ),
              if (business.isEmpty) buildSliverEmptyCard(context),
              SliverStaggeredGrid.countBuilder(
                itemCount: business.ids?.length ?? 0,
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

  SliverToBoxAdapter buildSliverEmptyCard(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
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
                  onPressed: refreshController.requestRefresh,
                  icon: Icon(Icons.refresh),
                  label: Text('刷新'),
                ),
                RaisedButton.icon(
                  color: Theme.of(context).primaryColor,
                  shape: StadiumBorder(),
                  onPressed: refreshController.requestRefresh,
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
            onPressed: geoLocator,
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
            onPressed: geoLocator,
            icon: Icon(Icons.refresh),
            label: Text('重新获取'),
            shape: StadiumBorder(),
          )
        ],
      ),
    );
  }
}
