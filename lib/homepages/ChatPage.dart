import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPageState createState() => ChatPageState();

}

class ChatPageState extends State<ChatPage> {
  @override
  void initState(){

  }
  Socket socket;
  void test() async {
    final client = await Socket.connect('192.168.0.30', 9999);
    print("connected");
    client.add(utf8.encode('14\n'));
    await client.flush();
    //EQUIVALENT OF STRING BUILDER HERE
    //DATA Arrives in packets (thus each data instance is part of string)
    //BRACKET as indicator when its finished
    //USE STACK FOR THIS
    client.listen(
            (var data) => print('Got $data'),
        onDone: () { print('Done'); client.close(); },
        onError: (e) { print('Got error $e'); client.close(); });
    print('main done');
    await Future.delayed(Duration(seconds: 30));
  }

  void dataHandler(data){
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }

  void doneHandler(){
    socket.destroy();
    exit(0);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(onPressed: (){
        print("test");
        test();
      },textColor: Colors.white,child: const Text('Gradient Button', style: TextStyle(fontSize: 20)),
      ),
    );
  }
  
}