import 'dart:collection';
import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';


//TODO use saved preferences, currently stored in runtime
class ChatCreator {
  static Map<int,List<ChatMessage>> _savedchats = HashMap<int,List<ChatMessage>>();

  static bool chatSaved(int userid){
    if(_savedchats != null && _savedchats[userid] != null){
      print(_savedchats[userid]);
      print("its here");
      return _savedchats[userid].length == 0 ? true:false;
    }
    else{
      return false;
    }
   }


   static void addChat(int userid, ChatMessage message){
    if(_savedchats.containsKey(userid)){
      _savedchats[userid].insert(0, message);
    }
    else{
      List<ChatMessage> list = List<ChatMessage>();
      list.add(message);
      _savedchats[userid] = list;
    }

   }
   
   static List<ChatMessage> getMsg(int userid){
    if(chatSaved(userid)){
      return _savedchats[userid];
    }
    return new List<ChatMessage>();
   }
}
