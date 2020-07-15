import 'package:flutter/material.dart';
import 'package:dating/homepages/profile_info.dart';
import 'package:dating/common.dart';

class ProfileInfoViews extends StatefulWidget {
//  final ValueNotifier<double> notifier;
//  final Function(int) disownCallback;
  final List<dynamic> entries;
  final ScrollController scrollController;
  final ValueNotifier<bool> notifier;
  final bool like;
  ProfileInfoViews({Key key, @required this.scrollController, @required this.notifier, @required this.like,@required this.entries});

  @override
  ProfileInfoViewsState createState() => ProfileInfoViewsState();
}

class ProfileInfoViewsState extends State<ProfileInfoViews> with AutomaticKeepAliveClientMixin<ProfileInfoViews> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
///GET LIST LENGTH for item count
    return ScrollConfiguration(
      behavior: CmScrollBehavior(),
      child: ListView.builder(
        itemCount: widget.entries.length,
        controller: widget.notifier.value == widget.like ? widget.scrollController : null,
        itemBuilder: (BuildContext context, int index) {
          return ViewEntry(name:widget.entries[index]['byName'] , imageUrl: widget.entries[index]['byPicture'], like: widget.like);
        },
        padding: EdgeInsets.fromLTRB(0, Common.screenHeight * 0.12 + Common.screenHeight * 0.05, 0, 0),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
    );
  }
}