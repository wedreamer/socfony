import 'package:flutter/material.dart';

class RowBadgeButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final Color badgeColor;
  final VoidCallback onTap;

  const RowBadgeButton({
    Key key,
    @required this.icon,
    @required this.text,
    this.badgeColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Padding(
            padding: EdgeInsets.only(
              left: 2.0,
              bottom: 10.0,
            ),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: badgeColor),
            ),
          ),
        ],
      ),
    );
  }
}
