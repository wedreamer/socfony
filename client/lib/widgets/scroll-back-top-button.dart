import 'package:flutter/material.dart';

class ScrollBackTopButton extends StatefulWidget {
  const ScrollBackTopButton(this.controller, {Key key}): super(key: key);

  final ScrollController controller;

  @override
  _ScrollBackTopButtonState createState() => _ScrollBackTopButtonState();
}

class _ScrollBackTopButtonState extends State<ScrollBackTopButton> {
  double offset = 0;

  bool get show {
    return offset >= (MediaQuery.of(context).size.height / 2);
  }

  @override
  void initState() {
    widget.controller.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    setState(() {
      offset = widget.controller.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (show != true) {
      return SizedBox.shrink();
    }
    return FloatingActionButton(
      onPressed: onBackTop,
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.arrow_upward),
      mini: true,
    );
  }

  void onBackTop() {
    widget.controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
