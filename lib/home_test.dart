import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomePage(name: 'Matt', imageUrl: 'https://icatcare.org/app/uploads/2018/07/Thinking-of-getting-a-cat.png', pictureUrls: <String>[
        'https://cdn.mos.cms.futurecdn.net/VSy6kJDNq2pSXsCzb6cvYF.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
        'https://i.insider.com/5e2ef209ab49fd373f6ba714?width=1136&format=jpeg',
        'https://www.cats.org.uk/media/3236/choosing-a-cat.jpg',
        'https://static01.nyt.com/images/2019/09/04/business/04chinaclone-01/merlin_160087014_de761d9a-4360-402d-a15b-ddeff775760d-jumbo.jpg',
        'https://media.architecturaldigest.com/photos/5c01b23c2226412d33ca7725/16:9/w_2560%2Cc_limit/GettyImages-702612761.jpg',
        'https://news.cgtn.com/news/77416a4e3145544d326b544d354d444d3355444f31457a6333566d54/img/37d598e5a04344da81c76621ba273915/37d598e5a04344da81c76621ba273915.jpg',
        'https://static.scientificamerican.com/blogs/cache/file/1379B8E0-9602-42D5-9602278C1F21FAF2_source.jpg?w=590&h=800&AF11F83F-A202-49A5-948C06206102FF92',
      ], totalLikes: 123, totalViews: 420),
    );
  }
}