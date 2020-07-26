import 'package:dating/suggestions/Bundesland_suggestions.dart';
import 'package:dating/common.dart';
import 'package:dating/preview.dart';
import 'package:dating/suggestions/ethnicity_options.dart';
import 'package:dating/suggestions/eye_colors.dart';
import 'package:dating/suggestions/hair_colors.dart';
import 'dart:convert';
import 'package:dating/suggestions/religion_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'GraphQLHandler.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({this.page})
      : super(
    pageBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,) =>
    page,
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}

class Finalsignup extends StatefulWidget {
  @override
  FinalsignupState createState() => FinalsignupState();
}

class FinalsignupState extends State<Finalsignup>{
  String _selectedHairColor = '';
  String _selectedEyeColor = '';
  String _selectedEthnicity = '';
  String _selectedReligion = '';
  String _selectedCounty = '';

  FocusNode _bodyFocusNode = new FocusNode();
  FocusNode _heightFocusNode = new FocusNode();

  final _bodyController = TextEditingController();
  final _heightController = TextEditingController();

  static final _defaultEnabledBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey));
  static final _defaultFocusedBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B)));
  static final _errorBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.red));

  OutlineInputBorder _hairEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _hairFocusedBorder = _defaultFocusedBorder;
  bool _hairCorrect = true;
  OutlineInputBorder _eyeEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _eyeFocusedBorder = _defaultFocusedBorder;
  bool _eyeCorrect = true;
  OutlineInputBorder _bodyEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _bodyFocusedBorder = _defaultFocusedBorder;
  bool _bodyCorrect = true;
  OutlineInputBorder _heightEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _heightFocusedBorder = _defaultFocusedBorder;
  bool _heightCorrect = true;
  OutlineInputBorder _ethnicityEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _ethnicityFocusedBorder = _defaultFocusedBorder;
  bool _ethnicityCorrect = true;
  OutlineInputBorder _religionEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _religionFocusedBorder = _defaultFocusedBorder;
  bool _religionCorrect = true;
  OutlineInputBorder _countyEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _countyFocusedBorder = _defaultFocusedBorder;
  bool _countyCorrect = true;

  @override
  void initState() {
    super.initState();
    _bodyFocusNode.addListener(() { setState(() {}); });
    _heightFocusNode.addListener(() { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      //height: Common.screenHeight * 0.56,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                        enabledBorder: _hairEnabledBorder,
                                        focusedBorder: _hairFocusedBorder,
                                        labelText: 'Hair color',
                                        labelStyle: TextStyle(color: _hairCorrect ? Colors.grey : Colors.red),
                                        contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                                    ),
                                    value: null,
                                    items: HairColors.colors.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(value: value, child: Text(value),);
                                    }).toList(),
                                    onChanged: (String color) {
                                      setState(() {
                                        _hairEnabledBorder = _defaultEnabledBorder;
                                        _hairFocusedBorder = _defaultFocusedBorder;
                                        _hairCorrect = true;
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
                                        enabledBorder: _eyeEnabledBorder,
                                        focusedBorder: _eyeFocusedBorder,
                                        labelText: 'Eye color',
                                        labelStyle: TextStyle(color: _eyeCorrect ? Colors.grey : Colors.red),
                                        contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                                    ),
                                    value: null,
                                    items: EyeColors.colors.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(value: value, child: Text(value),);
                                    }).toList(),
                                    onChanged: (String color) {
                                      setState(() {
                                        _eyeEnabledBorder = _defaultEnabledBorder;
                                        _eyeFocusedBorder = _defaultFocusedBorder;
                                        _eyeCorrect = true;
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
                                      onChanged: (value) {
                                        setState(() {
                                          _bodyEnabledBorder = _defaultEnabledBorder;
                                          _bodyFocusedBorder = _defaultFocusedBorder;
                                          _bodyCorrect = true;
                                        });
                                      },
                                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                      controller: _bodyController,
                                      focusNode: _bodyFocusNode,
                                      decoration: InputDecoration(
                                        enabledBorder: _bodyEnabledBorder,
                                        focusedBorder: _bodyFocusedBorder,
                                        labelText: 'Body type',
                                        labelStyle: _bodyCorrect ? TextStyle(color: _bodyFocusNode.hasFocus ? Color(0xFFCA436B) : Colors.grey) : TextStyle(color: Colors.red),
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
                                      onChanged: (value) {
                                        setState(() {
                                          _heightEnabledBorder = _defaultEnabledBorder;
                                          _heightFocusedBorder = _defaultFocusedBorder;
                                          _heightCorrect = true;
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                                      controller: _heightController,
                                      focusNode: _heightFocusNode,
                                      decoration: InputDecoration(
                                        suffix: Text('cm', style: TextStyle(color: Colors.grey)),
                                        enabledBorder: _heightEnabledBorder,
                                        focusedBorder: _heightFocusedBorder,
                                        labelText: 'Height',
                                        labelStyle: _heightCorrect ? TextStyle(color: _heightFocusNode.hasFocus ? Color(0xFFCA436B) : Colors.grey) : TextStyle(color: Colors.red),
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
                                  enabledBorder: _ethnicityEnabledBorder,
                                  focusedBorder: _ethnicityFocusedBorder,
                                  labelText: 'Ethnicity',
                                  labelStyle: TextStyle(color: _ethnicityCorrect ? Colors.grey : Colors.red),
                                  contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                              ),
                              value: null,
                              items: EthnicityOptions.options.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value),);
                              }).toList(),
                              onChanged: (String option) {
                                setState(() {
                                  _ethnicityEnabledBorder = _defaultEnabledBorder;
                                  _ethnicityFocusedBorder = _defaultFocusedBorder;
                                  _ethnicityCorrect = true;
                                  _selectedEthnicity = option;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  enabledBorder: _religionEnabledBorder,
                                  focusedBorder: _religionFocusedBorder,
                                  labelText: 'Religion',
                                  labelStyle: TextStyle(color: _religionCorrect ? Colors.grey : Colors.red),
                                  contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                              ),
                              value: null,
                              items: ReligionOptions.options.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value),);
                              }).toList(),
                              onChanged: (String option) {
                                setState(() {
                                  _religionEnabledBorder = _defaultEnabledBorder;
                                  _religionFocusedBorder = _defaultFocusedBorder;
                                  _religionCorrect = true;
                                  _selectedReligion = option;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  enabledBorder: _countyEnabledBorder,
                                  focusedBorder: _countyFocusedBorder,
                                  labelText: 'County',
                                  labelStyle: TextStyle(color: _countyCorrect ? Colors.grey : Colors.red),
                                  contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                              ),
                              value: null,
                              items: BundeslandOptions.options.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value),);
                              }).toList(),
                              onChanged: (String option) {
                                setState(() {
                                  _countyEnabledBorder = _defaultEnabledBorder;
                                  _countyFocusedBorder = _defaultFocusedBorder;
                                  _countyCorrect = true;
                                  _selectedCounty = option;
                                });
                              },
                            )
                          ],
                        )
                      )
                    )
                  ),
                  SizedBox(
                    height: Common.screenHeight * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            Common.haircolor = _selectedHairColor;
                            Common.eyecolor = _selectedEyeColor;
                            Common.body = _bodyController.text;
                            Common.height = _heightController.text.isEmpty ? 0 : int.parse(_heightController.text);
                            Common.ethnicity = _selectedEthnicity;
                            Common.religion = _selectedReligion;
                            Common.state = _selectedCounty;
                            Navigator.push(context, FadeRoute(page: PreviewPage()));
                          },
                          elevation: 5,
                          child: Text('NEXT'),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: OutlineButton(
                          onPressed: () {
                            Common.haircolor = '';
                            Common.eyecolor = '';
                            Common.body = '';
                            Common.height = 0;
                            Common.ethnicity = '';
                            Common.religion = '';
                            Common.state = '';
                            Navigator.push(context, FadeRoute(page: PreviewPage()));
                          },
                          child: Text('SKIP', style: TextStyle(color: Colors.white)),
                          highlightedBorderColor: Colors.white,
                          borderSide: BorderSide(color: Colors.white,width:1.0),
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        )
                      ),
                    ]
                  )
                ],
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
    );
  }
}