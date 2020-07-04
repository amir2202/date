import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {

  FocusNode textFocusNode1 = new FocusNode();
  FocusNode textFocusNode2 = new FocusNode();
  FocusNode textFocusNode3 = new FocusNode();

  String selectedGender = '';

  @override
  void initState() {
    super.initState();
    textFocusNode1.addListener(() { setState(() {}); });
    textFocusNode2.addListener(() { setState(() {}); });
    textFocusNode3.addListener(() { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {

    return Material(
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
            heightFactor: 0.6,
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
                          child: Material(
                            color: Colors.white,
                            child: TextFormField(
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
                        SizedBox(
                          width: 100,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'Gender',
                              contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 20)
                            ),
                            value: 'Male',
                            items: <String>[
                              'Male',
                              'Female',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value),);
                            }).toList(),
                            onChanged: (String gender) {
                              setState(() {
                                selectedGender = gender;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.white,
                      child: TextFormField(
                        focusNode: textFocusNode2,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: textFocusNode2.hasFocus ? Color(0xFFCA436B) : Colors.grey),
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
                          focusNode: textFocusNode3,
                          obscureText: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: textFocusNode3.hasFocus ? Color(0xFFCA436B) : Colors.grey),
                            contentPadding: EdgeInsets.all(20),
                          )
                      ),
                    ),
                  ],
                ),
              )
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
              child: Text('SIGN UP'),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                'By pressing "SIGN UP", you acknowledge that\n you have read and understand our Privacy Policy and our Terms of Service.',
                style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              )
            )
          )
        ],
      )
    );

  }

}