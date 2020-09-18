import 'package:fans/cloudbase/database/TcbUserMockDbDocQuery.dart';
import 'package:fans/models/user.dart';
import 'package:fans/widgets/cloudbase/database/collections/TcbDbCollectionDocBuilder.dart';
import 'package:flutter/material.dart';

class TcbDbUserDocBuilder extends TcbDbCollectionDocBuilder<User> {
  const TcbDbUserDocBuilder({
    @required String userId,
    @required AsyncWidgetBuilder<User> builder,
    Key key,
  }) : super(
          key: key,
          docId: userId,
          builder: builder,
          collectionName: kCloudUserHttpMockDbCollectionName,
        );
}
