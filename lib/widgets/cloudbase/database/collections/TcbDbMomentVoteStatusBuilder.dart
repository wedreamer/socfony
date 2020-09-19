import 'package:fans/models/MomentVoteUserSelected.dart';
import 'package:fans/provider/AppAuthProvider.dart';
import 'package:fans/widgets/cloudbase/database/collections/TcbDbCollectionWhereDocBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TcbDbMomentVoteStatusBuilder extends StatelessWidget {
  final String momentId;
  final AsyncWidgetBuilder<MomentVoteUserSelected> builder;

  const TcbDbMomentVoteStatusBuilder({
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

    return TcbDbCollectionWhereDocBuilder<MomentVoteUserSelected>(
      builder: builder,
      collectionName: 'moment-vote-user-selected',
      where: {
        'momentId': momentId,
        'userId': uid,
      },
    );
  }
}
