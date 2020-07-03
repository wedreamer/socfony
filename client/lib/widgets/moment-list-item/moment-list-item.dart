import 'package:flutter/material.dart';
import 'package:snsmax/models/moment.dart';

typedef FetchMomentCallback = Future<Moment> Function();

class MomentListItem extends StatefulWidget {
  const MomentListItem({
    Key key,
    @required this.onFetch,
  }): super(key: key);

  final FetchMomentCallback onFetch;

  @override
  _MomentListItemState createState() => _MomentListItemState();
}

class _MomentListItemState extends State<MomentListItem> {
  Moment moment;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onFetchMoment);
  }

  void onFetchMoment(Duration duration) async {
    await Future.delayed(duration);
    Moment moment = await widget.onFetch();
    setState(() {
      this.moment = moment;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (moment is! Moment) {
      return SizedBox.shrink();
    }

    return Card(
      child: Text(moment.id),
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(),
    );
  }
}
