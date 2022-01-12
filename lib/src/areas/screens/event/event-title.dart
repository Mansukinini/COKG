import 'package:cokg/src/areas/screens/event/event-list.dart';
import 'package:cokg/src/areas/screens/post-screen.dart';
import 'package:flutter/material.dart';

class EventTitle extends StatelessWidget {
  final EventList eventList;

  EventTitle(this.eventList);

  showPost(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(postId: eventList.id, userId: eventList.createdBy)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      // child: cachedNetworkImage(eventList.mediaUrl), to be implemented
      child: Image.network(eventList.mediaUrl),
    );
  }
}