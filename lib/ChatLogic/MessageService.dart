import 'dart:convert';
import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:dating/ChatLogic/DataHandler.dart';
import 'package:dating/GraphQLHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../common.dart';
import 'ChatCreator.dart';

/*class MessagesService extends ChangeNotifier {
  final messages = <ChatMessage>[];
  void listen() async {
    for (var msg in stream) {
      messages.add(doThing(msg));
      notifyListeners();
    }
  }

      SharedPreferences shared_User = await SharedPreferences.getInstance();
    Map decode_options = jsonDecode(jsonString);
    String user = jsonEncode(_savedchats.fr);
    shared_User.setString('user', user);
}*/

class MessageService extends ChangeNotifier {
  ChatUser caller;
  ChatUser other;
  MessageService(ChatUser caller,ChatUser other){
    this.caller = caller;
    this.other = other;
    listen();
  }
  static final messages = <ChatMessage>[];
  Socket socket;
  DataHandler handler = DataHandler();

  List<ChatMessage> getMsg(){
    return messages;
  }

  void listen() async {
    //54.37.205.205
    socket = await Socket.connect('54.37.205.205', 9999);
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
          if(handler.complete()){
            dynamic c = json.decode(handler.getDone());
            print(c);
            print(c["message"]);
            messages.add(ChatMessage(text: c["message"], user: caller));
            notifyListeners();
            //ChatCreator.addChat(c["by"],ChatMessage(text: c["message"], user: widget.caller));
          }

        },
        onDone: () { print('Done'); socket.close(); },
        onError: (e) { print('Got error $e'); socket.close(); });
    print('main done');
    await Future.delayed(Duration(seconds: 1000));
  }


  static Future<QueryResult> previousMessages(ChatUser caller,int to,int by) async{
      //FIRST CHECK IF LOCALLY there are prev messages
      //TODO
    return await GraphQLHandler.client2.mutate(MutationOptions(documentNode: gql(GraphQLHandler.prevMessages),variables: {'by':by,'towards':to}));

      //PROCEED TO DOWNLOAD recent messages if not
  }



}