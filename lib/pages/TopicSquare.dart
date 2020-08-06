import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snsmax/cloudbase/database/businesses/TopicCategoriesBusiness.dart';
import 'package:snsmax/models/TopicCategory.dart';

enum TopicSquareMode {
  selector,
  page,
}

const String _kPageTitle = '话题广场';

class TopicSquareCategoryIndexController extends ValueNotifier<int> {
  TopicSquareCategoryIndexController([int value = 0]) : super(value);
}

class TopicSquare extends StatefulWidget {
  final TopicSquareMode mode;
  final String title;

  const TopicSquare({
    Key key,
    this.mode = TopicSquareMode.page,
    this.title = _kPageTitle,
  }) : super(key: key);

  @override
  _TopicSquareState createState() => _TopicSquareState();
}

class _TopicSquareState extends State<TopicSquare> {
  TopicSquareCategoryIndexController controller;

  @override
  void initState() {
    controller = TopicSquareCategoryIndexController(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: BackButton(),
        title: Text(widget.title),
        actions: <Widget>[buildCreateTopicButton(context)],
        bottom: buildSearchButton(context),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildCategory(),
          Expanded(
            child: _TopicCategoryPageView(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildCategory() {
    return SizedBox(
      width: 120,
      child: _TopicCategoryListView(
        controller: controller,
      ),
    );
  }

  PreferredSize buildSearchButton(BuildContext context) {
    double height = 36.0;
    double padding = 12.0;

    return PreferredSize(
      preferredSize: Size(double.infinity, height + padding),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: height,
          margin:
              EdgeInsets.symmetric(horizontal: padding * 2, vertical: padding)
                  .copyWith(top: 0),
          padding: EdgeInsets.symmetric(horizontal: padding),
          decoration: BoxDecoration(
            color: searchButtonColor(context),
            borderRadius: BorderRadius.circular(height),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                size: height * 0.65,
                color: Theme.of(context).textTheme.caption.color,
              ),
              SizedBox(width: padding / 2.0),
              Text(
                '搜索话题',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color searchButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white12
        : Colors.black12;
  }

  Widget buildCreateTopicButton(BuildContext context) {
    if (widget.mode == TopicSquareMode.selector) {
      return SizedBox();
    }
    return FlatButton.icon(
      onPressed: () {},
      icon: Icon(Icons.add),
      label: Text('创建'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}

class _TopicCategoryPageView extends StatefulWidget {
  final TopicSquareCategoryIndexController controller;

  const _TopicCategoryPageView({Key key, @required this.controller})
      : super(key: key);

  @override
  __TopicCategoryPageViewState createState() => __TopicCategoryPageViewState();
}

class __TopicCategoryPageViewState extends State<_TopicCategoryPageView>
    with AutomaticKeepAliveClientMixin<_TopicCategoryPageView> {
  PageController controller;
  TopicCategoriesBusiness business;

  @override
  void initState() {
    controller = PageController(initialPage: widget.controller.value)
      ..addListener(onPageIndexChange);
    business = TopicCategoriesBusiness()
      ..query()
      ..addListener(setState);
    widget.controller.addListener(onCategoryIndexChange);
    super.initState();
  }

  @override
  void setState([fn]) {
    fn = fn ?? () {};
    mounted ? super.setState(fn) : fn();
  }

  onCategoryIndexChange() {
    controller.jumpToPage(widget.controller.value);
  }

  onPageIndexChange() {
    widget.controller.value = controller.page.toInt();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PageView.builder(
      controller: controller,
      itemBuilder: itemBuilder,
      itemCount: (business.categories?.length ?? 0) + 1,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Text(index.toString());
  }

  @override
  bool get wantKeepAlive => true;
}

class _TopicCategoryListView extends StatefulWidget {
  final TopicSquareCategoryIndexController controller;

  const _TopicCategoryListView({Key key, @required this.controller})
      : super(key: key);

  @override
  __TopicCategoryListViewState createState() => __TopicCategoryListViewState();
}

class __TopicCategoryListViewState extends State<_TopicCategoryListView> {
  TopicCategoriesBusiness business;

  @override
  void initState() {
    business = TopicCategoriesBusiness()
      ..addListener(setState)
      ..query();
    widget.controller.addListener(setState);
    super.initState();
  }

  @override
  void setState([fn]) {
    fn = fn ?? () {};
    mounted ? super.setState(fn) : fn();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: itemBuilder,
      itemCount: (business.categories?.length ?? 0) + 1,
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    if (index == 0) {
      return categoryItemBuilder(context, index, '最近');
    }

    List<TopicCategory> categories = business.categories.toList();
    TopicCategory category = categories[index - 1];
    return categoryItemBuilder(context, index, category.name);
  }

  Container categoryItemBuilder(BuildContext context, int index, String name) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.0).copyWith(left: 0),
      child: RaisedButton(
        onPressed: () {
          if (widget.controller.value != index) {
            widget.controller.value = index;
          }
        },
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
        ),
        color:
            widget.controller.value == index ? selectedColor : unselectedColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
        ),
        textColor: widget.controller.value == index ? Colors.white : null,
      ),
    );
  }

  Color get selectedColor => Theme.of(context).primaryColor;
  Color get unselectedColor => Theme.of(context).scaffoldBackgroundColor;
}
