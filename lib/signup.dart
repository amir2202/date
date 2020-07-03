import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Container backgroundGradient = new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [const Color(0xFF915FB5), const Color(0xFFCA436B)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            )
        )
    );

    TextFormField fullNameTextFormField = new TextFormField(
      decoration: InputDecoration(
        labelText: 'Full name',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );

    Material fullNameTextMaterial = new Material(
      child: fullNameTextFormField,
      color: Colors.transparent,
    );

    Container fullNameTextContainer = new Container(
      child: fullNameTextMaterial,
      width: 200,
    );

    Column formColumn = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        fullNameTextContainer,
      ],
    );

    return MaterialApp(
      home: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          backgroundGradient,
          formColumn,
        ],
      ),
    );

  }

}