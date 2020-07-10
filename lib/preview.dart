import 'package:dating/GraphQLHandler.dart';
import 'package:dating/common.dart';
import 'package:dating/imagelogic/ImageHandler.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'home.dart';

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
      Common.profilePicture = _image;
    });
  }

  void storeImage(String id) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    final File newImage = await _image.copy('$path/pfp.jpg');
    ImageHandler.uploadImage(newImage,id);
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLHandler.client,
      child: Scaffold(
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
              ), Positioned(
                  top: Common.screenHeight * 0.5 + 75,
                  left: Common.screenWidth * 0.9 - 100,
                  child: Mutation(options: MutationOptions(
                    documentNode: gql(GraphQLHandler.registerUser),
                      onCompleted: (dynamic result) {
                        print(result);
                        storeImage("1");
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(name: Common.fullName)), (r) => false);
                      })
                    ,builder: (RunMutation runMutation,QueryResult result){
                        return Opacity(
                          opacity: _image == null ? 0 : 1,
                          child: RawMaterialButton(
                            onPressed: () {
                              runMutation({'name': Common.fullName, 'password': Common.password, 'premium':Common.premium,'email':Common.email,'gender': Common.gender, 'birthday':Common.birthday, 'country': Common.country,'haircolor':Common.haircolor,'eyecolor':Common.eyecolor,'body':Common.body,'height':Common.height, 'ethnicity':Common.ethnicity,'religion':Common.religion,'state':Common.state,'facebook':Common.facebook});
                            },
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
                        );
                      },
                  )
              )
            ],
          )
      ),
    );
  }
}