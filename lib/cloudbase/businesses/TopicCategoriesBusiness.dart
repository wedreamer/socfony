import 'package:flutter/material.dart';
import 'package:fans/cloudbase.dart';
import 'package:fans/models/TopicCategory.dart';

class TopicCategoriesBusiness with ChangeNotifier {
  Iterable<TopicCategory> _categories;
  Iterable<TopicCategory> get categories => _categories;

  static TopicCategoriesBusiness _instance;

  TopicCategoriesBusiness._();

  factory TopicCategoriesBusiness() {
    if (_instance is! TopicCategoriesBusiness) {
      _instance = TopicCategoriesBusiness._();
    }

    return _instance;
  }

  Future<Iterable<TopicCategory>> refresh() async {
    final result = await CloudBase()
        .database
        .collection('topic-categories')
        .limit(100)
        .orderBy('order', 'desc')
        .get();
    _categories = (result.data as List).map((e) => TopicCategory.fromJson(e));
    notifyListeners();

    return categories;
  }

  Future<Iterable<TopicCategory>> query() async {
    if (categories is Iterable<TopicCategory> && categories.isNotEmpty) {
      return categories;
    }

    return await refresh();
  }

  static widgetBuilder(AsyncWidgetBuilder<Iterable<TopicCategory>> builder,
      {Key key}) {
    return TopicCategoriesBusinessWidgetBuilder(builder, key: key);
  }
}

class TopicCategoriesBusinessWidgetBuilder extends StatelessWidget {
  final AsyncWidgetBuilder<Iterable<TopicCategory>> builder;

  const TopicCategoriesBusinessWidgetBuilder(this.builder, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final business = TopicCategoriesBusiness();
    if (business.categories is Iterable<TopicCategory> &&
        (business.categories?.isNotEmpty ?? false)) {
      return builder(context,
          AsyncSnapshot.withData(ConnectionState.done, business.categories));
    }

    return FutureBuilder(
      builder: builder,
      future: business.query(),
    );
  }
}
