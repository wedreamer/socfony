import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/getwidget.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/media.dart';
import 'package:snsmax/models/moment.dart';
import 'package:snsmax/models/user.dart' hide UserBuilder;
import 'package:snsmax/provider/collections/moments.dart';
import 'package:snsmax/widgets/cached-network-image.dart';
import 'package:snsmax/widgets/scroll-back-top-button.dart';
import 'package:snsmax/utils/date-time-extension.dart';
import 'package:provider/provider.dart';
import 'package:snsmax/widgets/user-builder.dart';

class HomeNewMoments extends StatefulWidget {
  const HomeNewMoments({Key key}) : super(key: key);

  @override
  _HomeNewMomentsState createState() => _HomeNewMomentsState();
}

class _HomeNewMomentsState extends State<HomeNewMoments>
    with AutomaticKeepAliveClientMixin<HomeNewMoments> {
  @override
  bool get wantKeepAlive => true;

  ScrollController scrollController;
  List<String> moments = [];

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(onFetchMomentCount);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onFetchMomentCount(Duration duration) async {
    await Future.delayed(duration);
    CancelFunc onClose = BotToast.showLoading();
    await onRefreshMomentCount();
    onClose();
  }

  Future<void> onRefreshMomentCount() async {
    try {
      final DbQueryResponse result = await CloudBase()
          .database
          .collection('moments')
          .orderBy("createdAt", "desc")
          .limit(20)
          .get();
      List<Moment> _moments =
          (result.data as List)?.map((e) => Moment.fromJson(e))?.toList();
      context.read<MomentsCollection>().insertOrUpdate(_moments);
      setState(() {
        moments = _moments.map((e) => e.id).toList();
      });
    } catch (e) {
      print(e);
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

    if (moments == null || moments.isEmpty) {
      return SizedBox();
    }

    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        child: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: onRefreshMomentCount,
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(
                    top: staggeredTile.crossAxisCellCount == 6 ? 0 : 12),
              ),
              SliverSafeArea(
                sliver: SliverStaggeredGrid.countBuilder(
                  itemCount: moments.length ?? 0,
                  itemBuilder: childBuilder,
                  crossAxisCount: 6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing:
                      staggeredTile.crossAxisCellCount == 6 ? 8 : 12,
                  staggeredTileBuilder: (int index) => staggeredTile,
                ),
              ),
            ],
          ),
//          child: ListView.builder(
//            itemBuilder: childBuilder,
//            itemCount: moments?.length ?? 0,
//          ),
        ),
      ),
      floatingActionButton: Container(
        child: ScrollBackTopButton(scrollController),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget childBuilder(BuildContext context, int index) {
    return MomentCard(id: moments[index]);
  }
}

class MomentCard extends StatelessWidget {
  const MomentCard({
    Key key,
    @required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: context.select<MomentsCollection, List<Widget>>((value) {
            if (!value.containsKey(id)) {
              return [];
            }

            Moment moment = value[id];

            return [
              UserBuilder(
                id: moment.userId,
                builder: (BuildContext context, User user) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 24,
                    ),
                    title: Text(
                        user.nickName ?? "用户" + user.id.hashCode.toString()),
                    subtitle: Text(moment.createdAt.formNow),
                    trailing: Icon(Icons.more_vert),
                  );
                },
              ),
              buildText(moment),
              MomentImageCard(
                moment: moment,
                margin: EdgeInsets.symmetric(vertical: 6),
              ),
              MomentVideoCard(
                moment: moment,
                margin: EdgeInsets.symmetric(vertical: 6),
              ),
              MomentAudioCard(
                moment: moment,
                margin: EdgeInsets.symmetric(vertical: 6),
              ),
            ];
          }),
        ),
      ),
    );
  }

  Widget buildText(Moment moment) {
    if (moment.audio is MediaAudio) {
      return SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Text(moment.text),
    );
  }
}

class MomentAudioCard extends StatelessWidget {
  const MomentAudioCard({
    Key key,
    @required this.moment,
    this.margin,
  }) : super(key: key);

  final Moment moment;
  final EdgeInsets margin;
  MediaAudio get audio => moment.audio;
  bool get allowBuildWidget => audio is MediaAudio;

  @override
  Widget build(BuildContext context) {
    if (allowBuildWidget != true) {
      return SizedBox();
    }
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: AspectRatio(
          aspectRatio: 2.6,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  'assets/audio-bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            verticalDirection: VerticalDirection.up,
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                moment.text,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                              )),
                              SizedBox(width: 12),
                              LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/audio-bg.jpg'),
                                    radius: constraints.maxHeight / 2,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(36),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        GFProgressBar(
                          progressBarColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.white.withOpacity(0.4),
                          lineHeight: 2.0,
                          percentage: 0.02,
                          leading: Text(
                            "00:00",
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          trailing: Text(
                            '3′5″',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
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

class MomentVideoCard extends StatelessWidget {
  const MomentVideoCard({
    Key key,
    @required this.moment,
    this.margin,
  }) : super(key: key);

  final Moment moment;
  final EdgeInsets margin;

  MediaVideo get video => moment.video;
  bool get allowBuild => video is MediaVideo;

  @override
  Widget build(BuildContext context) {
    if (!allowBuild) {
      return SizedBox();
    }
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: CachedNetworkImage(
                  fileId: video.cover,
                  fit: BoxFit.cover,
                  rule: "imageMogr2/scrop/854x480/cut/854x480/format/yjpeg",
                ),
              ),
              Positioned.fill(
                child: UnconstrainedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.black45,
                    onPressed: () {},
                    child: Icon(
                      Icons.play_arrow,
                      size: 48,
                    ),
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

class MomentImageCard extends StatelessWidget {
  const MomentImageCard({
    Key key,
    @required this.moment,
    this.margin,
  }) : super(key: key);

  final Moment moment;
  final EdgeInsets margin;

  List<String> get images => moment.images?.toList();

  bool get allowRunBuild => images is List && images.isNotEmpty;

  int get length => images?.length ?? 0;

  double get childAspectRatio {
    switch (length) {
      case 1:
        return 16 / 9;
      case 2:
      case 4:
        return 1.5;
      default:
        return 1.0;
    }
  }

  int get crossAxisCount {
    if (length <= 2) {
      return length;
    } else if (length == 4) {
      return 2;
    }

    return 3;
  }

  String get rule {
    switch (length) {
      case 1:
        return "imageMogr2/scrop/854x480/cut/854x480/format/yjpeg";
      case 2:
      case 4:
        return "imageMogr2/scrop/432x288/cut/432x288/format/yjpeg";
      default:
        return "imageMogr2/scrop/360x360/cut/360x360/format/yjpeg";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allowRunBuild != true) {
      return SizedBox();
    }

    return GridView.builder(
      padding: margin ?? EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          child: CachedNetworkImage(
            fileId: images[index],
            fit: BoxFit.cover,
            rule: rule,
          ),
          borderRadius: BorderRadius.circular(6),
        );
      },
      itemCount: images.length,
    );
  }
}
