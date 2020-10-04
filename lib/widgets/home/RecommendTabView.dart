import 'package:fans/widgets/cloudbase/database/collections/TcbDbMomentDocBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fans/cloudbase/businesses/HomeRecommendMomentsBusiness.dart';
import 'package:fans/models/moment.dart';

import '../MomentListTile.dart';
import '../scroll-back-top-button.dart';

class RecommendTabView extends StatefulWidget {
  @override
  _RecommendTabViewState createState() => _RecommendTabViewState();
}

class _RecommendTabViewState extends State<RecommendTabView>
    with AutomaticKeepAliveClientMixin<RecommendTabView> {
  ScrollController scrollController;
  EasyRefreshController refreshController;
  HomeRecommendMomentsBusiness business;

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
  void initState() {
    scrollController = ScrollController();
    refreshController = EasyRefreshController();
    business = HomeRecommendMomentsBusiness()..addListener(setState);
    super.initState();
  }

  @override
  void setState([fn]) {
    fn = fn ?? () {};
    mounted ? super.setState(fn) : fn();
  }

  Future<void> onRefresh() async {
    try {
      final int length = await business.refresh();
      refreshController.finishRefreshCallBack(
        success: true,
        noMore: length <= 0,
      );
    } catch (e) {
      refreshController.finishRefreshCallBack(success: false);
    }
  }

  Future<void> onLoadMore() async {
    try {
      final length = await business.loadMore();
      refreshController.finishLoadCallBack(success: true, noMore: length <= 0);
    } catch (e) {
      refreshController.finishLoadCallBack(success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // body: SmartRefresher(
      //   cacheExtent: 5,
      //   controller: refreshController,
      //   scrollController: scrollController,
      //   onRefresh: onRefresh,
      //   onLoading: onLoadMore,
      //   enablePullDown: true,
      //   enablePullUp: true,
      //   child: CustomScrollView(
      //     controller: scrollController,
      //     slivers: <Widget>[
      //       SliverPadding(
      //         padding: EdgeInsets.only(
      //             top: staggeredTile.crossAxisCellCount == 6 ? 0 : 12),
      //       ),
      //       SliverStaggeredGrid.countBuilder(
      //         itemCount: business.ids?.length ?? 0,
      //         itemBuilder: childBuilder,
      //         crossAxisCount: 6,
      //         crossAxisSpacing: 12,
      //         mainAxisSpacing: staggeredTile.crossAxisCellCount == 6 ? 8 : 12,
      //         staggeredTileBuilder: (int index) => staggeredTile,
      //       ),
      //     ],
      //   ),
      // ),
      body: EasyRefresh(
        controller: refreshController,
        scrollController: scrollController,
        onRefresh: onRefresh,
        onLoad: onLoadMore,
        firstRefresh: true,
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(
                  top: staggeredTile.crossAxisCellCount == 6 ? 0 : 12),
            ),
            if (business.ids?.length is int && business.ids.length > 0)
              SliverStaggeredGrid.countBuilder(
                itemCount: business.ids.length,
                itemBuilder: childBuilder,
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: staggeredTile.crossAxisCellCount == 6 ? 8 : 12,
                staggeredTileBuilder: (int index) => staggeredTile,
              ),
          ],
        ),
      ),
      floatingActionButton: Container(
        child: ScrollBackTopButton(scrollController),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget childBuilder(BuildContext context, int index) {
    final id = business.ids.elementAt(index);
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
}
