

import 'package:dating/GraphQLHandler.dart';
import 'package:dating/common.dart';
import 'package:dating/finalsignup.dart';
import 'package:dating/login.dart';
import 'package:dating/preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating/signup.dart';
import 'package:dating/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CommonLogic.dart';
void main() {
  runApp(intro());
}



class intro extends StatefulWidget {
  @override
  _introState createState() => _introState();

}



class _introState extends State<intro>{

  Future<bool> loginsaved;
  bool complete=false;
  bool saved;
  int saveduser;

  //TODO use secure storage
  Future<bool> alreadyLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("LastLogin");
    print(prefs);
    if(userid != null && userid != 0){
      Common.userid = userid.toString();
      print("USERID");
      print(Common.userid);
      saveduser = userid;
      return true;
    }
    else{
      return false;
    }
  }
  @override
  void initState() {
    super.initState();
    loginsaved = alreadyLoggedIn();
    loginsaved.then((value){
      complete = true;
      saved = value;
    });
  }

  static final HttpLink api = HttpLink(
    uri: 'http://192.168.56.1:8090/graphql',
  );
  String dropdownValue = "English";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future:loginsaved,builder: (context,snapshot) {
      if(complete){
        if(saved){
          //this logic handled
          GraphQLHandler.client2.mutate(MutationOptions(documentNode: gql(GraphQLHandler.loginToken),variables:{"token":saveduser.toString()}))
              .then((value) {
                print(value.data);
                if(value.hasException){
                  return firstPage();
                }
                else{
                  List<dynamic> pics = value.data['loginToken']['pictures'];
                  List<String> pics2 = List<String>();
                  for (dynamic el in pics) {
                    pics2.add(el['filepath']);
                  }
                  CommonLogic.login(context,value.data['loginToken']['userid'].toString(),value.data['loginToken']['info']['name'],value.data['loginToken']['profilepic'],pics2,value.data['loginToken']['info']['stats']['totalviews'],value.data['loginToken']['info']['stats']['totallikes'],value.data['loginToken']['premium']);

                }

          });
          return CircularProgressIndicator();
        }
        else{
          return firstPage();
        }
      }
      else{
        return CircularProgressIndicator();
      }
    });


  }




  Widget firstPage(){
    return new MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF915FB5),
          accentColor: Color(0xFFCA436B),
          splashColor: Color(0xFFCA436B),
        ),
        routes:{
          'register': (context) => SignUpPage(),
          'login': (context) => LogInPage(),
          'signup': (context) => Finalsignup(),
          'preview': (context) => PreviewPage(),
          //   'home': (context) => HomePage(),
        },
        home: Builder(
            builder: (context) => Stack(
              alignment:Alignment.center,
              children: <Widget>[
                Container(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [const Color(0xFF915FB5), const Color(0xFFCA436B)],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight,
                          stops: [0.0,1.0],
                          tileMode: TileMode.clamp,
                        )
                    )
                ),
                Positioned(
                    bottom:130,
                    child: Column(
                      /*mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
       */
                      children: <Widget>[
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: OutlineButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: Text(
                                'LOG IN',
                                style: TextStyle(color: Colors.white)
                            ),
                            highlightedBorderColor: Colors.white,
                            borderSide: BorderSide(color: Colors.white,width:1.0),
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          ),
                        ),
                        new SizedBox(
                          width: 0,
                          height: 10,
                          child: null,
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Text('SIGN UP'),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          ),
                        ),
                      ],
                    )
                ), Positioned(
                    top:50,
                    right:30,
                    child: Material(
                        child: Container(
                          decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                colors: [const Color.fromRGBO(159, 89, 162, 1.0), const Color.fromRGBO(159, 89, 162, 1.0)],
                                begin: FractionalOffset.topRight,
                                end: FractionalOffset.bottomRight,
                                stops: [0.0,1.0],
                                tileMode: TileMode.clamp,
                              )
                          ),
                          /*child: DropdownButton(
                        underline: SizedBox(),
                        dropdownColor: Color.fromRGBO(159, 89, 162, 1.0),
                        value: dropdownValue,
                        items: <String>['English', 'Deutsch']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style: TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        }
                    )*/
                        )
                    )
                )
              ],
            )
        )
    );
  }
}
