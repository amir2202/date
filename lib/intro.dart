

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating/signup.dart';
void main() {
  runApp(intro());
}



class intro extends StatefulWidget {
  @override
  _introState createState() => _introState();

}



class _introState extends State<intro>{

  String dropdownValue = "English";
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        routes:{
          'register': (context) => SignUpPage(),
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
