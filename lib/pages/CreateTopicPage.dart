import 'dart:io';

import 'package:flutter/material.dart';

class CreateTopicController with ChangeNotifier {
  String _name;
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  File _cover;
  File get cover => _cover;
  set cover(File value) {
    _cover = value;
    notifyListeners();
  }

  String _title;
  String get title => _title;
  set title(String newValue) {
    _title = newValue;
    notifyListeners();
  }

  String _description;
  String get description => _description;
  set description(String newValue) {
    _description = newValue;
    notifyListeners();
  }
}

class CreateTopicPage extends StatefulWidget {
  @override
  _CreateTopicPageState createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  @override
  Widget build(BuildContext context) {
//    CreateTopicController().name;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('话题'),
      ),
      body: ListView(),
    );
  }
}
