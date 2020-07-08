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
      _image = image;
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
                              FlatButton(
                                child: Text('aaa'),
                                onPressed: openGallery,
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
        ],
      )
    );
  }
}