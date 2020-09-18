import 'package:fans/cloudbase/storage/TcbStorageFileMockDbQuery.dart';
import 'package:fans/widgets/cloudbase/database/collections/TcbDbCollectionDocBuilder.dart';
import 'package:flutter/material.dart';

class TcbStorageFileBuilder
    extends TcbDbCollectionDocBuilder<TcbStorageFileMockDbQueryModel> {
  const TcbStorageFileBuilder({
    Key key,
    @required String fileId,
    @required AsyncWidgetBuilder<TcbStorageFileMockDbQueryModel> builder,
  }) : super(
          key: key,
          docId: fileId,
          collectionName: kTcbStorageFileMockCollectionName,
          builder: builder,
        );
}
