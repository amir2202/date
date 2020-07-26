import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  dynamic data;
  Future<QueryResult> result;
  @override
  GraphQLClient client = GraphQLHandler.client2;
  Future<QueryResult> getChats() async {
    return await client.mutate(MutationOptions(documentNode: gql(GraphQLHandler.recentChats),variables: {'userid':Common.userid}));
  }

  void initState(){
    print(Common.userid);
    result = getChats();
    result.then((value) {
      setState(() {
        print(value.data);
        print(value.data["getRecentChats"][0]);
        data = value;
      });
    });
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
            (var data) {
              print('Got $data');
              AsciiCodec code = new AsciiCodec();
              print(code.decode(data));

            },
        onDone: () { print('Done'); client.close(); },
        onError: (e) { print('Got error $e'); client.close(); });
    print('main done');
    await Future.delayed(Duration(seconds: 1000));
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
      if(snapshot.data != null){
        return ScrollConfiguration(
          behavior: CmScrollBehavior(),
          child: ListView.builder(
            itemCount: data.data["getRecentChats"].length,
            //controller: widget.notifier.value == widget.like ? widget.scrollController : null,
            itemBuilder: (BuildContext context, int index) {
              return ChatRow(name:data.data["getRecentChats"][index]["info"]["name"], imageUrl:data.data["getRecentChats"][index]["profilepic"], lastmessage:"ANANI",lastdate: "23:59",);
            },
            padding: EdgeInsets.fromLTRB(0, Common.screenHeight * 0.12 + Common.screenHeight * 0.05, 0, 0),
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          ),
        );
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
  final String id = Common.userid;
  String lastdate;
  String lastmessage;
  ChatRow({Key key, @required this.name, @required this.imageUrl, @required this.lastmessage,@required this.lastdate});

  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {

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
                  Text('EXAMPLE MESSAGE', overflow: TextOverflow.ellipsis),
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