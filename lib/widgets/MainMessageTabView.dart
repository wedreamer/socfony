import 'package:flutter/material.dart';

class MainMessageTabView extends StatefulWidget {
  const MainMessageTabView({Key key}) : super(key: key);

  @override
  _MainMessageTabViewState createState() => _MainMessageTabViewState();
}

class _MainMessageTabViewState extends State<MainMessageTabView>
    with AutomaticKeepAliveClientMixin<MainMessageTabView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          pinned: true,
          title: Text('消息'),
          centerTitle: true,
        ),
        SliverList(
          // itemExtent: 50,
          delegate: SliverChildListDelegate.fixed([
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              title: Text('系统通知'),
              subtitle: Text('你的话题「守望先锋」审核通过啦'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.alternate_email,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
              ),
              title: Text('提及我的'),
              subtitle: Text('@七爷 提及了你，快去看看吧'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.forum,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blue,
              ),
              title: Text('收到的评论'),
              subtitle: Text('@Seven、@田可爱等人评论了你'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                backgroundColor: Colors.redAccent,
              ),
              title: Text('收到的喜欢'),
              subtitle: Text('本周收到152个喜欢，比上周增长了20%'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/audio-bg.jpg'),
              ),
              title: Text('Fans忠实拥护者'),
              subtitle: Text('我觉得吧，Fans注重用户体验很重要～'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://avatars3.githubusercontent.com/u/17024873?s=460&u=31819a4fbfbd1dda28bfeb271c0955680b4fa030&v=4'),
              ),
              title: Text('田可爱'),
              subtitle: Text('哈哈，爱你么么哒！'),
            ),
          ]),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
