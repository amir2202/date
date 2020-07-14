import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'GraphQLHandler.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'home.dart';

class LogInPage extends StatefulWidget {
  bool isLoggedIn = false;
  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  bool isLoggedIn = false;
  FocusNode textFocusNode1 = new FocusNode();
  FocusNode textFocusNode2 = new FocusNode();

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textFocusNode1.addListener(() { setState(() {}); });
    textFocusNode2.addListener(() { setState(() {}); });
  }

  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _loginWithFB() async{


    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {

      //IF ALREADY AN ASSOSCIATION IT will continue to page
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,gender,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        //IF TOKEN ASSOSCIATED WITH AN ACCOUNT GO TO PROFILE PAGE^^ WITH USERID
        //UNTIL FACEBOOK grants permission default user is male currently
        GraphQLClient client = new GraphQLClient(link:HttpLink(uri:'http://192.168.0.14:8090/graphql'), cache: InMemoryCache());
        client.mutate(MutationOptions(documentNode: gql(GraphQLHandler.facebookLinked),variables: {'fbid':profile['id'].toString()},onCompleted: (dynamic result){
          print(result);
          if(result['FacebookLinked'] == null){
           //DO FACEBOOK stuff here

            client.mutate(MutationOptions(documentNode: gql(GraphQLHandler.addFacebookUser),variables: {'name':profile['name'],'premium':false,'gender':true,'profile':profile['picture']['data']['url'],'fbid':profile['id']},onCompleted: (dynamic result2){
              print("SECOND RESULT");
              //GO TO NEXT PAGE
              //TODO GO TO second
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(name: result2['addFacebook']['info']['name'],totallikes: 0,totalviews: 0,imageUrl: profile['picture']['data']['url'],pictureUrls: [profile['picture']['data']['url']])), (r) => false);
              print(result2);
            }));

          }
          else{
            List<dynamic> pics = result['FacebookLinked']['pictures'];
            List<String> pics2 = List<String>();
            for(dynamic el in pics){
              pics2.add(el['filepath']);
            }
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(name: result['FacebookLinked']['info']['name'],totallikes: result['FacebookLinked']['info']['stats']['totallikes'],totalviews: result['FacebookLinked']['info']['stats']['totalviews'],imageUrl: result['FacebookLinked']['profilepic'],pictureUrls:pics2)), (r) => false);
          }
        }));
        //ELSE COMPLETE REGISTRATION

        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false );
        break;
    }

  }

  _logout(){
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new GraphQLProvider(
        client: GraphQLHandler.getClient(),
      child: Material(
      child: Stack(
        alignment:Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [Color(0xFF915FB5), Color(0xFFCA436B)],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.5,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.white,
                      child: TextFormField(
                        controller:_emailController,
                        focusNode: textFocusNode1,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: textFocusNode1.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.white,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        focusNode: textFocusNode2,
                        decoration: InputDecoration(
                        suffix: GestureDetector(
                        onTap: () {
                        print('tapped');
                        },
                        child: Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 12,
                        color: Color(0xFFCA436B),fontWeight: FontWeight.bold),
                        ),
                        ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: textFocusNode2.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                      height: 20,
                      thickness: 1,
                      indent: 50,
                      endIndent: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SignInButton(
                          Buttons.Facebook,
                          text: "Sign in with Facebook",
                          onPressed: () {
                            _loginWithFB();
                          },
                        ),
                      ],
                    )
                  ],
                )
              ),
            ),
          ),Positioned (
            bottom: 80,
            width: 200,
            height: 50,
            child: Mutation(options: MutationOptions(documentNode: gql(GraphQLHandler.loginUser),onCompleted:(dynamic resultData){
              print(resultData);
              print(resultData['loginManual']['info']['name']);
              if(resultData['loginManual']['userid'] == "LOGIN FAILED"){
                print("login failed");

              }
              else{
                List<dynamic> pics = resultData['loginManual']['pictures'];
                List<String> pics2 = List<String>();
                for(dynamic el in pics){
                  pics2.add(el['filepath']);
                  print(el['filepath']);
                }
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(name:resultData['loginManual']['info']['name'],imageUrl:resultData['loginManual']['profilepic'], pictureUrls:pics2,totalviews: resultData['loginManual']['info']['stats']['totalviews'],totallikes: resultData['loginManual']['info']['stats']['totallikes']),
              ));}
            }),builder: (RunMutation runMutation,QueryResult result){
              return RaisedButton(
                elevation: 5,
                onPressed: () {
                  runMutation({'email':_emailController.text,'password':_passwordController.text});
                  ///RETRIEVE INFO TO PASS ON
                },
                child: Text('LOG IN'),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              );
            })
          ),
        ]
      ),
      )
    );
  }
}