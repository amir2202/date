import 'package:dating/GraphQLHandler.dart';
import 'package:dating/home.dart';
import 'package:dating/homepages/profile_info_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
  final bool like;
  final String id;
  final Function(BuildContext, String, String, List<String>, int, int) onPush;
  ViewEntry({Key key, @required this.name, @required this.imageUrl, @required this.like,@required this.id, @required this.onPush});

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print(this.id);
          GraphQLHandler.client2.mutate(
            MutationOptions(
              documentNode: gql(GraphQLHandler.getProfile),
              variables: { 'userid':this.id },
              onCompleted: (dynamic resultData) {
                print(resultData);

                List<dynamic> pics = resultData['getProfileUID']['pictures'];
                List<String> pics2 = List<String>();

                for(dynamic el in pics){
                  pics2.add(el['filepath']);
                  print(el['filepath']);
                }

                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(name:resultData['getProfileUID']['info']['name'],imageUrl:resultData['getProfileUID']['profilepic'], pictureUrls:pics2,totalViews: resultData['getProfileUID']['info']['stats']['totalviews'],totalLikes: resultData['getProfileUID']['info']['stats']['totallikes'])));
                onPush(context, resultData['getProfileUID']['info']['name'], resultData['getProfileUID']['profilepic'], pics2, resultData['getProfileUID']['info']['stats']['totalviews'], resultData['getProfileUID']['info']['stats']['totallikes']);
              }
            )
          );
        },
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
              Text(' ${this.like ? 'liked' : 'viewed'} your profile.', overflow: TextOverflow.ellipsis),
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
  final Function(BuildContext, String, String, List<String>, int, int) onPush;
  ProfileInfoPage({Key key, @required this.disownCallback, @required this.notifier, @required this.onPush});

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

  double _tp = 0;

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

  ValueNotifier<bool> _notifier;
  double _sp1 = 0;
  double _sp2 = 0;

  List<dynamic> _viewEntries;
  List<dynamic> _likeEntries;

  List<Widget> _pages;

  bool _hideTabBar = false;
  bool _showTabBarLimit = false;
  double _showTabBarLast = 0;
  double _showTabBarScroll = 0;
  //LOAD
  GraphQLClient client = GraphQLHandler.client2;
  Future<QueryResult> r;

  Future<QueryResult> doStuff() async {
    return await client.mutate(MutationOptions(documentNode: gql(GraphQLHandler.getFullLikesViews),variables: {'userid':Common.userid}));
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();

    _notifier = ValueNotifier<bool>(false);

    _likeEntries = [
      {
        "byName": "LOADING",
        "byPicture": "http://54.37.205.205/ImageStorage/73/1.png"
      },
    ];
    _viewEntries = [
      {
        "byName": "LOADING",
        "byPicture": "http://54.37.205.205/ImageStorage/73/1.png"
      },
    ];

      r = doStuff();
      r.then((value) {
        setState(() {
          _likeEntries = value.data['getFullStats']['likes'];
          _viewEntries = value.data['getFullStats']['views'];
        });
      });

    _scrollController.addListener(() {
      setState(() {
        widget.disownCallback(3);

        if (_notifier.value == false) {
          _sp1 = _scrollController.position.pixels;
        } else {
          _sp2 = _scrollController.position.pixels;
        }

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

        _tp = _topPosition();
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    _pages = <Widget>[
      ProfileInfoViews(scrollController: _scrollController, notifier: _notifier, like: false,entries: _viewEntries, onPush: widget.onPush),
      ProfileInfoViews(scrollController: _scrollController, notifier: _notifier, like: true,entries: _likeEntries, onPush: widget.onPush),
    ];

    return FutureBuilder(
      future: r,
      builder: (context,snapshot) {
        if (snapshot.data != null) {
          return Stack(
            children: <Widget>[

              TabBarView(
                controller: _tabController,
                children: _pages,
                physics: NeverScrollableScrollPhysics(),
              ),

              Positioned(
                top: _tp,
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
                              onTap: (index) {
                                setState(() {
                                  print(_sp1);
                                  print(_sp2);
                                  _notifier.value = index == 0 ? false : true;
                                  _tabController.animateTo(index,
                                      duration: Duration(milliseconds: 200), curve: Curves.easeOut);
                                  _scrollController.animateTo(index == 0 ? _sp1 : _sp2, duration: Duration(milliseconds: 200), curve: Curves.ease);
                                });
                              },
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

            ],
          );
        } else {
          return Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCA436B))
              ),
            ),
          );
        }
      },
    );

  }
}
