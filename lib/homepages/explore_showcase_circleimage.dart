import 'package:flutter/material.dart';
import 'package:dating/homepages/explore_showcase_indicator.dart';

import '../CommonLogic.dart';

class ShowcaseCircleImage extends StatelessWidget {

  final double diameter;
  final String pictureUrl;
  final Indicator indicator;
  final bool enabled;
  final String usertoretrieve;

  ShowcaseCircleImage({Key key, @required this.diameter, @required this.pictureUrl, this.indicator, this.enabled = true,@required this.usertoretrieve});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Container(
          width: this.diameter,
          height: this.diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(this.pictureUrl, fit: BoxFit.cover, color: !this.enabled ? Colors.grey : Colors.transparent, colorBlendMode: BlendMode.saturation),
        ),

        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(90)),
            splashColor: Colors.white.withOpacity(0.5),
            onTap: this.enabled ? () {
              CommonLogic.getProfilePage(this.usertoretrieve, context);
              print("test");
            } : null,
            child: Container(
              color: Colors.transparent,
              width: this.diameter,
              height: this.diameter,
            ),
          ),
        ),

        if (this.indicator != null)
          Positioned(
            bottom: 5,
            right: 0,
            child: indicator,
          )
      ],
    );
  }
}