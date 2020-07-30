import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:snsmax/cloudbase/database/businesses/following-moments.dart';
import 'package:snsmax/models/moment.dart';
import 'package:snsmax/widgets/docs/MomentDocBuilder.dart';
import 'package:snsmax/widgets/MomentListTile.dart';

import '../empty.dart';
import '../scroll-back-top-button.dart';

class FollowingMomentsWidget extends StatefulWidget {
  @override
  _FollowingMomentsWidgetState createState() => _FollowingMomentsWidgetState();
}

class _FollowingMomentsWidgetState extends State<FollowingMomentsWidget>
    with AutomaticKeepAliveClientMixin<FollowingMomentsWidget> {
  ScrollController scrollController;
  EasyRefreshController refreshController;
  FollowingMomentsBusiness business;

  @override
  void initState() {
    refreshController = EasyRefreshController();
    scrollController = ScrollController();
    business = FollowingMomentsBusiness();
    business.addListener(setState);
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
        noMore: business.ids.isEmpty,
      );
    } catch (e) {
      refreshController.finishRefresh(success: false);
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
        isAlwaysShown: false,
        controller: scrollController,
        child: EasyRefresh.custom(
          scrollController: scrollController,
          controller: refreshController,
          firstRefresh: true,
          firstRefreshWidget: Center(
            child: GFLoader(type: GFLoaderType.circle),
          ),
          onRefresh: onRefresh,
          emptyWidget: buildEmpty(),
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

  Widget buildEmpty() {
    return (business.ids?.isEmpty ?? true)
        ? Empty(
            type: EmptyTypes.ghost,
            text: '参与话题和关注其他用户可以获得',
          )
        : null;
  }

  Widget childBuilder(BuildContext context, int index) {
    final id = business.ids.toList()[index];
    return MomentDocBuilder(
        id: id,
        builder: (BuildContext context, Moment moment) {
          return MomentListTile(moment);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
