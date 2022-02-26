import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/screens/event/event-list.dart';
import 'package:cokg/src/areas/screens/home/drawer/search.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/resources/widgets/header.dart';
import 'package:flutter/material.dart';


class Timeline extends StatefulWidget {
  final AuthUser currentUser;
  const Timeline( this.currentUser );

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<EventList> eventLists;
  List<String> followingList = [];

  @override
  void initState() {
    super.initState();

    getTimeline();
    getFollowing();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
      .doc(widget.currentUser.id)
      .collection('timelineEvents')
      .orderBy('createdOn', descending: true)
      .get();

    List<EventList> eventLists = snapshot.docs.map((doc) => EventList.fromDocument(doc)).toList();

    setState(() {
      this.eventLists = eventLists;
    });
  }

  getFollowing()async {
    QuerySnapshot snapshot = await followingRef
      .doc(currentUser.id)
      .collection('userFollowing')
      .get();
    
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  buildTimeline() {
    if (eventLists == null) {
      return circularProgress();
    } else if (eventLists.isEmpty) {
      return buildUserToFollow();
    } else {
      return ListView(children: eventLists);
    }
  }

  buildUserToFollow() {

    return StreamBuilder(
      stream: userRef.orderBy('createdOn', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return circularProgress();
        }

        List<UserResult> userResults = [];
         
        snapshot.data.docs.forEach((doc) {
          AuthUser user = AuthUser.fromDocument(doc);
          final bool isAuthUser = currentUser.id == user.id;
          final bool isFollowingUser = followingList.contains(user.id);

          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });

        return Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[300],
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person_add, size: 30.0),
                    SizedBox(width: 8.0),
                    Text("Select User", style: TextStyle(fontSize: 25.0)), 
                  ],
                ),
              ),
            Column(children: userResults)
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: header(context, isAppTitle: true, removeNackButton: true),
      body: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: buildTimeline(),
      ),
    );
  }
}