import 'package:audioplayers/audioplayers.dart';
import 'package:cokg/src/resources/widgets/list-tile.dart';
import 'package:flutter/material.dart';

class SermonList extends StatefulWidget {
  @override
  _SermonListState createState() => _SermonListState();
}

class _SermonListState extends State<SermonList> {
  AudioPlayer audioPlayer;
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.zero,
            child: Image.asset('assets/images/logo0.jpg', fit: BoxFit.cover,))
        ]),

        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          onTap: () {
            Navigator.of(context).pushNamed("/Sermon");
          },
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
        )
      ],
    );
  }
}