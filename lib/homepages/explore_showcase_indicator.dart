import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final int iconMultiplier;

  final Color color;

  Indicator({Key key, this.icon, @required this.backgroundColor, this.text, this.iconMultiplier = 1}) :
    this.color = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: 55,
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          if (this.text != null)
            Text(this.text, style: TextStyle(color: this.color, fontSize: 14, fontWeight: FontWeight.bold)),

          if (this.icon != null)
            for (int i = 0; i < this.iconMultiplier; i++)
              Icon(this.icon, size: 14, color: this.color),

        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: this.backgroundColor,
      ),
    );
  }
}