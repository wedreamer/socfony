import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class CreateTopicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('创建话题'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => CreateTopicController(),
        child: ListView(
          children: [
            Selector<CreateTopicController, String>(
              builder: (BuildContext context, String value, _) {
                return GestureDetector(
                  child: Text(value.toString()),
                  onTap: () {
                    context.read<CreateTopicController>().name = '0000';
                  },
                );
              },
              selector: (_, CreateTopicController controller) =>
                  controller.name,
            )
          ],
        ),
      ),
    );
  }
}
