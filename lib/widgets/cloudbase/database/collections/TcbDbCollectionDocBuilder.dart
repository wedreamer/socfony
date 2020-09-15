import 'package:fans/cloudbase/database/TcbDbCollectionsProvider.dart';
import 'package:fans/models/BaseModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TcbDbCollectionDocBuilder<T extends AbstractBaseModel>
    extends StatelessWidget {
  final String collectionName;
  final String docId;
  final AsyncWidgetBuilder<T> builder;

  const TcbDbCollectionDocBuilder({
    Key key,
    @required this.collectionName,
    @required this.docId,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TcbDbCollectionsProvider, T>(
      selector: selector,
      builder: widgetBuilder,
      shouldRebuild: (T old, T doc) => old != doc,
    );
  }

  T selector(BuildContext context, TcbDbCollectionsProvider provider) {
    return provider.findDoc<T>(collectionName, docId);
  }

  Widget widgetBuilder(BuildContext context, T doc, Widget child) {
    if (doc is T && doc != null) {
      return builder(
        context,
        AsyncSnapshot<T>.withData(ConnectionState.done, doc),
      );
    }

    return FutureBuilder<T>(
      builder: builder,
      initialData: doc,
      future: Provider.of<TcbDbCollectionsProvider>(context)
          .queryDoc(collectionName, docId),
    );
  }
}
