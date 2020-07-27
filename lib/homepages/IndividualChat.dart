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
  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  void onSend(ChatMessage message) async {
    print(message.toJson());
  }



  var i = 0;
  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
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
          dynamic c = json.decode(handler.getDone());
          print(c);
          if(handler.complete()){
            print(c["message"]);
            messages.add(ChatMessage(text: c["message"], user: widget.other));
          }
          return DashChat(messages: messages, user: widget.caller,onSend: null);
          //dynamic c = json.decode(js);
          
          print(snapshot.data);
        }
      })
    );
  }
}