import 'package:dating/homepages/explore_showcase_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImageBox extends StatelessWidget {
  final String imageUrl;
  ProfileImageBox({Key key, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageUrl,
      child: Material(
        child: Ink.image(
          image: NetworkImage(this.imageUrl),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          width: 100,
          height: 100,
          child: InkWell(
            onTap: () {},
            splashColor: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {

  final String userId;
  final String name;
  final String pictureUrl;
  final List<String> pictureUrls;

  Profile({
    Key key,
    @required this.userId,
    @required this.name,
    @required this.pictureUrl,
    @required this.pictureUrls,
  });

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {

  ScrollController _scrollController;

  double _imageContainerHeight = 225.0;
  double _imageContainerParallax = 0.0;

  void _onScroll() {

    setState(() {
      if (_scrollController.position.pixels > 0) {
        _imageContainerHeight = 225.0;
        _imageContainerParallax = -_scrollController.position.pixels * 0.5;
      } else {
        _imageContainerHeight = 225.0 - _scrollController.position.pixels;
        _imageContainerParallax = 0.0;
      }
    });

  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: -(_imageContainerHeight - 225.0) / 2,
            top: _imageContainerParallax,
            child: Container(
              width: MediaQuery.of(context).size.width + _imageContainerHeight - 225.0,
              height: _imageContainerHeight,
              child: Image.network(widget.pictureUrl, fit: BoxFit.cover, color: Colors.black.withOpacity(0.5), colorBlendMode: BlendMode.srcATop),
            ),
          ),
          RefreshIndicator(
            onRefresh: () { return Future<void>(null); },
            strokeWidth: 2.5,
            color: const Color(0xFFCA436B),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        top: 225,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 150,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(widget.pictureUrl),
                                      radius: 50,
                                      backgroundColor: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(widget.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Material(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              child: InkWell(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                onTap: () {},
                                                child: Container(
                                                  width: 55,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Colors.transparent,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text('320', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                                      Icon(Icons.favorite, size: 14, color: Colors.white),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                onTap: () {},
                                                child: Container(
                                                  width: 57,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(color: Colors.black12, width: 1),
                                                    color: Colors.transparent,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text('1.7K', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                                      Icon(Icons.remove_red_eye, size: 14, color: Colors.black),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    height: 25,
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProfileImageBox(imageUrl: widget.pictureUrls[index]);
                    },
                    childCount: widget.pictureUrls.length,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}