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
  final Function(int) callback;
  final Function(int) disownCallback;
  final ValueNotifier<double> notifier;
  final String name;
  final String imageUrl;
  final List<String> pictureUrls;
  final int totallikes;
  final int totalviews;
  ProfilePage({Key key, @required this.callback, @required this.disownCallback, @required this.notifier, @required this.name, @required this.imageUrl, @required this.pictureUrls,@required this.totalviews, @required this.totallikes});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {

  @override
  bool get wantKeepAlive => true;

  GlobalKey _bioKey = GlobalKey();
  Offset _containerPosition = Offset(0, 0);
  Size _containerSize = Size(0, 0);

  ScrollController _scrollController;

  List<String> _pictures;
  int _pictureIndex;
  

  bool _hideFab = false;

  double _containerHeight() {
    return Common.screenHeight * 0.2 +
                        (_scrollController.hasClients ?
                          (_scrollController.position.pixels > 0 ? -1 : 0.5) *
                          (Common.screenHeight * 0.2 - (_scrollController.position.pixels * _scrollController.position.pixels * 0.001) >= 0 ?
                          (_scrollController.position.pixels * _scrollController.position.pixels * 0.001)
                          : Common.screenHeight * 0.2)
                        : 0);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {setState(() {
      widget.disownCallback(4);
      widget.notifier.value = _containerHeight();

      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        _hideFab = false;
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        _hideFab = true;
      }

      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // query more ?? idk
        if (_pictures.length - 1 > _pictureIndex) {
          _pictureIndex = (_pictureIndex + 9 < _pictures.length ? _pictureIndex + 9 : _pictures.length - 1);
        }
      }
    });});

    _pictureIndex = widget.pictureUrls.length < 9 ? widget.pictureUrls.length - 1 : 8;
    _pictures = List<String>();

    for (int i = 0; i <= _pictureIndex; i++) {
      _pictures.add(widget.pictureUrls[i]);
    }

    WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
  }

  _onBuildCompleted(Duration timestamp) {
    final RenderBox containerRenderBox = _bioKey.currentContext.findRenderObject();
    final containerPosition = containerRenderBox.localToGlobal(Offset.zero);
    //while (!_scrollController.hasClients) {}
    setState(() {
      _containerPosition = containerPosition;
      _containerSize = containerRenderBox.size;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

//        Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Container(
//                height: Common.screenHeight * 0.2 +
//                        (_scrollController.hasClients ?
//                          (_scrollController.position.pixels > 0 ? -1 : 0.5) *
//                          (Common.screenHeight * 0.2 - (_scrollController.position.pixels * _scrollController.position.pixels * 0.001) >= 0 ?
//                          (_scrollController.position.pixels * _scrollController.position.pixels * 0.001)
//                          : Common.screenHeight * 0.2)
//                        : 0),
//                color: Color(0xFFCA436B),
//              ),
//              Expanded(
//                child: Container(
//                  color: Colors.white,
//                ),
//              ),
//            ]
//        ),

        Positioned(
          top: _containerPosition.dy + _containerSize.height + Common.screenHeight * 0.1,
          //bottom: _scrollController.hasClients ? (_scrollController.position.pixels < 0 ? (400 + -_scrollController.position.pixels * 1.5 < Common.screenHeight * 0.3 ? -_scrollController.position.pixels * 1.5 : Common.screenHeight * 0.3) : 0) : 0,
          //left: Common.screenWidth * 0.5,// +_scrollController.position.pixels* 0.125,
          child: Opacity(
            opacity: _scrollController.hasClients ? (-(_scrollController.position.pixels * 0.002) < 1 ? (_scrollController.position.pixels < 0 ? -(_scrollController.position.pixels * 0.002) : 0.0) : 1.0) : 1.0,
            child: Container(
              alignment: Alignment.center,
              width: Common.screenWidth,
              child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.rotationZ(-(_scrollController.hasClients ? 1.5*(100 / _scrollController.position.pixels)*(100 / _scrollController.position.pixels) : 0.0)),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.grey,
                    size: 35,
                    //size: _scrollController.hasClients ? (-_scrollController.position.pixels*-_scrollController.position.pixels* 0.002 < 50 ? -_scrollController.position.pixels*-_scrollController.position.pixels* 0.002 : 50) : 0,
                  ),
                ),
            ),
          ),
        ),

        ScrollConfiguration(
          behavior: CmScrollBehavior(),
          child: GridView.builder(
            itemCount: _pictures.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ProfileImageBox(imageUrl: _pictures[index]);
            },
            padding: EdgeInsets.fromLTRB(0, _containerPosition.dy + 140, 0, 0),
            primary: false,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
          ),
        ),

        Positioned(
          top: Common.screenHeight * 0.1 + 175 +
              (_scrollController.hasClients ?
                (_scrollController.position.pixels > 0 ? -1 : 0.5) *
                (_scrollController.position.pixels * _scrollController.position.pixels * 0.0015 +
                (_scrollController.position.pixels > 0 ? _scrollController.position.pixels : 0))
              : 0),
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

        Positioned(
          top: _containerPosition.dy + _containerSize.height - 27.5 +
              (_scrollController.hasClients ?
              (_scrollController.position.pixels > 0 ? -1 : 0.5) *
                  (_scrollController.position.pixels * _scrollController.position.pixels * 0.0015 +
                      (_scrollController.position.pixels > 0 ? _scrollController.position.pixels : 0))
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
          top: Common.screenHeight * 0.1 +
              (_scrollController.hasClients ?
                (_scrollController.position.pixels > 0 ? -1 : 0.5) *
                (_scrollController.position.pixels * _scrollController.position.pixels * 0.002)
              : 0),
          left: Common.screenWidth * 0.05,
          child: Hero(
            tag: 'preview_tag',
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
                                onPressed: () { widget.callback(3); },
                                  constraints: BoxConstraints(),
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  splashColor: Color(0xFFCA436B),
                                  padding: EdgeInsets.all(10.0), // optional, in order to add additional space around text if needed
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.remove_red_eye, size: 20),
                                      SizedBox(width: 5,),
                                      Text(widget.totalviews.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ],
                                  )
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              RawMaterialButton(
                                  onPressed: () { widget.callback(3); },
                                  constraints: BoxConstraints(),
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  splashColor: Color(0xFFCA436B),
                                  padding: EdgeInsets.all(10.0), // optional, in order to add additional space around text if needed
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.favorite, size: 20),
                                      SizedBox(width: 5,),
                                      Text(widget.totallikes.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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