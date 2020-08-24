import 'package:dating/messaging/LocalNotifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../intro.dart';


class FireBaseHandler{
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      print("background tss");
      print(message);
      //NotificationHandler.displayNotification(message["data"]["data"], message["data"]["title"]);
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      print("background tss");
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }
}


class Loading extends StatefulWidget {
  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> {
  String _homeScreenText = "Waiting for token...";
  bool _topicButtonsDisabled = false;

  final TextEditingController _topicController =
  TextEditingController(text: 'topic');



  @override
  void initState() {
    super.initState();
    //CHECK FOR sharedsetting userid

    FirebaseMessaging firebaseMessaging = FireBaseHandler.firebaseMessaging;
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        dynamic c = message["notification"];
        NotificationHandler.displayNotification(c["title"],c["body"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },onBackgroundMessage: FireBaseHandler.myBackgroundMessageHandler
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: intro(),
    );
    /*return Scaffold(
        appBar: AppBar(
          title: const Text('Push Messaging Demo'),
        ),
        // For testing -- simulate a message being received
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showItemDialog(<String, dynamic>{
            "data": <String, String>{
              "id": "2",
              "status": "out of stock",
            },
          }),
          tooltip: 'Simulate Message',
          child: const Icon(Icons.message),
        ),
        body: Material(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(_homeScreenText),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: TextField(
                      controller: _topicController,
                      onChanged: (String v) {
                        setState(() {
                          _topicButtonsDisabled = v.isEmpty;
                        });
                      }),
                ),
                FlatButton(
                  child: const Text("subscribe"),
                  onPressed: _topicButtonsDisabled
                      ? null
                      : () {
                    firebaseMessaging
                        .subscribeToTopic(_topicController.text);
                    _clearTopicText();
                  },
                ),
                FlatButton(
                  child: const Text("unsubscribe"),
                  onPressed: _topicButtonsDisabled
                      ? null
                      : () {
                    firebaseMessaging
                        .unsubscribeFromTopic(_topicController.text);
                    _clearTopicText();
                  },
                ),
              ])
            ],
          ),
        ));*/
  }

  void _clearTopicText() {
    setState(() {
      _topicController.text = "";
      _topicButtonsDisabled = true;
    });
  }
}