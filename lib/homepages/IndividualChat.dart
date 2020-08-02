import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:dating/ChatLogic/ChatCreator.dart';
import 'package:dating/ChatLogic/DataHandler.dart';
import 'package:dating/ChatLogic/MessageService.dart';
import 'package:dating/GraphQLHandler.dart';
import 'package:dating/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';



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




  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();
  Future<QueryResult> fut;
  dynamic result;
  bool completed = false;
  @override
  void initState(){
    ChatCreator creator = ChatCreator();
    //CHECK if previous messages already exist, if so create
    int id = int.parse(widget.caller.uid);
    fut = MessageService.previousMessages(widget.caller,int.parse(widget.caller.uid),int.parse(widget.other.uid));
    fut.then((value) {
      result = value.data;
      completed = true;

      List<ChatMessage> list = List<ChatMessage>();
      print(result);
      for(dynamic msgdata in result["recentChats"]){
        //FIX this, make other or caller dependingf on UID
        print(msgdata["by"]);
        print(msgdata["by"]==widget.caller.uid);
        ChatMessage message = ChatMessage(text: msgdata["message"], user: msgdata["by"] == int.parse(widget.caller.uid) ? widget.caller:widget.other,createdAt:DateTime.parse(msgdata["date"]));
        list.add(message);
      }
      print(list.length);
      for(int i = list.length -1;i>=0;i--){
        MessageService.messages.add(list.elementAt(i));
      }
      setState(() {

      });
    });
    /*if(ChatCreator.chatSaved(id)){
      print("attempting to get id");
      messages = ChatCreator.getMsg(id);
      print(messages);
      print("shouldnt execute");
    }*/
    //test();
  }

  Socket socket;
  void test() async {
    //54.37.205.205
    socket = await Socket.connect('192.168.0.30', 9999);
    print("connected");
    socket.add(utf8.encode(Common.userid + '\n'));
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
          String js = code.decode(data);
          print(js);
          handler.handleString(js);
          initialized = true;
          if(handler.complete()){
            dynamic c = json.decode(handler.getDone());
            print(c);
            print(c["message"]);
            setState(() {
              print("the var");
              print(c["by"]);
              print(c["by"] == widget.caller.uid);
              messages.add(ChatMessage(text: c["message"], user: widget.caller));
            });
            ChatCreator.addChat(c["by"],ChatMessage(text: c["message"], user: widget.caller));
          }

        },
        onDone: () { print('Done'); socket.close(); },
        onError: (e) { print('Got error $e'); socket.close(); });
    print('main done');
    await Future.delayed(Duration(seconds: 1000));
  }

  void onSend(ChatMessage message) async {
    print(message.toJson());
    setState(() {
      print("executes");
      MessageService.messages.add(message);
    });
    dynamic msg = message.toJson();
    print(msg);
    GraphQLHandler.client2.mutate(MutationOptions(documentNode: gql(GraphQLHandler.sendMessage),variables:{'towards':widget.other.uid,'by':widget.caller.uid,'message':msg["text"]},onCompleted: (dynamic result){
      print("got");

    }));
  }



  DataHandler handler = DataHandler();
  @override
  Widget build(BuildContext context){
    //DO A FUTURE builder later...
    return FutureBuilder(future:fut,builder: (context,snapshot){
      if(snapshot.hasData == null){
        return CircularProgressIndicator();
      }
      //have a changenotifier within
      else if(snapshot.hasData != null && completed){
        print("messages length");
        print(MessageService.messages.length);
        return Scaffold(
          appBar: AppBar(
              title: Row(children: <Widget>[Material(
                elevation: 4,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: Ink.image(
                  image: NetworkImage(widget.caller.avatar),
                  fit: BoxFit.cover,
                  width:50,
                  height: 75,
                  child: InkWell(
                    onTap: () {},
                  ),
                ),
              ),SizedBox(
                width: 5,
              ),Text(widget.other.name)])
          ),
          body: ChangeNotifierProvider(
            create: (context) => MessageService(widget.caller,widget.other),
            child: Consumer<MessageService>(
                builder:(context,MessageService,child) {
                  return DashChat(messages: MessageService.getMsg(),showAvatarForEveryMessage: true, user: widget.other, onSend: onSend);

                },
                child: DashChat(messages: MessageService.messages,showAvatarForEveryMessage: true, user: widget.other, onSend: onSend),

            )
          )
        );
      }
      else{
        return CircularProgressIndicator();
      }
    });
    Scaffold(
      appBar: AppBar(

        title: Row(children: <Widget>[Material(
          elevation: 4,
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: Ink.image(
            image: NetworkImage(widget.caller.avatar),
            fit: BoxFit.cover,
            width:50,
            height: 75,
            child: InkWell(
              onTap: () {},
            ),
          ),
        ),SizedBox(
          width: 5,
        ),Text(widget.other.name)])
      ),
      body: DashChat(messages: messages,showAvatarForEveryMessage: true, user: widget.other, onSend: onSend),
    );
  }


  /*Widget build(BuildContext context) {
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
  }*/
}