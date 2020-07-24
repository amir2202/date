import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  State<StatefulWidget> createState() {

    throw UnimplementedError();
  }

}

class ChatPageState extends State<ChatPage> {
  @override
  void initState(){

  }

  void test() async{
    Socket socket = await Socket.connect("54.37.205.205", 9999);
    socket.write("53");
    socket.listen((List<int> event) {
      print(utf8.decode(event));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton.icon(onPressed:() {
        test();

      }, icon: null, label: Text('hi')) ,
    );
  }
  
}