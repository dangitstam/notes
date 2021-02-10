import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TastingHeroImageEnd extends StatelessWidget {
  final String tag;
  final Widget thumbnail;

  TastingHeroImageEnd({this.tag, this.thumbnail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.xmark, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Hero(
        tag: tag,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: thumbnail,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
