import 'package:dating/homepages/ChatPage.dart';
import 'package:dating/homepages/profile_info.dart';
import 'package:dating/homepages/profile_info_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:dating/homepages/profile.dart';
import 'package:dating/common.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends StatefulWidget {

  final String name;
  final String imageUrl;
  final List<String> pictureUrls;
  final int totalViews;
  final int totalLikes;
  HomePage({Key key, @required this.name, @required this.imageUrl, @required this.pictureUrls, @required this.totalViews, @required this.totalLikes,});

  @override
  HomePageState createState() => HomePageState();
}




class HomePageState extends State<HomePage> {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void getProfilePicture() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    setState(() { Common.profilePicture = File('$path/pfp.jpg'); });
  }

  List<Widget> _pages;

  int _index = 4;
  int _ownership = -1;

  ValueNotifier<double> _n3;
  ValueNotifier<double> _n4;

  tabCallback(index, option) {
    setState(() {
      _index = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  disownCallback(index) {
    setState(() {
      _ownership = index;
    });
  }

  c2Callback(value) {
    setState(() {
      _c2Opacity = value;
    });
  }

  c3HeightSavedCallback() {
    setState(() {
      _c3HeightSaved = _c3Height;
    });
  }

  void _onScroll() {
    setState(() {
      _ownership = -1;
    });
  }

  double _cHeight = 0;
  double _c3Height = 0;
  double _c3HeightSaved = 0;

  double _containerHeight() {
    if (Common.screenHeight == null || !_pageController.hasClients) {
      return 0;
    } else if (_ownership == -1) {
      double t = _pageController.hasClients ? _cHeight - (4 - _pageController.page) * (_cHeight - _c3Height) : 0;
      return t > _c3Height ? t : _c3Height;
    } else if (_ownership == 4) {
      _cHeight = _n4.value;
    } else if (_ownership == 3) {
      _c3Height = _n3.value;
      return _c3Height;
    }

    return _cHeight;
  }

  PageController _pageController;

  bool _c2Opacity = false;

  void _onBuildCompleted(Duration duration) {
    if (Common.screenWidth == null || Common.screenHeight == null) {
      Common.screenWidth = MediaQuery.of(context).size.width;
      Common.screenHeight = MediaQuery.of(context).size.height;
    }

    setState(() {
      _cHeight = Common.screenHeight * 0.2;
      _c3Height = Common.screenHeight * 0.12;
    });
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _index);
    _pageController.addListener(_onScroll);
    _n3 = ValueNotifier<double>(0);
    _n4 = ValueNotifier<double>(0);

    WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
  }

  @override
  Widget build(BuildContext context) {

    if (Common.screenWidth == null || Common.screenHeight == null) {
      Common.screenWidth = MediaQuery.of(context).size.width;
      Common.screenHeight = MediaQuery.of(context).size.height;
    }

    if (Common.profilePicture == null) {
      getProfilePicture();
    }

    _pages = <Widget>[
      Text('a'),

      Text('a'),

      ChatPage(),

//      ProfileInfoPage(
//        disownCallback: disownCallback,
//        notifier: _n3
//      ),

      ProfileInfoWrapper(
        disownCallback: disownCallback,
        c2Callback: c2Callback,
        c3HeightSavedCallback: c3HeightSavedCallback,
        notifier: _n3,
        navigatorKey: _navigatorKey,
      ),

      ProfilePage(
        tabCallback: tabCallback,
        disownCallback: disownCallback,
        c2Callback: c2Callback,
        notifier: _n4,
        myProfile: true,
        name: widget.name,
        imageUrl: widget.imageUrl,
        pictureUrls: widget.pictureUrls,
        totalViews: widget.totalViews,
        totalLikes: widget.totalLikes
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _c2Opacity = false;
          _n3.value = _c3HeightSaved;
        });

        if (_index == 3)
          return !await _navigatorKey.currentState.maybePop();
        else
          return true;
      },
      child: Scaffold(
        body: Stack(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: _containerHeight(),
                  color: Color(0xFFCA436B),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ]
            ),

            Positioned(
              top: 0,
              left: 0,
              child: Opacity(
                opacity: _c2Opacity ? 1.0 : 0.0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                  height: _c2Opacity ? Common.screenHeight * 0.2 : _c3HeightSaved,
                  width: Common.screenWidth,
                  color: Color(0xFFCA436B),
                ),
              ),
            ),

            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _index = index);
              },
              children: _pages,
            ),

          ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              title: Text('Explore'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              title: Text('Stories'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Messages'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Views'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
          selectedItemColor: Color(0xFFCA436B),
          unselectedItemColor: Colors.grey,
          currentIndex: _index,
          onTap: (index) {
            tabCallback(index, 0);
          },
        ),
      ),
    );
  }
}