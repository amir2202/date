import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(new intro());
class intro extends StatefulWidget {

  @override
  _introState createState() => _introState();

}

class _introState extends State<intro>{
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


    OutlineButton loginButton = new OutlineButton(
      onPressed: () {},
      child: Text(
          'LOG IN',
          style: TextStyle(color: Colors.white)
      ),
      highlightedBorderColor: Colors.white,
      borderSide: BorderSide(color: Colors.white,width:1.0),
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    );

    RaisedButton signupButton = new RaisedButton(
      onPressed: () {},
      child: Text('SIGN UP'),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    );

    SizedBox loginSizedBox = new SizedBox(
      width: 200,
      height: 50,
      child: loginButton,
    );

    SizedBox signupSizedBox = new SizedBox(
      width: 200,
      height: 50,
      child: signupButton,
    );

    Column buttonColumn = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        loginSizedBox,
        new SizedBox(
          width: 0,
          height: 10,
          child: null,
        ),
        signupSizedBox,
      ],
    );

    //DropdownButton<String> languages = new DropdownButton<String>();

    return new MaterialApp(
        home: new Stack(
          alignment:Alignment.center,
          children: <Widget>[
            backgroundGradient,
            buttonColumn, /*Material(
              child: DropdownButton(items: null, onChanged: null)
            )*/
          ],
        )
    );

  }

}

