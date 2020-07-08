import 'package:flutter/material.dart';
import 'package:dating/common.dart';

class ProfilePage {
  static Widget profilePage() {

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
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
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
                        width: 20,
                      ),
                      Flexible(
                        child: Text("${Common.fullName}", style: TextStyle(fontSize: 20), ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}