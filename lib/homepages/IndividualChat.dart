import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:dating/ChatLogic/DataHandler.dart';
import 'package:dating/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class IndividualChat extends StatefulWidget{
  ChatUser caller;
  ChatUser other;
  Socket s;
  IndividualChat(this.caller,this.other,this.s);

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  @override
  IndividualChatState createState() => IndividualChatState();
}

class IndividualChatState extends State<IndividualChat>{
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  bool initialized = false;
  //FORMAT OF CHAT users
  final ChatUser user = ChatUser(
    name: "Fayeed",
    firstName: "Fayeed",
    lastName: "Pawaskar",
    uid: "12345678",
  );

  final ChatUser otherUser = ChatUser(
    name: "Mrfatty",
    uid: "25649654",
  );


  void onSend(ChatMessage message) async {
    print(message.toJson());
  }

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  @override
  void initState(){
    test();
  }

  Socket socket;
  void test() async {
    socket = await Socket.connect('192.168.0.30', 9999);
    print("connected");
    socket.add(utf8.encode('14\n'));
    await socket.flush();
    //EQUIVALENT OF STRING BUILDER HERE
    //DATA Arrives in packets (thus each data instance is part of string)
    //BRACKET as indicator when its finished
    //USE STACK FOR THIS
    Common.streamController.addStream(socket.asBroadcastStream());
    Common.streamController.stream.listen(
            (var data) {
          print('Got $data');
          AsciiCodec code = new AsciiCodec();
          print(code.decode(data));

        },
        onDone: () { print('Done'); socket.close(); },
        onError: (e) { print('Got error $e'); socket.close(); });
    print('main done');
    await Future.delayed(Duration(seconds: 1000));
  }

  DataHandler handler = DataHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO make this variable?
        title: Text("My Chat"),
      ),
      body: StreamBuilder(stream:Common.streamController.stream, builder: (context, snapshot){
        if(!snapshot.hasData){
          //TODO save chat locally do not requery for efficiency purposes
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //TODO verify that input is full message
        else{
          AsciiCodec code = new AsciiCodec();
          String js = code.decode(snapshot.data);
          print(js);
          handler.handleString(js);
          initialized = true;
          if(handler.complete()){
              dynamic c = json.decode(handler.getDone());
              print(c);
              print(c["message"]);
              this.messages.add(ChatMessage(text: c["message"], user: widget.other));
          }
          else {
            this.messages.add(ChatMessage(text: "anani sikerim test", user: widget.other));
          }
          return DashChat(messages: widget.messages, user: widget.caller,onSend: null);
          //dynamic c = json.decode(js);
          
          print(snapshot.data);
        }
      })
    );
  }
}