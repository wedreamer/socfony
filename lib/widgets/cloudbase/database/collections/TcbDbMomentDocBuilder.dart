import 'package:fans/models/moment.dart';
import 'package:flutter/material.dart';

import 'TcbDbCollectionDocBuilder.dart';

class TcbDbMomentDocBuilder extends TcbDbCollectionDocBuilder<Moment> {
  const TcbDbMomentDocBuilder({
    @required String momentId,
    @required AsyncWidgetBuilder<Moment> builder,
    Key key,
  }) : super(
          key: key,
          docId: momentId,
          builder: builder,
          collectionName: 'moments',
        );
}
