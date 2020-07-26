
import 'package:flutter/material.dart';
import 'package:dating/homepages/profile.dart';

class ProfileExternalPage extends StatefulWidget {
  final String userId;
  final String name;
  final String imageUrl;
  final List<String> pictureUrls;

  final int totalViews;
  final int totalLikes;

  ProfileExternalPage({Key key,
    @required this.userId,
    @required this.name,
    @required this.imageUrl,
    @required this.pictureUrls,

    @required this.totalViews,
    @required this.totalLikes
  });

  @override
  ProfileExternalPageState createState() => ProfileExternalPageState();
}

class ProfileExternalPageState extends State<ProfileExternalPage> {

  ValueNotifier<double> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = new ValueNotifier<double>(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: _notifier.value,
                color: Color(0xFFCA436B),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ]
          ),

          ProfilePage(
            tabCallback: (a, b) {},
            disownCallback: (a) { setState(() {}); },
            notifier: _notifier,

            myProfile: false,

            userId: widget.userId,
            name: widget.name,
            imageUrl: widget.imageUrl,
            pictureUrls: widget.pictureUrls,

            totalViews: widget.totalViews,
            totalLikes: widget.totalLikes,
          )

        ]
      ),
    );
  }
}