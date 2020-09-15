import 'package:fans/widgets/cloudbase/database/collections/TcbDbCollectionDocBuilder.dart';
import 'package:flutter/material.dart';

import 'TcbStorageFileMockDbQuery.dart';

class TcbStorageFileBuilder
    extends TcbDbCollectionDocBuilder<TcbStorageFileMockDbQueryModel> {
  static bool _registerMockQuery = false;

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

  @override
  Widget build(BuildContext context) {
    if (_registerMockQuery) {
      TcbStorageFileMockDbQuery.register();
      _registerMockQuery = true;
    }

    return super.build(context);
  }
}
