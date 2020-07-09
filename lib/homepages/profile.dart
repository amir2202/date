import 'package:flutter/material.dart';
import 'package:dating/common.dart';

class CmScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class ProfilePage extends StatefulWidget {
  final Function(int) callback;
  final String name;
  ProfilePage({Key key, @required this.callback, @required this.name});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  GlobalKey _bioKey = GlobalKey();
  Offset _containerPosition = Offset(0, 0);
  Size _containerSize = Size(0, 0);

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {setState(() { });});

    WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
  }
  _onBuildCompleted(Duration timestamp) {
    final RenderBox containerRenderBox = _bioKey.currentContext.findRenderObject();
    final containerPosition = containerRenderBox.localToGlobal(Offset.zero);
    setState(() {
      _containerPosition = containerPosition;
      _containerSize = containerRenderBox.size;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: (Common.screenHeight * 0.2 - (
                    (_scrollController.hasClients ? _scrollController.position.pixels * _scrollController.position.pixels * 0.001 : 0)) < 0 ? 0 :
                    Common.screenHeight * 0.2 - (_scrollController.hasClients ? _scrollController.position.pixels * _scrollController.position.pixels * 0.001 : 0)
                ),
                color: Color(0xFFCA436B),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ]
        ),

        ScrollConfiguration(
          behavior: CmScrollBehavior(),
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Container(
                height: 1000,
                margin: EdgeInsets.fromLTRB(20, _containerPosition.dy + 120, 20, 20),
                child: Card(
                  elevation: 3,
                ),
              )
            ],
          ),
        ),

        Positioned(
          top: Common.screenHeight * 0.1 + 175 - (_scrollController.hasClients ? _scrollController.position.pixels * _scrollController.position.pixels * 0.0015 + _scrollController.position.pixels : 0),
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
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            padding: EdgeInsets.all(20),
          ),
        ),

        Positioned(
          bottom: _containerPosition.dy + _containerSize.height - 15 + (_scrollController.hasClients ? _scrollController.position.pixels * _scrollController.position.pixels * 0.0015 + _scrollController.position.pixels : 0),
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
          top: Common.screenHeight * 0.1 - (_scrollController.hasClients ? _scrollController.position.pixels * _scrollController.position.pixels * 0.002 : 0),
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
                          image: FileImage(Common.profilePicture),
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
                                      Text('248', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                                      Text('64', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
    );
  }
}