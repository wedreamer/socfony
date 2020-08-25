import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MainExploreLayout extends StatefulWidget {
  const MainExploreLayout({Key key}) : super(key: key);

  @override
  _MainExploreLayoutState createState() => _MainExploreLayoutState();
}

class _MainExploreLayoutState extends State<MainExploreLayout> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: mediaQueryData.size.width,
          child: FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.search),
            label: Text('搜索更多精彩...'),
            color: Theme.of(context).splashColor,
            shape: StadiumBorder(),
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: GFCarousel(
              items: List.generate(4, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 12.0),
                );
              }),
              aspectRatio: 20 / 9,
              autoPlay: true,
              pagination: true,
              viewportFraction: 1.0,
              enlargeMainPage: false,
            ),
          ),
          ListTile(
            title: Text(
              '发现话题',
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: GestureDetector(
              child: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pushNamed('TopicSquare');
              },
            ),
          ),
          ListView.builder(
            itemBuilder: (_, index) {
              return Text('1');
            },
            itemCount: 120,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
          ),
        ],
      ),
    );
  }
}
