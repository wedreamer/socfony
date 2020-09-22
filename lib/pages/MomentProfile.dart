import 'package:fans/models/moment.dart';
import 'package:fans/routes.dart';
import 'package:fans/widgets/cloudbase/database/collections/TcbDbMomentDocBuilder.dart';
import 'package:fans/widgets/cloudbase/storage/TcbStorageImageFileBuilder.dart';
import 'package:fans/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

typedef Widget _PanelWidgetBuilder(ScrollController controller);

class MomentProfileController with ChangeNotifier {
  MomentProfileController(
    this.momentId, {
    this.mediaAutoPlay = false,

    /// 分页控制器，指定 images 初始位置很有用
    PageController pageController,
  })  : this._pageController = (pageController is PageController
            ? pageController
            : PageController(initialPage: 0, keepPage: true)),
        this._pageViewChildrenIndex = (pageController?.initialPage ?? 0) + 1;

  /// 必须，动态 ID
  final String momentId;

  /// 是否自动播放媒体
  final bool mediaAutoPlay;

  final PageController _pageController;
  PageController get pageController => _pageController;

  bool _hasPanelIsOpen = false;
  bool get hasPanelIsOpen => _hasPanelIsOpen;
  set hasPanelIsOpen(bool newValue) {
    _hasPanelIsOpen = newValue;
    notifyListeners();
  }

  int _pageViewChildrenTotal = 0;
  int get pageViewChildrenTotal => _pageViewChildrenTotal;
  set pageViewChildrenTotal(int newValue) {
    _pageViewChildrenTotal = newValue;
    notifyListeners();
  }

  int _pageViewChildrenIndex = 1;
  int get pageViewChildrenIndex => _pageViewChildrenIndex;
  set pageViewChildrenIndex(int newValue) {
    _pageViewChildrenIndex = newValue;
    notifyListeners();
  }
}

class _MomentProfilePanelSettings {
  const _MomentProfilePanelSettings._();

  static bool get parallaxEnabled => true;
  static double get parallaxOffset => .4;
  static BorderRadius get borderRadius => const BorderRadius.vertical(
        top: const Radius.circular(24.0),
      );
  static double get minHeight => 100.0;
  static double get maxHeightRatio => .7;
  static double get tapBarContainerHeight => 24.0;
}

class MomentProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MomentProfileController controller =
        ModalRoute.of(context).settings.arguments;
    return ChangeNotifierProvider<MomentProfileController>.value(
      value: controller,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBarBuilder(context),
        body: bodyBuilder(context),
      ),
    );
  }

  SlidingUpPanel bodyBuilder(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height *
        _MomentProfilePanelSettings.maxHeightRatio;

    return SlidingUpPanel(
      parallaxEnabled: _MomentProfilePanelSettings.parallaxEnabled,
      parallaxOffset: _MomentProfilePanelSettings.parallaxOffset,
      borderRadius: _MomentProfilePanelSettings.borderRadius,
      minHeight: _MomentProfilePanelSettings.minHeight,
      maxHeight: maxHeight,
      color: Theme.of(context).cardColor,
      panelBuilder: panelBuilder(context),
      header: _MomentProfilePanelTapBar(),
      body: _MomentProfilePageView(),
    );
  }

  _PanelWidgetBuilder panelBuilder(BuildContext context) {
    return (ScrollController controller) => _MomentProfilePanel(controller);
  }

  AppBar appBarBuilder(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.color.withOpacity(0.12),
      leading: CloseButton(
        onPressed: () {
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            return navigator.pop();
          }

          navigator.pushReplacementNamed(R_initialRoute);
        },
      ),
      centerTitle: true,
      title: _ProgressIndicator(),
      actions: [
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MomentProfileController, MapEntry<int, int>>(
      shouldRebuild: (oldValue, newValue) {
        return oldValue != newValue;
      },
      selector: (_, provider) {
        return MapEntry(
          provider.pageViewChildrenIndex,
          provider.pageViewChildrenTotal,
        );
      },
      builder: (_, progress, __) {
        final index = progress.key;
        final total = progress.value;

        if (total is int && total > 1) {
          return Text(
            '$index/$total',
            style: Theme.of(context).textTheme.bodyText1,
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}

class _MomentProfilePanelTapBar extends StatelessWidget {
  const _MomentProfilePanelTapBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final Color tapBarColor = media.platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final double tabBarHeight = 6.0;
    final double tabBarWidget = 64.0;
    return Container(
      width: media.size.width,
      height: _MomentProfilePanelSettings.tapBarContainerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: _MomentProfilePanelSettings.borderRadius,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: tabBarWidget,
          height: tabBarHeight,
          decoration: BoxDecoration(
            color: tapBarColor,
            borderRadius: BorderRadius.circular(tabBarHeight),
          ),
        ),
      ),
    );
  }
}

class _MomentProfilePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: _MomentProfilePanelSettings.minHeight -
            _MomentProfilePanelSettings.tapBarContainerHeight,
      ),
      child: Selector<MomentProfileController, String>(
        builder: momentBuilder,
        selector: momentIdSelector,
      ),
    );
  }

  Widget momentBuilder(BuildContext context, String momentId, _) {
    return TcbDbMomentDocBuilder(
      momentId: momentId,
      builder: asyncSnapshotBuilder,
    );
  }

  Widget asyncSnapshotBuilder(
    BuildContext context,
    AsyncSnapshot<Moment> snapshot,
  ) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Empty(
          type: EmptyTypes.network,
          text: '网络貌似发生了错误',
        );
        break;
      case ConnectionState.active:
      case ConnectionState.waiting:
        return Empty(
          type: EmptyTypes.package,
          child: GFLoader(
            type: GFLoaderType.circle,
          ),
        );
        break;
      case ConnectionState.done:
        return selectorBuilder(snapshot.data);
        break;
    }

    return Empty(
      type: EmptyTypes.ghost,
      text: '当前动态貌似走丢了',
    );
  }

  Widget selectorBuilder(Moment moment) {
    return Selector<MomentProfileController, PageController>(
      shouldRebuild: (_, __) => false,
      selector: pageControllerSelector,
      builder: (BuildContext context, PageController controller, __) {
        final List<Widget> children = mediaBuilder(context, moment);
        return PageView(
          children: children,
          controller: controller,
          onPageChanged: (int page) {
            context.read<MomentProfileController>().pageViewChildrenIndex =
                page + 1;
          },
        );
      },
    );
  }

  List<Widget> mediaBuilder(BuildContext context, Moment moment) {
    if (moment.images != null || moment.images.isNotEmpty) {
      return mediaImagesBuilder(context, moment.images.toList());
    }

    return [Text('22222')];
  }

  List<Widget> mediaImagesBuilder(BuildContext context, List<String> images) {
    final provider =
        Provider.of<MomentProfileController>(context, listen: false);
    Future.delayed(Duration(seconds: 1)).then((value) {
      provider.pageViewChildrenTotal = images.length;
    });

    return images.map<Widget>(mediaImagesChildBuilder).toList();
  }

  Widget mediaImagesChildBuilder(String fileId) {
    return TcbStorageImageFileBuilder(
      fileId: fileId,
      fit: BoxFit.fitHeight,
      progressIndicatorBuilder: (context, _, __) {
        return UnconstrainedBox(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        );
      },
      builder: (context, image) {
        return PhotoView(
          imageProvider: image,
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 4.0,
          enableRotation: false,
          tightMode: false,
          gaplessPlayback: true,
        );
      },
    );
  }

  PageController pageControllerSelector(
    BuildContext context,
    MomentProfileController controller,
  ) {
    return controller.pageController;
  }

  String momentIdSelector(
      BuildContext context, MomentProfileController controller) {
    return controller.momentId;
  }
}

class _MomentProfilePanel extends StatelessWidget {
  final ScrollController controller;

  const _MomentProfilePanel(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemBuilder: (_, index) => Text('$index'),
    );
  }
}
