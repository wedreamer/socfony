import 'package:fans/cloudbase/database/TcbDbCollectionsProvider.dart';
import 'package:fans/models/BaseModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TcbDbCollectionWhereDocBuilder<T extends AbstractBaseModel>
    extends StatelessWidget {
  final AsyncWidgetBuilder<T> builder;
  final String collectionName;
  final Map<String, dynamic> where;

  const TcbDbCollectionWhereDocBuilder({
    Key key,
    @required this.builder,
    @required this.collectionName,
    @required this.where,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TcbDbCollectionsProvider, T>(
      builder: widgetBuilder,
      selector: selector,
      shouldRebuild: (T old, T doc) => old != doc,
    );
  }

  T selector(BuildContext context, TcbDbCollectionsProvider provider) {
    return provider.whereFindDoc<T>(collectionName, where);
  }

  Widget widgetBuilder(BuildContext context, T doc, Widget child) {
    if (doc != null && doc is T) {
      return builder(
        context,
        AsyncSnapshot.withData(ConnectionState.done, doc),
      );
    }

    return FutureBuilder<T>(
      builder: builder,
      future: Provider.of<TcbDbCollectionsProvider>(context)
          .whereQueryDoc(collectionName, where),
    );
  }
}
