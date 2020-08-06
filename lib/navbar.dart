import 'package:flutter/material.dart';

class NavBarEntry {

  final IconData icon;
  final String text;
  final Color color;

  NavBarEntry({@required this.icon, @required this.text, @required this.color});
}

class NavBarItem extends StatefulWidget {

  final ValueNotifier<int> oldIndexNotifier;
  final ValueNotifier<int> newIndexNotifier;
  final Animation<double> animation;
  final Function(int) onTap;
  final int index;
  final IconData icon;
  final String text;
  final Color color;

  NavBarItem({
    Key key,
    @required this.oldIndexNotifier,
    @required this.newIndexNotifier,
    @required this.animation,
    @required this.onTap,
    @required this.index,
    @required this.icon,
    @required this.text,
    @required this.color,
  });

  @override
  NavBarItemState createState() => NavBarItemState();
}

class NavBarItemState extends State<NavBarItem> {

  bool _selected = true;
  double _width = 125.0;
  double _opacity = 0.25;
  double _iconOpacity = 1.00;
  double _textOpacity = 1.00;
  double _leftPadding = 20.0;

  void _onAnimation() {

    if (widget.oldIndexNotifier.value == widget.index || widget.newIndexNotifier.value == widget.index) {

      double direction = -1.0;

      bool selected = false;
      double width = 125.0;
      double opacity = 0.25;
      double iconOpacity = 1.00;
      double textOpacity = 1.00;
      double leftPadding = 20.0;

      if (widget.newIndexNotifier.value == widget.index) {
        selected = true;
        direction = 1.0;
        width = 50.0;
        opacity = 0.0;
        iconOpacity = 0.0;
        textOpacity = 0.0;
        leftPadding = 12.5;
      }

      setState(() {
        _selected = selected;
        _width = width + direction * (widget.animation.value * 75.0);
        _opacity = opacity + direction * (widget.animation.value * 0.25);
        _iconOpacity = iconOpacity + direction * (widget.animation.value);

        _textOpacity = textOpacity + direction * (widget.animation.value * 4.0 - (selected ? 3.0 : 0.0));
        if (_textOpacity < 0.0) _textOpacity = 0.0;
        if (_textOpacity > 1.0) _textOpacity = 1.0;

        _leftPadding = leftPadding + direction * (widget.animation.value * 7.5);
      });
    }

  }

  @override
  void initState() {
    super.initState();

    if (widget.oldIndexNotifier.value != widget.index) {
      _selected = false;
      _width = 50.0;
      _opacity = 0.0;
      _iconOpacity = 0.0;
      _textOpacity = 0.0;
      _leftPadding = 12.5;
    }

    widget.animation.addListener(_onAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      clipBehavior: Clip.antiAlias,
      color: widget.color.withOpacity(_opacity),
      child: InkWell(
        highlightColor: _selected
            ? widget.color.withOpacity(0.25)
            : Colors.black.withOpacity(0.1),
        splashColor: _selected
            ? widget.color.withOpacity(0.5)
            : Colors.black.withOpacity(0.25),
        onTap: () {
          print(widget.index);
          widget.onTap(widget.index);
        },
        child: Container(
          width: _width,
          height: 50,
          padding: EdgeInsets.only(left: _leftPadding, right: 25),
          child: Stack(
            overflow: Overflow.clip,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: <Widget>[
                    Icon(
                      widget.icon,
                      size: 25,
                    ),
                    Icon(
                      widget.icon,
                      color: widget.color.withOpacity(_iconOpacity),
                      size: 25,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.color.withOpacity(_textOpacity),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          clipBehavior: Clip.antiAlias,
        ),
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  final Function(int) onTap;
  final List<NavBarEntry> entries;
  NavBar({Key key, @required this.onTap, @required this.entries});

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {

  int _index = 0;
  List<NavBarItem> _children;

  ValueNotifier<int> _oldIndexNotifier;
  ValueNotifier<int> _newIndexNotifier;

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _oldIndexNotifier = ValueNotifier<int>(0);
    _newIndexNotifier = ValueNotifier<int>(0);

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)).animate(_animationController)..addListener(() { setState(() {}); });

    _children = List<NavBarItem>();
    for (int i = 0; i < widget.entries.length; i++) {
      _children.add(
          NavBarItem(
            oldIndexNotifier: _oldIndexNotifier,
            newIndexNotifier: _newIndexNotifier,
            animation: _animation,
            onTap: (index) { _onTap(index); },
            index: i,
            icon: widget.entries[i].icon,
            text: widget.entries[i].text,
            color: widget.entries[i].color,
          )
      );
    }
  }

  _onTap(int index) {
    if (index != _index) {
      print(index);
      _oldIndexNotifier.value = _index;
      _newIndexNotifier.value = index;

      _animationController.forward(from: 0);
      _index = index;

      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10,
      color: Colors.white,
      child: Container(
        height: 65,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _children,
        ),
      ),
    );
  }
}