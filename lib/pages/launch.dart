import 'package:flutter/material.dart';
import 'package:fans/l10n/localization.dart';

class Launch extends StatelessWidget {
  const Launch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: bodyBuild(context),
    );
  }

  Widget bodyBuild(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/launcher.png',
            width: mediaQueryData.size.width * 0.7,
          ),
        ),
        Positioned(
          left: mediaQueryData.padding.left,
          right: mediaQueryData.padding.right,
          bottom: 12 + mediaQueryData.padding.bottom,
          child: Center(
            child: Text(
              AppLocalizations.of(context).app.name,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ),
      ],
    );
  }
}
