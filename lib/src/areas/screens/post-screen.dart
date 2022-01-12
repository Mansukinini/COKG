import 'package:cokg/src/areas/screens/event/event-list.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/resources/widgets/header.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: eventRef.doc(userId).collection('userEvents').doc(postId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        EventList eventList = EventList.fromDocument(snapshot.data);

        return Center(
          child: Scaffold(
            appBar: header(context, titleText: eventList.description),
            body: ListView(children: <Widget>[Container(child: eventList)]),
          ),
        );
      }
    );
  }
}