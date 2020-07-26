import 'package:dating/GraphQLHandler.dart';
import 'package:dating/home.dart';
import 'package:dating/homepages/profile_external.dart';
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
  ViewEntry({Key key, @required this.name, @required this.imageUrl, @required this.like,@required this.id});

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
              variables: {'userid': this.id},
              onCompleted: (dynamic resultData) {
                print(resultData);

                List<dynamic> pics = resultData['getProfileUID']['pictures'];
                List<String> pics2 = List<String>();

                for(dynamic el in pics){
                  pics2.add(el['filepath']);
                  print(el['filepath']);
                }

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => ProfileExternalPage(
                      userId: this.id,
                      name: resultData['getProfileUID']['info']['name'],
                      imageUrl: resultData['getProfileUID']['profilepic'],
                      pictureUrls: pics2,

                      totalViews: resultData['getProfileUID']['info']['stats']['totalviews'],
                      totalLikes: resultData['getProfileUID']['info']['stats']['totallikes']
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(position: animation.drive(Tween(begin: Offset(0,1), end: Offset.zero).chain(CurveTween(curve: Curves.ease))), child: child);
                    }
                  ),
                );
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
  final TabController tabController;
  ProfileInfoPage({Key key, @required this.disownCallback, @required this.notifier, @required this.tabController});

  @override
  ProfileInfoPageState createState() => ProfileInfoPageState();
}

class ProfileInfoPageState extends State<ProfileInfoPage> with AutomaticKeepAliveClientMixin<ProfileInfoPage> {

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
    _scrollController = ScrollController();

    _notifier = ValueNotifier<bool>(false);

    _likeEntries = null;
    _viewEntries = null;

      r = doStuff();
      r.then((value) {
        setState(() {
          _likeEntries = value.data['getFullStats']['likes'];
          _viewEntries = value.data['getFullStats']['views'];
        });
      });

    _scrollController.addListener(() {
      setState(() {
        // this page owns control over the pink container's size
        if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
          widget.disownCallback(3);
        }

        // manage tab bar positions for views / likes pages
        if (_notifier.value == false) {
          _sp1 = _scrollController.position.pixels;
        } else {
          _sp2 = _scrollController.position.pixels;
        }

        widget.notifier.value = _showTabBarLast != 0 ? ((Common.screenHeight * 0.12 - 200.0 + (_showTabBarScroll < 200.0 ? _showTabBarScroll : 200.0)) > 0 ? (Common.screenHeight * 0.12 - 200.0 + (_showTabBarScroll < 200.0 ? _showTabBarScroll : 200.0)) : 0) : _containerHeight();

        // code for managing the tab bar position
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
      ProfileInfoViews(scrollController: _scrollController, notifier: _notifier, like: false, entries: _viewEntries),
      ProfileInfoViews(scrollController: _scrollController, notifier: _notifier, like: true, entries: _likeEntries),
    ];

    return FutureBuilder(
      future: r,
      builder: (context,snapshot) {
        if (snapshot.data != null) {
          return Stack(
            children: <Widget>[

              TabBarView(
                controller: widget.tabController,
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
                                  _notifier.value = index == 0 ? false : true;
                                  widget.tabController.animateTo(index,
                                      duration: Duration(milliseconds: 200), curve: Curves.easeOut);
                                  _scrollController.animateTo(index == 0 ? _sp1 : _sp2, duration: Duration(milliseconds: 200), curve: Curves.ease);
                                });
                              },
                              controller: widget.tabController,
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
              width: 75,
              height: 75,
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
