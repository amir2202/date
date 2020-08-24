import 'package:dating/GraphQLRequests.dart';
import 'package:dating/homepages/explore_list_entry.dart';
import 'package:dating/homepages/explore_showcase.dart';
import 'package:flutter/material.dart';
import 'package:dating/common.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ExplorePage extends StatefulWidget {
  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> with SingleTickerProviderStateMixin {
  Future<QueryResult> fut;
  Future<QueryResult> lastOnline;
  bool popularcomplete = false;
  bool onlinecomplete = false;
  List<ShowcaseEntry> allpopularentries;
  ScrollController _scrollController;
  ValueNotifier<double> _offsetNotifier;
  GlobalKey _nearbyKey;

  AnimationController _animationController;
  Animation _animation;
  int _pressedButton = 0;

  double _imageContainerHeight = 225.0;
  double _imageContainerParallax = 0.0;
  bool _userHasPremium = Common.premium;

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

    if(Common.premium = true){
      lastOnline = GraphQLRequests.recentlyOnline(10);
      lastOnline.then((value) {
        onlinecomplete = true;
        print(value.data);
      });
    }
    fut = GraphQLRequests.popularUsers(0, 0);
    fut.then((value) {
      allpopularentries = List<ShowcaseEntry>();
      if(Common.premium == false){
        onlinecomplete = true;
      }
      popularcomplete = true;
      dynamic userlist = value.data["mostPopular"];
      for(dynamic user in userlist){
        //VARS TO pass
        /*final String userId;
        final String pictureUrl;
        final String text;
        final bool enabled;*/
        int likes = user["info"]["stats"]["totallikes"];
        int views = user["info"]["stats"]["totalviews"];
        //TODO matt the logic to display string
        String display = (likes+views).toString();
        allpopularentries.add(ShowcaseEntry(pictureUrl: user["profilepic"],enabled: true,text: display,userId:user["userid"]));
      }
      //TODO fix the list
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _offsetNotifier = ValueNotifier<double>(0.0);
    _nearbyKey = GlobalKey();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animation = ColorTween(begin: Color(0xFFCA436B), end: Color(0xFFCA436B).withOpacity(0.5)).chain(CurveTween(curve: Curves.ease)).animate(_animationController)..addListener(() { setState(() {}); });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox box = _nearbyKey.currentContext.findRenderObject();
      Offset position = box.localToGlobal(Offset.zero);
      setState(() {
        _offsetNotifier.value = position.dy + box.size.height;
      });
      print(_offsetNotifier.value);
    });
  }

  @override
  Widget build(BuildContext context) {
     return FutureBuilder(future: Common.premium == true ?Future.wait([fut,lastOnline]):fut,builder: (context,snapshot){
       if(!(popularcomplete && onlinecomplete)){
         return CircularProgressIndicator();
       }
       else{
       return Stack(
        children: <Widget>[
          Positioned(
            left: -(_imageContainerHeight - 225.0) / 2,
            top: _imageContainerParallax,
            child: Container(
              width: MediaQuery.of(context).size.width + _imageContainerHeight - 225.0,
              height: _imageContainerHeight,
              child: Image.network('https://i.pinimg.com/originals/3e/17/7a/3e177aaf03173a4eb243610bc343472e.jpg', fit: BoxFit.cover, color: Colors.black.withOpacity(0.5), colorBlendMode: BlendMode.srcATop),
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
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 225.0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Expanded(child: const Text('Meet new people', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 30)))
                      ],
                    ),
                  )
                ),

                if (_userHasPremium == false)
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                        color: const Color(0xFFCA436B),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Buy premium to see recently online and more.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              FloatingActionButton(
                                heroTag: "explore page",
                                onPressed: () {},
                                child: Icon(Icons.arrow_forward, color: const Color(0xFFCA436B)),
                                backgroundColor: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('RECENTLY ONLINE', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15)),
                              GestureDetector(
                                onTapDown: (details) {
                                  _pressedButton = 0;
                                  _animationController.forward(from: 0);
                                },
                                onTapUp: (details) {
                                  _animationController.reverse(from: 1);
                                },
                                onTapCancel: () {
                                  _animationController.reverse(from: 1);
                                },
                                child: Text('SEE MORE', style: TextStyle(color: _userHasPremium ? (_pressedButton == 0 ? _animation.value : Color(0xFFCA436B)) : Colors.grey, fontWeight: FontWeight.w800, fontSize: 15)),
                              )
                            ],
                          )
                        ),
                        Showcase(
                          enabled: _userHasPremium,
                          height: 100,
                          entries: <ShowcaseEntry>[
                            ShowcaseEntry(
                              userId: '0',
                              pictureUrl: 'https://i.pinimg.com/originals/3e/17/7a/3e177aaf03173a4eb243610bc343472e.jpg',
                            ),
                            ShowcaseEntry(
                              userId: '1',
                              pictureUrl: 'https://i.pinimg.com/originals/37/06/49/3706491ead343833c8bc86fa1b1d7d46.jpg',
                            ),
                            ShowcaseEntry(
                              userId: '2',
                              pictureUrl: 'https://64.media.tumblr.com/5d9d58c06de3405aa4c5ed4f0ec9e370/tumblr_p4qpfccwJP1tohdpqo1_400.jpg',
                            ),
                            ShowcaseEntry(
                              userId: '3',
                              pictureUrl: 'https://i.pinimg.com/736x/b9/30/cc/b930cca855a5b7496fa8df8c426ce6fc.jpg',
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('MOST POPULAR', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15)),
                              GestureDetector(
                                onTapDown: (details) {
                                  _pressedButton = 1;
                                  _animationController.forward(from: 0);
                                },
                                onTapUp: (details) {
                                  _animationController.reverse(from: 1);
                                  //OPEN NEW PAGE
                                  //TODO

                                },
                                onTapCancel: () {
                                  _animationController.reverse(from: 1);
                                },
                                child: Text('SEE MORE', style: TextStyle(color: _pressedButton == 1 ? _animation.value : Color(0xFFCA436B), fontWeight: FontWeight.w800, fontSize: 15)),
                              )
                            ],
                          )
                        ),
                        Showcase(
                          enabled: true,
                          height: 100,
                          entries: allpopularentries.length >= 4 ? allpopularentries.sublist(0,4):allpopularentries,
                          
                          /*<ShowcaseEntry>[
                            ShowcaseEntry(
                              userId: '111',
                              pictureUrl: 'https://i.pinimg.com/474x/f6/a6/5b/f6a65b2acdfa7e809be01bbd720ccf83.jpg'
                            ),
                            ShowcaseEntry(
                              userId: '222',
                              pictureUrl: 'https://i.pinimg.com/originals/94/79/82/94798298d9c7aa8f785582bb2860ec5e.png'
                            ),
                            ShowcaseEntry(
                              userId: '333',
                              pictureUrl: 'https://ourfunnylittlesite.com/wp-content/uploads/2018/07/1-4.jpg'
                            ),
                            ShowcaseEntry(
                              userId: '444',
                              pictureUrl: 'https://i.pinimg.com/originals/ee/7d/8a/ee7d8afc83dd1d6be52a031200a8f3c9.png'
                            )
                          ],
                          */
                        )
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          key: _nearbyKey,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Text('NEARBY', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15)),
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                ),

                SliverFixedExtentList(
                  itemExtent: 200,
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == 0)
                      return ExploreListEntry(listIndex: index, offsetNotifier: _offsetNotifier, parentScrollController: _scrollController, name: 'Beispiel', pictureUrl: 'https://i.pinimg.com/736x/6c/76/01/6c7601b26133029458ff6a15b01a7a85.jpg',);
                    else if (index == 1)
                      return ExploreListEntry(listIndex: index, offsetNotifier: _offsetNotifier, parentScrollController: _scrollController, name: 'Beispiel 2', pictureUrl: 'https://www.usmagazine.com/wp-content/uploads/2018/11/Maya-The-Dog-3.jpg?w=700&quality=70&strip=all',);
                    return Container(color: Colors.white, width: MediaQuery.of(context).size.width);
                  }),
                )

              ],
            ),
          ),
        ],
    );}},
     );
  }
}