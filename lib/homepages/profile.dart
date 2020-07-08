import 'package:flutter/material.dart';
import 'package:dating/common.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) callback;
  final String name;
  ProfilePage({Key key, @required this.callback, @required this.name});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: Common.screenHeight * 0.2,
                color: Color(0xFFCA436B),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ]
        ),

        Positioned(
          top: Common.screenHeight * 0.1,
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

        Positioned(
          top: Common.screenHeight * 0.1 + 175,
          left: Common.screenWidth * 0.1,
          child: Container(
            width: Common.screenWidth * 0.8,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean viverra suscipit risus, id dapibus velit egestas non plentesque consectetur, erat sit amet eleifend dictum, nibh sapien suscipit leo, nec elementum mi nunc in lacus.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15),
                ),
                Positioned(
                  bottom: -45,
                  right: -50,
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
              ]
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


      ],
    );
  }
}