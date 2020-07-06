import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'GraphQLHandler.dart';

class LogInPage extends StatefulWidget {
  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {

  FocusNode textFocusNode1 = new FocusNode();
  FocusNode textFocusNode2 = new FocusNode();

  @override
  void initState() {
    super.initState();
    textFocusNode1.addListener(() { setState(() {}); });
    textFocusNode2.addListener(() { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    return new GraphQLProvider(
        client: GraphQLHandler.getClient()/*ValueNotifier(
          GraphQLClient(
            cache: InMemoryCache(),
            link: api as Link,
          ),
        )*/,
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
                        obscureText: true,
                        focusNode: textFocusNode2,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: textFocusNode2.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 80,
                      thickness: 1,
                      indent: 50,
                      endIndent: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 120,
                          height: 60,
                          color: Colors.pink,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 120,
                          height: 60,
                          color: Colors.blue,
                        ),
                      ],
                    )
                  ],
                )
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            width: 200,
            height: 50,
            child: RaisedButton(
              elevation: 5,
              onPressed: () {
              },
              child: Text('LOG IN'),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            ),
          ),
        ]
      ),
      )
    );
  }
}