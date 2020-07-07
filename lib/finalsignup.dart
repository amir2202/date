import 'package:date/country_suggetions.dart';
import 'package:date/eye_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'GraphQLHandler.dart';

class Finalsignup extends StatefulWidget {
  @override
  FinalsignupState createState() => FinalsignupState();
}



class FinalsignupState extends State<Finalsignup>{
  String selectedEyeColor;
  String selectedCounty;

  final TextEditingController _typeAheadController = TextEditingController();

  FocusNode textFocusNode1 = new FocusNode();
  FocusNode textFocusNode2 = new FocusNode();
  FocusNode textFocusNode3 = new FocusNode();
  FocusNode textFocusNode4 = new FocusNode();
  FocusNode textFocusNode5 = new FocusNode();

  final haircontroll = TextEditingController();
  final eyecontroll = TextEditingController();
  final bodycontroll = TextEditingController();
  final heightcontroll = TextEditingController();
  final ethnicitycontroll = TextEditingController();
  final religioncontroll = TextEditingController();

  @override
  void initState() {
    super.initState();
    textFocusNode1.addListener(() { setState(() {}); });
    textFocusNode2.addListener(() { setState(() {}); });
    textFocusNode3.addListener(() { setState(() {}); });
    textFocusNode4.addListener(() { setState(() {}); });
    textFocusNode5.addListener(() { setState(() {}); });
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
                                          controller: haircontroll,
                                          focusNode: textFocusNode1,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                            labelText: 'Hair Color',
                                            labelStyle: TextStyle(color: textFocusNode1.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                                            contentPadding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                            labelText: 'Eye Color',
                                            contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 20)
                                        ),
                                        value: 'Blue',
                                        items: EyeColors.colors.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(value: value, child: Text(value),);
                                        }).toList(),
                                        onChanged: (String color) {
                                          setState(() {
                                            print("cHANGING selectedEyeColor");
                                            selectedEyeColor = color;
                                            print(selectedEyeColor);
                                          });
                                        },
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Material(
                                        color: Colors.white,
                                        child: TextFormField(
                                          controller: bodycontroll,
                                          focusNode: textFocusNode2,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                            labelText: 'Body type',
                                            labelStyle: TextStyle(color: textFocusNode2.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                                            contentPadding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Material(
                                        color: Colors.white,
                                        child: TextFormField(
                                          controller: heightcontroll,
                                          focusNode: textFocusNode3,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                            labelText: 'Height',
                                            labelStyle: TextStyle(color: textFocusNode3.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                                            contentPadding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                    )
                                    //insert here

                                  ],
                                ),SizedBox(
                                  height: 10,
                                ),
                                Material(
                                  color: Colors.white,
                                  child: TextFormField(
                                      controller: ethnicitycontroll,
                                      focusNode: textFocusNode5,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                        labelText: 'Ethnicity',
                                        labelStyle: TextStyle(color: textFocusNode5.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                                        contentPadding: EdgeInsets.all(20),
                                      )
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Material(
                                  color: Colors.white,
                                  child: TextFormField(
                                      controller: religioncontroll,
                                      focusNode: textFocusNode4,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                        labelText: 'Religion',
                                        labelStyle: TextStyle(color: textFocusNode4.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                                        contentPadding: EdgeInsets.all(20),
                                      )
                                  ),
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