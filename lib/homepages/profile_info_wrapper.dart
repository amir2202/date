import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dating/homepages/profile.dart';
import 'package:dating/homepages/profile_info.dart';

class ProfileInfoWrapper extends StatefulWidget {
  final Function(int) disownCallback;
  final Function(bool) c2Callback;
  final Function() c3HeightSavedCallback;
  final ValueNotifier<double> notifier;
  final GlobalKey<NavigatorState> navigatorKey;

  ProfileInfoWrapper({Key key, @required this.disownCallback, @required this.c2Callback, @required this.c3HeightSavedCallback, @required this.notifier, @required this.navigatorKey});

  @override
  ProfileInfoWrapperState createState() => ProfileInfoWrapperState();
}

class ProfileInfoWrapperState extends State<ProfileInfoWrapper> {


  static final String root = '/';
  static final String profile = '/profile';

  void _push(BuildContext context, String name, String imageUrl, List<String> pictureUrls, int totalViews, int totalLikes) {
    var routeBuilders = _routeBuilders(context, name, imageUrl, pictureUrls, totalViews, totalLikes);

    widget.c2Callback(true);
    widget.c3HeightSavedCallback();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[ProfileInfoWrapperState.profile](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, String name, String imageUrl, List<String> pictureUrls, int totalViews, int totalLikes) {
    return {
      ProfileInfoWrapperState.root: (context) => ProfileInfoPage(disownCallback: widget.disownCallback, notifier: widget.notifier, onPush: _push),
      ProfileInfoWrapperState.profile: (context) => ProfilePage(tabCallback: (a, b) {}, disownCallback: widget.disownCallback, c2Callback: widget.c2Callback, notifier: widget.notifier, myProfile: false, name: name, imageUrl: imageUrl, pictureUrls: pictureUrls, totalViews: totalViews, totalLikes: totalLikes),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context, null, null, null, null, null);

    return Navigator(
      key: widget.navigatorKey,
      initialRoute: ProfileInfoWrapperState.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context)
        );
      },
    );
  }
}