import 'package:dating/homepages/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:dating/homepages/profile.dart';
import 'package:dating/common.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  final String name;
  HomePage({Key key, @required this.name});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  void getProfilePicture() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    setState(() { Common.profilePicture = File('$path/pfp.jpg'); });
  }

  int _index = 4;

  callback(index) {
    setState(() {
      _index = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _index);
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

    List<Widget> _pages = <Widget>[
      Text('a'),
      Text('a'),
      Text('a'),
      ProfileInfoPage(),
      ProfilePage(callback: callback, name: widget.name),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _index = index);
        },
        children: _pages,
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
          callback(index);
        },
      ),
    );
  }
}