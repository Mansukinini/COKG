import 'package:flutter/material.dart';

class VideoInfo extends StatefulWidget {
  // const VideoInfo({ Key? key }) : super(key: key);

  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.0,
      height: 250.0,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     // colors: [
      //     //   Colors.brown,
      //     //   Colors.accents
      //     // ],
      //     // begin: FractionalOffset(0.0, 0.4),
      //     // end: Alignment
      //   )
      // ),
      child: Column(
        children: <Widget>[

          Center(child: Text('Live'))
        ],
      ),
    );
  }
}