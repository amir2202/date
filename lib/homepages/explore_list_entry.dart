
import 'package:dating/homepages/explore_showcase_indicator.dart';
import 'package:flutter/material.dart';

class ExploreListEntry extends StatefulWidget {
  final int listIndex;
  final ValueNotifier<double> offsetNotifier;
  final ScrollController parentScrollController;

  final String name;
  final String pictureUrl;

  ExploreListEntry({Key key, @required this.listIndex, @required this.offsetNotifier, @required this.parentScrollController, @required this.name, @required this.pictureUrl});
  @override
  ExploreListEntryState createState() => ExploreListEntryState();
}

class ExploreListEntryState extends State<ExploreListEntry> {

  double _parallax = 0.0;

  void _onParentScroll() {
    if (widget.parentScrollController.position.pixels.toInt() % 4 == 0) {
      double globalPosition = widget.offsetNotifier.value + (widget.listIndex * 200) + 200;
      double offset = globalPosition - widget.parentScrollController.position.pixels - MediaQuery.of(context).size.height / 2;
      offset = offset * 40 / MediaQuery.of(context).size.height;

      setState(() {
        _parallax = -offset;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    widget.parentScrollController.addListener(_onParentScroll);
    widget.offsetNotifier.addListener(_onParentScroll);
  }

  @override
  void dispose() {
    super.dispose();

    widget.parentScrollController.removeListener(_onParentScroll);
    widget.offsetNotifier.removeListener(_onParentScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(45)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: _parallax - 20,
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 240,
                child: Image.network(widget.pictureUrl, fit: BoxFit.cover, color: Colors.black.withOpacity(0.25), colorBlendMode: BlendMode.srcATop,),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 30,
              child: Row(
                children: <Widget>[
                  Indicator(
                    icon: Icons.favorite,
                    backgroundColor: Color(0xFFCA436B),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Indicator(
                    icon: Icons.favorite,
                    backgroundColor: Colors.green,
                    text: '320',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Indicator(
                    icon: Icons.remove_red_eye,
                    backgroundColor: Colors.white,
                    text: '1.7K',
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 45,
              left: 30,
              child: Text(widget.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),),
            )
          ],
        ),
      ),
    );
  }
}