import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GraphQLHandler.dart';
import 'common.dart';
import 'home.dart';
import 'homepages/profile.dart';
import 'homepages/ChatPage.dart';
import 'homepages/profile_external.dart';
import 'messaging/Firebase.dart';

class CommonLogic{
  static void login(BuildContext context,String userid,String name,String imageUrl,List<String> pictureUrls,int totalViews, int totalLikes,bool premium) async{
    print("subscribin");
    Common.userid = userid;
    Common.fullName = name;
    Common.premium = premium;
    Common.profileLink = imageUrl;
    FireBaseHandler.firebaseMessaging.subscribeToTopic(userid);
    SharedPreferences pref = await SharedPreferences.getInstance().then((value) {
      value.setInt("LastLogin", int.parse(userid));
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                userId: userid,
                name: name,
                totalLikes: totalLikes,
                totalViews: totalViews,
                imageUrl: imageUrl,
                pictureUrls: pictureUrls
            )
        ),
            (Route<dynamic> route) => false
    );
  }

  static void getProfilePage(String userid,BuildContext context){
    GraphQLHandler.client2.mutate(
        MutationOptions(
            documentNode: gql(GraphQLHandler.getProfile),
            variables: {'userid': userid},
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
                MaterialPageRoute(
                    builder: (context) => ProfileExternalPage(
                        userId: userid,
                        name: resultData['getProfileUID']['info']['name'],
                        imageUrl: resultData['getProfileUID']['profilepic'],
                        pictureUrls: pics2,

                        totalViews: resultData['getProfileUID']['info']['stats']['totalviews'],
                        totalLikes: resultData['getProfileUID']['info']['stats']['totallikes']
                    ),
                ),
              );
            }
        )
    );
  }

  static void openListOfProfiles(BuildContext Context,dynamic entries){

  }

  static Widget ListWidget(int itemcount,name){

  }
}