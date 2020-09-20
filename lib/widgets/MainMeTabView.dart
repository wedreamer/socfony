import 'package:flutter/material.dart';

class MainMeTabView extends StatefulWidget {
  const MainMeTabView({Key key}) : super(key: key);

  @override
  _MainMeTabViewState createState() => _MainMeTabViewState();
}

class _MainMeTabViewState extends State<MainMeTabView>
    with AutomaticKeepAliveClientMixin<MainMeTabView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: true,
          title: Text('我的'),
          pinned: true,
          actions: [
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          ],
        ),
        // 个人基础信息卡片
        SliverToBoxAdapter(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            elevation: 0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://avatars2.githubusercontent.com/u/5564821?s=460&u=642011a3c6509cea53479b37598ac8fb1f9cdba3&v=4'),
              ),
              title: Text('Seven的代码太渣'),
              subtitle: Text(
                '有趣的灵魂我看不起，好看的皮囊几百？',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate.fixed([
              Card(
                elevation: 0,
                child: ListTile(
                  title: Text(
                    '12',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text('粉丝'),
                ),
              ),
              Card(
                elevation: 0,
                child: ListTile(
                  title: Text(
                    '4',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text('关注'),
                ),
              ),
              Card(
                elevation: 0,
                child: ListTile(
                  title: Text(
                    '421',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text('帖子'),
                ),
              ),
            ]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.8,
            ),
          ),
        ),
        // 其他服务页面网格
        SliverToBoxAdapter(
          child: Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Colors.blue,
                    ),
                    title: Text('我的收藏'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.tag_faces,
                      color: Colors.teal,
                    ),
                    title: Text('话题管理'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ).toList(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    leading: Icon(
                      Icons.brightness_4,
                      color: Colors.indigoAccent,
                    ),
                    title: Text('夜间模式'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '跟随系统',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.indigoAccent,
                    ),
                    title: Text('语言设置'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '中文简体',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: Colors.red,
                    ),
                    title: Text('帮助与反馈'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
