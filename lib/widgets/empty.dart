import 'package:flutter/material.dart';

enum EmptyTypes {
  chat,
  delete,
  ghost,
  network,
  package,
  search,
}

class Empty extends StatelessWidget {
  const Empty({
    Key key,
    this.type,
    this.child,
    this.text,
  }) : super(key: key);

  final EmptyTypes type;
  final Widget child;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (type == null && child == null && text == null) {
      return SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        typeBuilder(context),
        valueBuilder(context),
      ],
    );
  }

  Widget valueBuilder(BuildContext context) {
    if (child is Widget) {
      return child;
    } else if (text is String && text.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.caption,
        ),
      );
    }

    return SizedBox.shrink();
  }

  Widget typeBuilder(BuildContext context) {
    if (type == null) {
      return SizedBox.shrink();
    }
    String assetName = 'assets/empty/';
    switch (type) {
      case EmptyTypes.chat:
        assetName += 'chat.webp';
        break;
      case EmptyTypes.delete:
        assetName += 'delete.webp';
        break;
      case EmptyTypes.ghost:
        assetName += 'ghost.webp';
        break;
      case EmptyTypes.network:
        assetName += 'network.webp';
        break;
      case EmptyTypes.package:
        assetName += 'package.webp';
        break;
      case EmptyTypes.search:
        assetName += 'search.webp';
        break;
    }
    return Image.asset(assetName, width: 120);
  }
}
