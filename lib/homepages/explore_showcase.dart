import 'package:flutter/material.dart';
import 'package:dating/homepages/explore_showcase_circleimage.dart';
import 'package:dating/homepages/explore_showcase_indicator.dart';

class ShowcaseEntry {
  final String userId;
  final String pictureUrl;
  final String text;
  final bool enabled;

  ShowcaseEntry({@required this.userId, @required this.pictureUrl, this.text, this.enabled = true});
}

class Showcase extends StatefulWidget {
  final double height;
  final List<ShowcaseEntry> entries;

  final double spacing;
  final bool enabled;

  Showcase({Key key, @required this.height, @required this.entries, this.spacing = 10.0, this.enabled = true});

  @override
  ShowcaseState createState() => ShowcaseState();
}

class ShowcaseState extends State<Showcase> {

  List<ShowcaseCircleImage> _children;

  ScrollController _scrollController;

  bool _hideArrow = false;

  @override
  void initState() {
    super.initState();

    _children = List<ShowcaseCircleImage>();
    for (ShowcaseEntry entry in widget.entries) {
      _children.add(
        ShowcaseCircleImage(
          diameter: widget.height,
          pictureUrl: entry.pictureUrl,
          indicator: Indicator(icon: Icons.favorite, backgroundColor: !entry.enabled || !widget.enabled ? Colors.grey : Colors.green, text: entry.text),
          enabled: widget.enabled && entry.enabled,
        )
      );
    }

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      setState(() {
        _hideArrow = _scrollController.position.pixels != 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Stack(
        children: <Widget>[

          ListView.separated(
            controller: _scrollController,
            itemCount: _children.length,
            itemBuilder: (context, index) {
              return _children[index];
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: widget.spacing,
              );
            },
            scrollDirection: Axis.horizontal,
            physics: widget.enabled ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          ),

          if (false)
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              top: widget.height / 2 - (15 + 7.5),
              right: _hideArrow ? -100 : widget.height / 5,
              child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(7.5),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 30,
                  ),
                ),
                shape: CircleBorder(),
              ),
            )
        ],
      ),
    );
  }
}