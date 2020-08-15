import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fans/cloudbase/database/businesses/HomeRecommendMomentsBusiness.dart';
import 'package:fans/models/moment.dart';
import 'package:fans/widgets/docs/MomentDocBuilder.dart';

import '../MomentListTile.dart';
import '../scroll-back-top-button.dart';

class RecommendTabView extends StatefulWidget {
  @override
  _RecommendTabViewState createState() => _RecommendTabViewState();
}

class _RecommendTabViewState extends State<RecommendTabView>
    with AutomaticKeepAliveClientMixin<RecommendTabView> {
  ScrollController scrollController;
  RefreshController refreshController;
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
    refreshController = RefreshController(initialRefresh: true);
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
      await business.refresh();
      refreshController.refreshCompleted(resetFooterState: true);
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  Future<void> onLoadMore() async {
    try {
      final length = await business.loadMore();
      length > 0
          ? refreshController.loadComplete()
          : refreshController.loadNoData();
    } catch (e) {
      refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SmartRefresher(
        cacheExtent: 5,
        controller: refreshController,
        scrollController: scrollController,
        onRefresh: onRefresh,
        onLoading: onLoadMore,
        enablePullDown: true,
        enablePullUp: true,
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(
                  top: staggeredTile.crossAxisCellCount == 6 ? 0 : 12),
            ),
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
    final id = business.ids.toList()[index];
    return MomentDocBuilder(
        id: id,
        builder: (BuildContext context, Moment moment) {
          return MomentListTile(moment);
        });
  }
}
