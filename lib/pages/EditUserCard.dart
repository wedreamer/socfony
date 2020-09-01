import 'package:flutter/material.dart';

class EditUserCard extends StatefulWidget {
  @override
  _EditUserCardState createState() => _EditUserCardState();
}

class _EditUserCardState extends State<EditUserCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('编辑交友卡'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          _CardContainer(
            title: '扩列宣言',
            subtitle: '必填，最多100字',
            child: TextFormField(
              maxLines: 7,
              decoration: InputDecoration(
                hintText: '🤫我只告诉你，可以这样介绍自己：\n'
                    '我是宇宙无敌超级可爱\n'
                    '静如处子,动如脱兔\n'
                    '喜欢玩游戏的小宅男\n'
                    '性格：幽默风趣才怪\n'
                    '爱吃零食，爱睡觉\n'
                    '未经允许，擅自喜欢你',
              ),
              maxLength: 100,
            ),
          ),
          _CardContainer(
            title: '想要',
            subtitle: '必须，选择交友方向',
            child: Column(
              children: [
                RadioListTile(
                  value: 1,
                  groupValue: 1,
                  title: Text('扩列'),
                  dense: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).primaryColor,
                ),
                RadioListTile(
                  value: 2,
                  groupValue: 1,
                  title: Text('躺列'),
                  dense: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).primaryColor,
                ),
                RadioListTile(
                  value: 3,
                  groupValue: 1,
                  title: Text('处对象'),
                  dense: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).primaryColor,
                ),
                RadioListTile(
                  value: 4,
                  groupValue: 1,
                  title: Text('玩游戏'),
                  dense: true,
                  onChanged: (value) {},
                  activeColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
          _CardContainer(
            title: '声音宣言',
            subtitle: '可选，录制声音宣言会更有吸引力哦～',
            child: FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.mic),
              label: Text('录制宣言'),
              color: Theme.of(context).primaryColor,
              colorBrightness: Brightness.dark,
              shape: StadiumBorder(),
            ),
          ),
          _CardContainer(title: '封面', child: null),
          _CardContainer(
            title: '更多',
            child: Column(
              children: [
                SwitchListTile(
                  dense: true,
                  value: true,
                  onChanged: (value) {},
                  title: Text('附加位置信息'),
                  subtitle: Text('附加位置信息后，将优先推荐给附加的用户哦'),
                  activeColor: Theme.of(context).primaryColor,
                ),
                SwitchListTile(
                  value: false,
                  dense: true,
                  onChanged: (value) {},
                  title: Text('启用交友卡'),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
            child: FlatButton(
              onPressed: () {},
              child: Text('完成'),
              color: Theme.of(context).primaryColor,
              colorBrightness: Brightness.dark,
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _CardContainer({
    Key key,
    @required this.title,
    @required this.child,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildListTile(context),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                color: CardTheme.of(context).shadowColor ??
                    Theme.of(context).secondaryHeaderColor,
                blurRadius: 6.0,
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 12.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: child,
        ),
      ],
    );
  }

  ListTile buildListTile(BuildContext context) {
    Widget value = Text(
      title,
      style: Theme.of(context).textTheme.headline6,
    );
    if (subtitle is String && subtitle.isNotEmpty) {
      value = Row(
        children: [
          value,
          SizedBox(width: 12.0),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      );
    }
    return ListTile(
      title: value,
    );
  }
}
