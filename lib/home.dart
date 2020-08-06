import 'package:dating/homepages/ChatPage.dart';
import 'package:dating/homepages/explore.dart';
import 'package:dating/homepages/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:dating/homepages/profile.dart';
import 'package:dating/common.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePageIndices {
  static const int explore = 0;
  static const int stories = 1;
  static const int chat = 2;
  static const int info = 3;
  static const int profile = 4;
}

class HomePage extends StatefulWidget {

  final String userId;
  final String name;
  final String imageUrl;
  final List<String> pictureUrls;

  final int totalViews;
  final int totalLikes;

  HomePage({Key key,
    @required this.userId,
    @required this.name,
    @required this.imageUrl,
    @required this.pictureUrls,

    @required this.totalViews,
    @required this.totalLikes,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  void getProfilePicture() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    setState(() { Common.profilePicture = File('$path/pfp.jpg'); });
  }

  List<Widget> _pages;

  int _index = HomePageIndices.profile;
  int _ownership = -1;

  ValueNotifier<double> _n3;
  ValueNotifier<double> _n4;

  ValueNotifier<double> _forwardNotifier3;
  ValueNotifier<bool> _forceForward3;

  double _c4Height = 150.0;
  double _c3Height = 100.0;
  double _containerHeight = 150.0;

  tabCallback(index, option) {
    setState(() {

      if (index == HomePageIndices.info) {
        _infoTabController.animateTo(option,
            duration: Duration(milliseconds: 0), curve: Curves.ease);
      }

      if ((index - _index).abs() == 1) {
        _pageController.animateToPage(index,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      } else {
        _pageController.jumpToPage(index);
      }

      _index = index;

    });
  }

  disownCallback(index) {
    setState(() {
      _ownership = index;

      if (index == HomePageIndices.profile) {
        _c4Height = _n4.value;
        _containerHeight = _c4Height;
      } else if (_ownership == HomePageIndices.info) {
        _c3Height = _n3.value;
        _containerHeight = _c3Height;
      }

    });
  }

//  double _containerHeight() {
//    if (Common.screenHeight == null || !_pageController.hasClients) {
//      return 0;
//    } else if (_ownership == -1) {
//      double t = _pageController.hasClients ? _cHeight - (4 - _pageController.page) * (_cHeight - _c3Height) : 0;
//      _forwardNotifier3.value = t > _c3Height ? t : _c3Height;
//      return t > _c3Height ? t : _c3Height;
//    } else if (_ownership == HomePageIndices.profile) {
//      _cHeight = _n4.value;
//    } else if (_ownership == HomePageIndices.info) {
//      _c3Height = _n3.value;
//      return _c3Height;
//    }
//
//    return _cHeight;
//  }

  PageController _pageController;
  TabController _infoTabController;

  void _onBuildCompleted(Duration duration) {
    if (Common.screenWidth == null || Common.screenHeight == null) {
      Common.screenWidth = MediaQuery.of(context).size.width;
      Common.screenHeight = MediaQuery.of(context).size.height;
    }
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _index);
    _infoTabController = TabController(vsync: this, length: 2);

    _pageController.addListener(() {
      setState(() {
        _ownership = -1;
        _forceForward3.value = true;

        double t = _pageController.hasClients ? _c4Height - (4 - _pageController.page) * (_c4Height - _c3Height) : 0;
        _forwardNotifier3.value = t > _c3Height ? t : _c3Height;
        _containerHeight = t > _c3Height ? t : _c3Height;
      });
    });

    _n3 = ValueNotifier<double>(0);
    _n4 = ValueNotifier<double>(0);
    _forwardNotifier3 = ValueNotifier<double>(0);
    _forceForward3 = ValueNotifier<bool>(true);

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

    // bottom navigation bar pages
    _pages = <Widget>[

      ExplorePage(),

      Text('a'),

      ChatPage(),

      ProfileInfoPage(
        disownCallback: disownCallback,
        notifier: _n3,
        notifier2: _forwardNotifier3,
        forceForward: _forceForward3,
        tabController: _infoTabController,
      ),

      ProfilePage(
        tabCallback: tabCallback,
        disownCallback: disownCallback,
        notifier: _n4,

        myProfile: true,

        userId: widget.userId,
        name: widget.name,
        imageUrl: widget.imageUrl,
        pictureUrls: widget.pictureUrls,

        totalViews: widget.totalViews,
        totalLikes: widget.totalLikes
      ),

    ];

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: _containerHeight,
                color: Color(0xFFCA436B),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ]
          ),

//          Positioned(
//            left: Common.screenWidth * 0.05,
//            top: Common.screenHeight * 0.1,
//            child: Container(
//                width: Common.screenWidth * 0.9,
//                height: 150,
//                child: Card(
//                  elevation: 10,
//                )
//            ),
//          ),

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
    );
  }
}