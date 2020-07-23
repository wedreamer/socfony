import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class VoteSetterPage extends StatefulWidget {
  const VoteSetterPage(this.votes, {Key key}) : super(key: key);

  final List<String> votes;

  @override
  _VoteSetterPageState createState() => _VoteSetterPageState();

  static Widget routeBuilder(BuildContext context) {
    return VoteSetterPage(
        ModalRoute.of(context).settings.arguments as List<String>);
  }
}

class _VoteSetterPageState extends State<VoteSetterPage> {
  List<String> votes;
  List<TextEditingController> controllers;

  bool get allowDone {
    return votes is List<String> &&
        (votes
                .where((element) => element.length == 0 || element.length > 14)
                .length ==
            0);
  }

  @override
  void initState() {
    votes = widget.votes is List<String> ? widget.votes : <String>["", ""];
    if (votes.length < 2) {
      votes = List<String>.generate(2, (int index) {
        try {
          return votes[index];
        } catch (_) {
          return "";
        }
      });
    }
    controllers = List<TextEditingController>.generate(4, (int index) {
      String text;
      try {
        text = votes[index];
      } catch (_) {
        text = "";
      }

      return TextEditingController(text: text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            buildVoteItems(),
            buildAddItemButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildAddItemButton(BuildContext context) {
    if (votes.length < 4)
      return GFButton(
        onPressed: onAddNewVoteItem,
        icon: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        text: "添加一个选项",
        textColor: Theme.of(context).primaryColor,
        blockButton: true,
        shape: GFButtonShape.pills,
        color: Theme.of(context).hoverColor,
      );
    return SizedBox.shrink();
  }

  ListView buildVoteItems() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: voteItemBuilder,
      itemCount: votes.length,
    );
  }

  Widget voteItemBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controllers[index],
        autofocus: index == 0,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: "选项${index + 1} (14个字符以内)",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(60),
          ),
          filled: true,
          fillColor: Theme.of(context).hoverColor,
          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          suffixIcon: votes.length > 2 ? buildRemoveButton(index) : null,
        ),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        onChanged: (String value) => onVoteItemChange(index, value),
      ),
    );
  }

  GestureDetector buildRemoveButton(int index) {
    return GestureDetector(
      onTap: () => onRemoveVoteIndex(index),
      child: Icon(
        Icons.remove_circle,
        color: Colors.red,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: true,
      centerTitle: true,
      elevation: 0,
      title: Text(
        '投票',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: <Widget>[
        buildDoneButton(context),
      ],
    );
  }

  UnconstrainedBox buildDoneButton(BuildContext context) {
    return UnconstrainedBox(
      child: FlatButton(
        onPressed: allowDone ? onDoneBack : null,
        child: Text('完成'),
        textColor: Theme.of(context).primaryColor,
      ),
    );
  }

  onVoteItemChange(int index, String value) {
    setState(() {
      votes[index] = value.trimLeft();
    });
  }

  onAddNewVoteItem() {
    setState(() {
      votes.add("");
    });
  }

  onRemoveVoteIndex(int index) {
    setState(() {
      votes.removeAt(index);
    });
  }

  onDoneBack() {
    Navigator.of(context).pop(votes.map((e) => e.trim()).toList());
  }
}
