import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
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


  //FORMAT OF CHAT users
  final ChatUser user = ChatUser(
    name: "Fayeed",
    firstName: "Fayeed",
    lastName: "Pawaskar",
    uid: "12345678",
    avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
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
        else{
          AsciiCodec code = new AsciiCodec();
          print("NEW DATA");
          print(snapshot.data);
          return DashChat(messages: messages, user: widget.caller, onSend: null);
          print(snapshot.data);
        }
      })
    );
  }
}