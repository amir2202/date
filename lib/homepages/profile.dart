import 'package:dating/GraphQLHandler.dart';
import 'package:dating/home.dart';
import 'package:dating/imagelogic/ImageHandler.dart';
import 'package:flutter/material.dart';
import 'package:dating/common.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CmScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class ProfileImageBox extends StatelessWidget {
  final String imageUrl;
  ProfileImageBox({Key key, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageUrl,
      child: Material(
        child: Ink.image(
          image: NetworkImage(this.imageUrl),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: 100,
          height: 100,
          child: InkWell(
            onTap: () {},
            splashColor: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final Function(int, int) tabCallback;
  final Function(int) disownCallback;
  final ValueNotifier<double> notifier;

  final bool myProfile;

  final String userId;
  final String name;
  final String imageUrl;
  final List<String> pictureUrls;

  final int totalLikes;
  final int totalViews;

  ProfilePage({Key key,
    @required this.tabCallback,
    @required this.disownCallback,
    @required this.notifier,

    @required this.myProfile,

    @required this.userId,
    @required this.name,
    @required this.imageUrl,
    @required this.pictureUrls,

    @required this.totalViews,
    @required this.totalLikes,
  });

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {

  // always save the state when the page is switched
  @override
  bool get wantKeepAlive => true;

  // stuff that just needs to be here for layout calculations
  GlobalKey _bioKey = GlobalKey();
  Offset _containerPosition = Offset(0, 0);
  Size _containerSize = Size(0, 0);

  ScrollController _scrollController;
  TabController _viewsLikesTabController;

  // list of the user's picture urls
  List<String> _pictures;
  int _pictureIndex;

  // views and likes variables for the profile box
  int _views = 0;
  int _likes = 0;

  bool _refreshing = false;
  bool _finishedRefreshing = true;

  bool _hideFab = false;

  double _topBoxPadding = 75.0;
  double _topBioPadding = 250.0;

  // pink container's height when this page is controlling it
  double _containerHeight() {
    return 150.0 +
              (_scrollController.position.pixels > 0 ? -1 : 0.5) *
              (150.0 - (_scrollController.position.pixels * _scrollController.position.pixels * 0.001) >= 0 ?
              (_scrollController.position.pixels * _scrollController.position.pixels * 0.001)
              : 150.0);
  }

  @override
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // initialize local views and likes variables
    _views = widget.totalViews;
    _likes = widget.totalLikes;

    // when the image grid is scrolled in any direction...
    _scrollController.addListener(() {setState(() {

      _topBoxPadding = 75.0 +
          (_scrollController.position.pixels > 0 ? -1 : 0.5) *
              (_scrollController.position.pixels * _scrollController.position.pixels * 0.002) + _scrollController.position.pixels;

      _topBioPadding = 250.0 +
          (_scrollController.position.pixels > 0 ? -1 : 0.5) *
              (_scrollController.position.pixels * _scrollController.position.pixels * 0.0015 +
                  (_scrollController.position.pixels > 0 ? _scrollController.position.pixels : 0)) + _scrollController.position.pixels;

      // this page owns control over the pink container's size
      if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
        widget.disownCallback(HomePageIndices.profile);
      }
      widget.notifier.value = _containerHeight();

      // hide and show the "add picture" floating action button
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        _hideFab = false;
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        _hideFab = true;
      }

      // refreshing views and likes (maybe add picture refreshing too)
      // scroll threshold fixed to -100 maybe to be based on screen height but should be ok
      if (_scrollController.position.pixels <= -100) {
        if (!_refreshing && _finishedRefreshing) {

          _refreshing = true;
          _finishedRefreshing = false;

          GraphQLClient client = GraphQLHandler.client2;

          client.mutate(MutationOptions(documentNode: gql(GraphQLHandler.refreshLikesViews), onCompleted: (dynamic result) {
            setState(() {
              try {
                _views = result['getLikesViews']['info']['stats']['totalviews'];
                _likes = result['getLikesViews']['info']['stats']['totallikes'];
              } finally {
                _finishedRefreshing = true;
              }
            });
          }, variables: {'userid': widget.userId}));
        }
      }

      if (_refreshing) {
        if (_scrollController.position.pixels >= -10) {
          _refreshing = false;
        }
      }

      // when the image grid is scrolled all the way to the bottom
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // query more pictures maybe ? xd

        // after the picture list is supposedly updated from the query do some index calc
        if (_pictures.length - 1 > _pictureIndex) {
          _pictureIndex = (_pictureIndex + 9 < _pictures.length ? _pictureIndex + 9 : _pictures.length - 1);
        }
      }
    });});

    // initialize the picture index based on how many picture urls we have (max index 9)
    _pictureIndex = widget.pictureUrls.length < 9 ? widget.pictureUrls.length - 1 : 8;

    // copy the picture urls over
    _pictures = List<String>();

    for (int i = 0; i <= _pictureIndex; i++) {
      _pictures.add(widget.pictureUrls[i]);
    }

    // do some layout stuff after the first build is completed
    WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
  }

  // layout stuff
  _onBuildCompleted(Duration timestamp) {
    final RenderBox containerRenderBox = _bioKey.currentContext.findRenderObject();
    final containerPosition = containerRenderBox.localToGlobal(Offset.zero);

    setState(() {
      _containerPosition = containerPosition;
      _containerSize = containerRenderBox.size;
      widget.notifier.value = 150.0;
      widget.disownCallback(widget.myProfile ? HomePageIndices.profile : -1);
    });
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        // REFRESH ICON

        Positioned(
          top: _containerPosition.dy + _containerSize.height + Common.screenHeight * 0.1,
          child: Opacity(
            opacity: _scrollController.hasClients ? (_scrollController.position.pixels < 0 ? ((_scrollController.position.pixels * _scrollController.position.pixels * 0.00002) < 1 ? (_scrollController.position.pixels * _scrollController.position.pixels * 0.00002) : 1.0) : 0.0) : 0.0,
            child: Container(
              alignment: Alignment.center,
              width: Common.screenWidth,
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.rotationZ(-(_scrollController.hasClients ? 1.5*(100 / _scrollController.position.pixels)*(50 / _scrollController.position.pixels) : 0.0)),
                child: Icon(
                  Icons.refresh,
                  color: _scrollController.hasClients ? (_scrollController.position.pixels < -100 ? Color(0xFFCA436B) : Colors.grey) : Colors.grey,
                  size: 35,
                ),
              ),
            ),
          ),
        ),

        CustomScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[

            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                color: Colors.transparent,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[

                    // BIO / DESCRIPTION BOX

                    Positioned(
                      top: _topBioPadding,
                      left: Common.screenWidth * 0.1,
                      child: Container(
                        key: _bioKey,
                        width: Common.screenWidth * 0.8,
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean viverra suscipit risus, id dapibus velit egestas non plentesque consectetur, erat sit amet eleifend dictum, nibh sapien suscipit leo, nec elementum mi nunc in lacus.',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        padding: EdgeInsets.all(20),
                      ),
                    ),

                    // BIO / DESCRIPTION EDIT BUTTON

                    if (widget.myProfile)
                      Positioned(
                        top: _containerPosition.dy + _containerSize.height - 27.5 +
                            (_scrollController.hasClients ?
                            (_scrollController.position.pixels > 0 ? -1 : 0.5) *
                                (_scrollController.position.pixels * _scrollController.position.pixels * 0.0015 +
                                    (_scrollController.position.pixels > 0 ? _scrollController.position.pixels : 0)) + _scrollController.position.pixels
                                : 0),
                        right: Common.screenWidth * 0.05,
                        child: RawMaterialButton(
                          onPressed: () {
                          },
                          elevation: 2,
                          fillColor: Color(0xFFCA436B),
                          splashColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                      ),

                    Positioned(
                      top: _topBoxPadding,
                      left: Common.screenWidth * 0.05,
                      child: Hero(
                        tag: widget.myProfile ? 'preview_tag' : 'external_tag',
                        child: SizedBox(
                          width: Common.screenWidth * 0.9,
                          height: 150,
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  Common.profilePicture == null ?
                                  SizedBox(
                                    width: 75,
                                    height: 75,
                                    child: Material(
                                      elevation: 4,
                                      color: Colors.grey,
                                      shape: CircleBorder(),
                                    ),
                                  ) :
                                  Material(
                                    elevation: 4,
                                    shape: CircleBorder(),
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.transparent,
                                    child: Ink.image(
                                      image: widget.imageUrl == null ? FileImage(Common.profilePicture) : NetworkImage(widget.imageUrl),
                                      fit: BoxFit.cover,
                                      width: 75,
                                      height: 75,
                                      child: InkWell(
                                        onTap: () {},
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: Common.screenHeight * 0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(width: 10,),
                                          Text("${widget.name}", style: TextStyle(fontSize: 20)),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          RawMaterialButton(
                                              onPressed: () {
                                                if (widget.myProfile)
                                                  widget.tabCallback(3, 0);
                                                else
                                                  return;
                                              },
                                              constraints: BoxConstraints(),
                                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                              splashColor: Color(0xFFCA436B),
                                              padding: EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.remove_red_eye, size: 20),
                                                  SizedBox(width: 5,),
                                                  Text(_views.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                ],
                                              )
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          RawMaterialButton(
                                              onPressed: () {
                                                if (widget.myProfile)
                                                  widget.tabCallback(HomePageIndices.info, 1);
                                                else
                                                  //TODO do later, check if page already liked
                                                  return;
                                              },
                                              constraints: BoxConstraints(),
                                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                              splashColor: Color(0xFFCA436B),
                                              padding: EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.favorite, size: 20),
                                                  SizedBox(width: 5,),
                                                  Text(_likes.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                ],
                                              )
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),



                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.only(top: 0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProfileImageBox(imageUrl: _pictures[index]);
                  },
                  childCount: _pictures.length,
                ),
              ),
            ),

          ],
        ),

        // IMAGE GRID

//        ScrollConfiguration(
//          behavior: CmScrollBehavior(),
//          child: GridView.builder(
//            itemCount: _pictures.length,
//            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//              crossAxisCount: 3,
//            ),
//            itemBuilder: (BuildContext context, int index) {
//              return ProfileImageBox(imageUrl: _pictures[index]);
//            },
//            padding: EdgeInsets.fromLTRB(0, _containerPosition.dy + 140, 0, 0),
//            primary: false,
//            scrollDirection: Axis.vertical,
//            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//            controller: _scrollController,
//          ),
//        ),

//        // BIO / DESCRIPTION BOX
//
//        Positioned(
//          top: Common.screenHeight * 0.1 + 175 +
//              (_scrollController.hasClients ?
//                (_scrollController.position.pixels > 0 ? -1 : 0.5) *
//                (_scrollController.position.pixels * _scrollController.position.pixels * 0.0015 +
//                (_scrollController.position.pixels > 0 ? _scrollController.position.pixels : 0))
//              : 0),
//          left: Common.screenWidth * 0.1,
//          child: Container(
//            key: _bioKey,
//            width: Common.screenWidth * 0.8,
//            child: Text(
//              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean viverra suscipit risus, id dapibus velit egestas non plentesque consectetur, erat sit amet eleifend dictum, nibh sapien suscipit leo, nec elementum mi nunc in lacus.',
//              maxLines: 3,
//              overflow: TextOverflow.ellipsis,
//              style: TextStyle(fontSize: 15),
//            ),
//            decoration: BoxDecoration(
//              color: Colors.white,
//              border: Border.all(
//                color: Colors.grey,
//              ),
//              borderRadius: BorderRadius.all(Radius.circular(30)),
//            ),
//            padding: EdgeInsets.all(20),
//          ),
//        ),
//
//        // BIO / DESCRIPTION EDIT BUTTON
//
//        if (widget.myProfile)
//          Positioned(
//          top: _containerPosition.dy + _containerSize.height - 27.5 +
//              (_scrollController.hasClients ?
//              (_scrollController.position.pixels > 0 ? -1 : 0.5) *
//                  (_scrollController.position.pixels * _scrollController.position.pixels * 0.0015 +
//                      (_scrollController.position.pixels > 0 ? _scrollController.position.pixels : 0))
//                  : 0),
//          right: Common.screenWidth * 0.05,
//          child: RawMaterialButton(
//            onPressed: () {
//            },
//            elevation: 2,
//            fillColor: Color(0xFFCA436B),
//            splashColor: Colors.white,
//            child: Icon(
//              Icons.edit,
//              color: Colors.white,
//              size: 20,
//            ),
//            padding: EdgeInsets.all(15.0),
//            shape: CircleBorder(),
//          ),
//        ),

        // PROFILE BOX

//        Positioned(
//          top: Common.screenHeight * 0.1 +
//              (_scrollController.hasClients ?
//                (_scrollController.position.pixels > 0 ? -1 : 0.5) *
//                (_scrollController.position.pixels * _scrollController.position.pixels * 0.002)
//              : 0),
//          left: Common.screenWidth * 0.05,
//          child: Hero(
//            tag: widget.myProfile ? 'preview_tag' : 'external_tag',
//            child: SizedBox(
//              width: Common.screenWidth * 0.9,
//              height: 150,
//              child: Card(
//                elevation: 10,
//                color: Colors.white,
//                child: Container(
//                  padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//
//                      Common.profilePicture == null ?
//                      SizedBox(
//                        width: 75,
//                        height: 75,
//                        child: Material(
//                          elevation: 4,
//                          color: Colors.grey,
//                          shape: CircleBorder(),
//                        ),
//                      ) :
//                      Material(
//                        elevation: 4,
//                        shape: CircleBorder(),
//                        clipBehavior: Clip.hardEdge,
//                        color: Colors.transparent,
//                        child: Ink.image(
//                          image: widget.imageUrl == null ? FileImage(Common.profilePicture) : NetworkImage(widget.imageUrl),
//                          fit: BoxFit.cover,
//                          width: 75,
//                          height: 75,
//                          child: InkWell(
//                            onTap: () {},
//                          ),
//                        ),
//                      ),
//
//                      SizedBox(
//                        width: 10,
//                      ),
//
//                      Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          SizedBox(
//                            height: Common.screenHeight * 0.02,
//                          ),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              SizedBox(width: 10,),
//                              Text("${widget.name}", style: TextStyle(fontSize: 20)),
//                            ],
//                          ),
//
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              RawMaterialButton(
//                                onPressed: () {
//                                    if (widget.myProfile)
//                                      widget.tabCallback(3, 0);
//                                    else
//                                      return;
//                                  },
//                                  constraints: BoxConstraints(),
//                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
//                                  splashColor: Color(0xFFCA436B),
//                                  padding: EdgeInsets.all(10.0),
//                                  child: Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: <Widget>[
//                                      Icon(Icons.remove_red_eye, size: 20),
//                                      SizedBox(width: 5,),
//                                      Text(_views.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                                    ],
//                                  )
//                              ),
//                              SizedBox(
//                                width: 10,
//                              ),
//                              RawMaterialButton(
//                                  onPressed: () {
//                                    if (widget.myProfile)
//                                      widget.tabCallback(HomePageIndices.info, 1);
//                                    else
//                                      //TODO do later, check if page already liked
//                                      return;
//                                  },
//                                  constraints: BoxConstraints(),
//                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
//                                  splashColor: Color(0xFFCA436B),
//                                  padding: EdgeInsets.all(10.0),
//                                  child: Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: <Widget>[
//                                      Icon(Icons.favorite, size: 20),
//                                      SizedBox(width: 5,),
//                                      Text(_likes.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                                    ],
//                                  )
//                              ),
//                            ],
//                          )
//                        ],
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ),

        // ADD PICTURE BUTTON

        if (widget.myProfile)
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            bottom: _hideFab ? -100 : Common.screenHeight * 0.02,
            right: Common.screenWidth * 0.05,
            child: FloatingActionButton(
              onPressed: () {
                Future<QueryResult> r = ImageHandler.openGallery(Common.userid,false);
                r.then((value) {
                  setState(() {
                    print(value.data);
                    _pictures.insert(0,value.data['upload']);
                    _pictureIndex++;
                  });
                });
              },
              child: Icon(Icons.add_photo_alternate),
              backgroundColor: Color(0xFFCA436B),
              splashColor: Colors.white,
            ),
          )

      ],
    );
  }
}