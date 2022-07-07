import 'package:flutter/material.dart';

class HeroImage extends StatefulWidget {
  HeroImage({Key? key, required this.tagUrl}) : super(key: key);

  String tagUrl;

  @override
  State<HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tagUrl),
      ),
      body: Hero(tag: widget.tagUrl, child: Image.network(widget.tagUrl)),
    );
  }
}
