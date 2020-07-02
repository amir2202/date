import 'package:flutter/material.dart';

void main() => runApp(new Dating());

class Dating extends StatelessWidget {
  Widget build(BuildContext context){
    Container background = new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: [const Color(0xFF915FB5), const Color(0xFFCA436B)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              stops:[0.0,1.0],
              tileMode: TileMode.clamp,
            )
        )
    );


    OutlineButton login = new OutlineButton(onPressed: () {},
        child: Text('LOG IN',style: TextStyle(color: Colors.white)),highlightedBorderColor: Colors.white, borderSide: BorderSide(color: Colors.white,width:1.0),);
    RaisedButton register = new RaisedButton(onPressed: () {},
        child: Text('SIGN UP'),color: Colors.white,);
    Column buttoncol = new Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[login,register]);

    //DropdownButton<String> languages = new DropdownButton<String>();

    return new MaterialApp(

        home: new Stack(
            alignment:Alignment.center,
            children: <Widget>[
          background,buttoncol
        ])
        );
  }

}

