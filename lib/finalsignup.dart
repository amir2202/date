import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'GraphQLHandler.dart';

class Finalsignup extends StatefulWidget {
  @override
  FinalsignupState createState() => FinalsignupState();
}



class FinalsignupState extends State<Finalsignup>{


  FocusNode textFocusNode1 = new FocusNode();
  FocusNode textFocusNode2 = new FocusNode();
  FocusNode textFocusNode3 = new FocusNode();
  FocusNode textFocusNode4 = new FocusNode();
  final nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    textFocusNode1.addListener(() { setState(() {}); });
    textFocusNode2.addListener(() { setState(() {}); });
    textFocusNode3.addListener(() { setState(() {}); });
    textFocusNode4.addListener(() { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLHandler.client,
        child: Scaffold(
          body: Stack(
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
              ),Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 350,
                    height: 450,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child:
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Material(
                                        color: Colors.white,
                                        child: TextFormField(
                                          controller: nameController,
                                          focusNode: textFocusNode1,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                            labelText: 'Full name',
                                            labelStyle: TextStyle(color: textFocusNode1.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                                            contentPadding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),

                                  ],
                                )
                              ],
                            )
                        )
                    )

                  )
                ],
              )
            ],
          )
    ),
    );
  }

}