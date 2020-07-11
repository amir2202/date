import 'package:flutter/material.dart';

class ImagePostPage extends StatefulWidget {
  final String imageUrl;
  ImagePostPage({Key key, @required this.imageUrl});

  @override
  ImagePostPageState createState() => ImagePostPageState();
}

class ImagePostPageState extends State<ImagePostPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'image_post',
      child: Container(
        child: Image.network(widget.imageUrl),
      ),
    );
  }
}