import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat/dash_chat.dart';
import 'package:dating/homepages/IndividualChat.dart';
import 'package:dating/homepages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../GraphQLHandler.dart';
import '../common.dart';

class ChatPage extends StatefulWidget {
  ChatPageState createState() => ChatPageState();
  dynamic recentchats;
  ChatPage({Key key,@required this.recentchats});
}

class ChatPageState extends State<ChatPage> {
  dynamic input;
  bool nochats = false;
  Future<QueryResult> result;
  @override
  GraphQLClient client = GraphQLHandler.client2;
  Future<QueryResult> getChats() async {
    return await client.mutate(MutationOptions(documentNode: gql(GraphQLHandler.recentChats),variables: {'caller':Common.userid}));
  }

  void initState(){
    print(Common.userid);
    result = getChats();
    result.then((value) {
      setState(() {
        print(value.data);
        if(value.data["getRecentChats"] == null){
          print("this works");
          nochats = true;
        }
        else {
          print(value.data);
          print(value.data["getRecentChats"][0]);
          input = value;
        }
      });
    });
  }
  String convertDate(){

  }



  void dataHandler(data){
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }


  @override
 /* Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(onPressed: (){
        print("test");
        test();
      },textColor: Colors.white,child: const Text('Gradient Button', style: TextStyle(fontSize: 20)),
      ),
    );
  }*/
  Widget build(BuildContext context) {
    //TODO
    //CHANGE THIS TO future builder
    return FutureBuilder(future: result,builder: (context,snapshot){
      if(snapshot.data != null && nochats == false){
        return ScrollConfiguration(
          behavior: CmScrollBehavior(),
          child: ListView.builder(
            itemCount: input.data["getRecentChats"].length,
            //controller: widget.notifier.value == widget.like ? widget.scrollController : null,
            itemBuilder: (BuildContext context, int index) {
              return ChatRow(name:input.data["getRecentChats"][index]["info"]["name"], imageUrl:input.data["getRecentChats"][index]["profilepic"], lastmessage:input.data["getRecentChats"][index]["latestMessage"]["message"],lastdate: "23:59",otherid: input.data["getRecentChats"][index]["userid"] ,);
            },
            padding: EdgeInsets.fromLTRB(0, Common.screenHeight * 0.12 + Common.screenHeight * 0.05, 0, 0),
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          ),
        );
      }
      else if(snapshot.data != null && nochats == true){
        return Container(child: Text("you have no chats... TODO"));
      }
      else{
        return CircularProgressIndicator();
      }
    });

  }
  
}

class ChatRow extends StatelessWidget {
  @override
  final String name;
  final String imageUrl;
  final Socket socket;
  final String id = Common.userid;
  final String otherid;
  String lastdate;
  String lastmessage;
  ChatRow({Key key, @required this.name, @required this.imageUrl, @required this.lastmessage,@required this.lastdate,@required this.socket,@required this.otherid});

  Widget build(BuildContext context) {
    // TODO: fix for nulls..
    return Material(
      color: Colors.transparent,


      child: InkWell(
        onTap: () {
          print(this.socket);

          ChatUser caller = ChatUser(
            //name: Common.fullName,
            //uid: Common.userid,
            //avatar: Common.profileLink,
            name: Common.fullName,uid:Common.userid,avatar:Common.profileLink
          );
          ChatUser other = ChatUser(
            name: name,
            avatar: imageUrl,
            uid: otherid,
          );
          print("other");
          print(other.toJson());
          print("caller");
          print(caller.toJson());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IndividualChat(caller, other, this.socket)
              )
          );
          //GO TO NEXT PAGE WITH SOCKET
          /*GraphQLHandler.client2.mutate(
              MutationOptions(
                  documentNode: gql(GraphQLHandler.getProfile),
                  variables: { 'userid':this.id },
                  onCompleted: (dynamic resultData) {
                    print(resultData);

                    List<dynamic> pics = resultData['getProfileUID']['pictures'];
                    List<String> pics2 = List<String>();

                    for(dynamic el in pics){
                      pics2.add(el['filepath']);
                      print(el['filepath']);
                    }

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => ProfileExternalPage(
                              name: resultData['getProfileUID']['info']['name'],
                              imageUrl: resultData['getProfileUID']['profilepic'],
                              pictureUrls: pics2,
                              totalViews: resultData['getProfileUID']['info']['stats']['totalviews'],
                              totalLikes: resultData['getProfileUID']['info']['stats']['totallikes']
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return SlideTransition(position: animation.drive(Tween(begin: Offset(0,1), end: Offset.zero).chain(CurveTween(curve: Curves.ease))), child: child);
                          }
                      ),
                    );
                  }
              )
          );*/
        },
        splashColor: Colors.grey.withOpacity(0.5),
        child: Container(
          height: Common.screenHeight * 0.2,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(this.imageUrl),
                backgroundColor: Colors.grey,
                radius: 25,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${this.name}', style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),SizedBox(
                    width: 5,
                  ),
                  Text(this.lastmessage, overflow: TextOverflow.ellipsis),
                ],
              ), SizedBox(
                width: 100,
              ), Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(this.lastdate, style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),SizedBox(
                    width: 5,
                  ),
                  Text('read', overflow: TextOverflow.ellipsis),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}