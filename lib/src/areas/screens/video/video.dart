import 'package:cokg/src/resources/widgets/header.dart';
import 'package:flutter/material.dart';

class Video extends StatefulWidget {

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Youtube'),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}