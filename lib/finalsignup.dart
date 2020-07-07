import 'package:date/common.dart';
import 'package:date/ethnicity_options.dart';
import 'package:date/eye_colors.dart';
import 'package:date/hair_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'GraphQLHandler.dart';

class Finalsignup extends StatefulWidget {
  @override
  FinalsignupState createState() => FinalsignupState();
}



class FinalsignupState extends State<Finalsignup>{
  String _selectedHairColor;
  String _selectedEyeColor;
  String _selectedEthnicity;
  String _selectedReligion;
  String _selectedCounty;

  FocusNode _bodyFocusNode = new FocusNode();
  FocusNode _heightFocusNode = new FocusNode();

  final _bodyController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bodyFocusNode.addListener(() { setState(() {}); });
    _heightFocusNode.addListener(() { setState(() {}); });
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
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: Common.screenWidth * 0.9,
                      height: Common.screenHeight * 0.54,
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
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                        labelText: 'Hair color',
                                        contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                                    ),
                                    value: null,
                                    items: HairColors.colors.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(value: value, child: Text(value),);
                                    }).toList(),
                                    onChanged: (String color) {
                                      setState(() {
                                        _selectedHairColor = color;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                        labelText: 'Eye color',
                                        contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                                    ),
                                    value: null,
                                    items: EyeColors.colors.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(value: value, child: Text(value),);
                                    }).toList(),
                                    onChanged: (String color) {
                                      setState(() {
                                        _selectedEyeColor = color;
                                      });
                                    },
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Material(
                                    color: Colors.white,
                                    child: TextFormField(
                                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                      controller: _bodyController,
                                      focusNode: _bodyFocusNode,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                        labelText: 'Body type',
                                        labelStyle: TextStyle(color: _bodyFocusNode.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                                        contentPadding: EdgeInsets.all(20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Material(
                                    color: Colors.white,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                                      controller: _heightController,
                                      focusNode: _heightFocusNode,
                                      decoration: InputDecoration(
                                        suffix: Text('cm', style: TextStyle(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                        labelText: 'Height',
                                        labelStyle: TextStyle(color: _heightFocusNode.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                                        contentPadding: EdgeInsets.all(20),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                  labelText: 'Ethnicity',
                                  contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                              ),
                              value: null,
                              items: EthnicityOptions.options.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value),);
                              }).toList(),
                              onChanged: (String option) {
                                setState(() {
                                  _selectedEthnicity = option;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                                  labelText: 'Religion',
                                  contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                              ),
                              value: null,
                              items: EthnicityOptions.options.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value),);
                              }).toList(),
                              onChanged: (String option) {
                                setState(() {
                                  _selectedReligion = option;
                                });
                              },
                            )
                          ],
                        )
                      )
                    )
                  )
                ],
              )
            ],
          ),
          resizeToAvoidBottomInset: false,
        ),
    );
  }
}