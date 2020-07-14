import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../common.dart';

class CmScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class ViewEntry extends StatelessWidget {
  final String name;
  final String imageUrl;
  ViewEntry({Key key, @required this.name, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: Colors.grey.withOpacity(0.5),
        child: Container(
          height: Common.screenHeight * 0.1,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(this.imageUrl),
                backgroundColor: Colors.grey,
                radius: 25,
              ),
              SizedBox(
                width: 20,
              ),
              Text('${this.name}', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              Text(' viewed your profile.', overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoPage extends StatefulWidget {
  final Function(int) disownCallback;
  final ValueNotifier<double> notifier;
  ProfileInfoPage({Key key, @required this.disownCallback, @required this.notifier});

  @override
  ProfileInfoPageState createState() => ProfileInfoPageState();
}

class ProfileInfoPageState extends State<ProfileInfoPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProfileInfoPage> {

  @override
  bool get wantKeepAlive => true;

  double _containerHeight() {
    return Common.screenHeight * 0.12 +
        (_scrollController.hasClients ?
        (_scrollController.position.pixels > 0 ?
          (Common.screenHeight * 0.12 - _scrollController.position.pixels > 0 ? -_scrollController.position.pixels : -Common.screenHeight * 0.12) :
          (_scrollController.position.pixels * _scrollController.position.pixels * 0.001))
          : 0);
  }

  double _topPosition() {
    if (_showTabBarLast != 0) {
      return -200.0 + (_showTabBarScroll < 200.0 ? _showTabBarScroll : 200.0);
    } else {
      return 0.0 -
          (_scrollController.hasClients ?
            (_scrollController.position.pixels > 0 ?
              _scrollController.position.pixels
            : -(_scrollController.position.pixels * _scrollController.position.pixels * 0.001))
          : 0.0);
    }
  }

  TabController _tabController;
  ScrollController _scrollController;

  bool _hideTabBar = false;
  bool _showTabBarLimit = false;
  double _showTabBarLast = 0;
  double _showTabBarScroll = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        widget.disownCallback(3);
        widget.notifier.value = _showTabBarLast != 0 ? ((Common.screenHeight * 0.12 - 200.0 + (_showTabBarScroll < 200.0 ? _showTabBarScroll : 200.0)) > 0 ? (Common.screenHeight * 0.12 - 200.0 + (_showTabBarScroll < 200.0 ? _showTabBarScroll : 200.0)) : 0) : _containerHeight();

        if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
          if (_scrollController.position.pixels <= 0) {
            _showTabBarLast = 0;
          }

          if (_hideTabBar && !_showTabBarLimit && _scrollController.position.pixels > Common.screenHeight * 0.5) {
            _showTabBarLast = _scrollController.position.pixels;
          }

          _showTabBarScroll = _showTabBarLast - _scrollController.position.pixels;

          if (_showTabBarScroll > 200) {
            _showTabBarLimit = false;
          } else {
            _showTabBarLimit = true;
          }

          _hideTabBar = false;
        } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          if (!_hideTabBar && !_showTabBarLimit) {
            _showTabBarLast = _scrollController.position.pixels + 200;
          }

          _showTabBarScroll = _showTabBarLast - _scrollController.position.pixels;

          if (_showTabBarScroll < 0) {
            _showTabBarLimit = false;
          } else {
            _showTabBarLimit = true;
          }

          _hideTabBar = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        ScrollConfiguration(
          behavior: CmScrollBehavior(),
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return ViewEntry(name: 'Kvago', imageUrl: 'https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_relaxing_on_patio_other/1800x1200_cat_relaxing_on_patio_other.jpg',);
            },
            padding: EdgeInsets.fromLTRB(0, Common.screenHeight * 0.12 + Common.screenHeight * 0.05, 0, 0),
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          ),
        ),

        Positioned(
          top: _topPosition(),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: Common.screenWidth,
            height: Common.screenHeight * 0.06 + Common.screenHeight * 0.1,
            child: Stack(
              children: <Widget>[
                Container(
                  height: Common.screenHeight * 0.12,
                  color: Color(0xFFCA436B),
                ),
                Positioned(
                  left: Common.screenWidth * 0.05,
                  top: Common.screenHeight * 0.06,
                  child: Container(
                    width: Common.screenWidth * 0.9,
                    height: Common.screenHeight * 0.1,
                    child: Card(
                      elevation: 10,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Color(0xFFCA436B),
                        unselectedLabelColor: Colors.grey,
                        labelColor: Color(0xFFCA436B),
                        tabs: <Widget>[
                          Tab(
                            icon: Icon(Icons.remove_red_eye),
                            text: 'Views',
                          ),
                          Tab(
                            icon: Icon(Icons.favorite),
                            text: 'Likes',
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

//        Positioned(
//          child: Container(
//            color: Color(0xFFCA436B),
//          ),
//        )

//        AnimatedPositioned(
//          duration: Duration(milliseconds: 200),
//          left: Common.screenWidth * 0.05,
//          top: _hideTabBar ? -100 : Common.screenHeight * 0.06,
//          child: Container(
//            width: Common.screenWidth * 0.9,
//            child: Card(
//              elevation: 10,
//              child: TabBar(
//                controller: _tabController,
//                indicatorColor: Color(0xFFCA436B),
//                unselectedLabelColor: Colors.grey,
//                labelColor: Color(0xFFCA436B),
//                tabs: <Widget>[
//                  Tab(
//                    icon: Icon(Icons.remove_red_eye),
//                    text: 'Views',
//                  ),
//                  Tab(
//                    icon: Icon(Icons.favorite),
//                    text: 'Likes',
//                  ),
//                ],
//              ),
//            ),
//          ),
//        )



      ],
    );

  }
}
