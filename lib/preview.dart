import 'package:date/common.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'dart:io';
import 'dart:async';

class PreviewPage extends StatefulWidget {
  @override
  PreviewPageState createState() => PreviewPageState();
}

class PreviewPageState extends State<PreviewPage> {

  File _image;

  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image == null ? _image : image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'One last step...',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: Common.screenHeight * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'preview_tag',
                    child: SizedBox(
                      width: Common.screenWidth * 0.9,
                      height: 200,
                      child: Card(
                        elevation: 10,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 0,
                              ),
                              _image == null ?
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: RawMaterialButton(
                                  onPressed: openGallery,
                                  elevation: 4,
                                  fillColor: Colors.white,
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                              ) :
                              Material(
                                elevation: 4,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: Colors.transparent,
                                child: Ink.image(
                                  image: FileImage(_image),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  child: InkWell(
                                    onTap: openGallery,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Text("${Common.fullName}", style: TextStyle(fontSize: 25), ),
                              )
                            ],
                          ),
                        )
                      ),
                    ),
                  )
                ],
              )
            ],
          ),

          Positioned(
            child: Opacity(
              opacity: _image == null ? 0 : 1,
              child: RawMaterialButton(
                onPressed: () {},
                elevation: 10,
                fillColor: Color(0xFFCA436B),
                splashColor: Colors.white,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
            top: Common.screenHeight * 0.5 + 75,
            left: Common.screenWidth * 0.9 - 100,
          )
        ],
      )
    );
  }
}