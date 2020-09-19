import 'package:fans/models/moment-like-history.dart';
import 'package:fans/provider/AppAuthProvider.dart';
import 'package:fans/widgets/cloudbase/database/collections/TcbDbCollectionWhereDocBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TcbDbMomentLikeStatusBuilder extends StatelessWidget {
  final String momentId;
  final AsyncWidgetBuilder<MomentLikeHistory> builder;

  const TcbDbMomentLikeStatusBuilder({
    Key key,
    @required this.momentId,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AppAuthProvider>().uid;
    if (uid == null || uid.isEmpty || momentId == null || momentId.isEmpty) {
      return builder(
        context,
        AsyncSnapshot.withData(ConnectionState.done, null),
      );
    }

    return TcbDbCollectionWhereDocBuilder<MomentLikeHistory>(
      builder: builder,
      collectionName: 'moment-liked-histories',
      where: {
        'momentId': momentId,
        'userId': uid,
      },
    );
  }
}
