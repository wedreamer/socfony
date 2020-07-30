import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:snsmax/cloudbase/database/businesses/HomeRecommendMomentsBusiness.dart';
import 'package:snsmax/models/moment.dart';
import 'package:snsmax/widgets/docs/MomentDocBuilder.dart';
import 'package:snsmax/widgets/empty.dart';

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
      await business.refresh();
      refreshController.finishRefresh(
        success: true,
        noMore: business.isEmpty,
      );
    } catch (e) {
      refreshController.finishRefresh(success: false);
    }
  }

  Future<void> onLoadMore() async {
    try {
      final length = await business.loadMore();
      refreshController.finishLoad(success: true, noMore: length <= 0);
    } catch (e) {
      refreshController.finishLoad(success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        child: EasyRefresh.custom(
          scrollController: scrollController,
          controller: refreshController,
          onRefresh: onRefresh,
          onLoad: onLoadMore,
          emptyWidget: emptyBuilder(),
          firstRefresh: true,
          firstRefreshWidget: Center(
            child: GFLoader(type: GFLoaderType.circle),
          ),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                  top: staggeredTile.crossAxisCellCount == 6 ? 0 : 12),
            ),
            SliverSafeArea(
              sliver: SliverStaggeredGrid.countBuilder(
                itemCount: business.ids?.length ?? 0,
                itemBuilder: childBuilder,
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: staggeredTile.crossAxisCellCount == 6 ? 8 : 12,
                staggeredTileBuilder: (int index) => staggeredTile,
              ),
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

  Widget emptyBuilder() {
    if (business.isEmpty) {
      return Empty(
        type: EmptyTypes.ghost,
        text: '暂无推荐内容哦',
      );
    }

    return null;
  }

  Widget childBuilder(BuildContext context, int index) {
    final id = business.ids.toList()[index];
    return MomentDocBuilder(
        id: id,
        builder: (BuildContext context, Moment moment) {
          return MomentListTile(moment);
        });
  }
}
