import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/screens/home/drawer/profile.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/areas/screens/post-screen.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/resources/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;


class ActivityFeed extends StatefulWidget {

  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef.doc(currentUser.id)
      .collection('feedItems')
      .orderBy('createdOn', descending: true)
      .limit(50).get();

      List<ActivityFeedItem> feedItems = [];

      snapshot.docs.forEach((doc) {
        feedItems.add(ActivityFeedItem.fromDocument(doc));
      });

    return feedItems;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: header(context, titleText: "Activity Feed", removeNackButton: true),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return circularProgress();
            }

            return ListView(children: snapshot.data);
          },
        ),
      ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String userId;
  final String postId;
  final String username;
  final String type;
  final String mediaUrl;
  final String userProfileImg;
  final String comment;
  final Timestamp createdOn;

  ActivityFeedItem({
    this.userId,
    this.postId,
    this.username,
    this.type,
    this.mediaUrl,
    this.userProfileImg,
    this.comment,
    this.createdOn,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {

    return ActivityFeedItem(
      userId: doc.data()['userId'],
      postId: doc.data()['postId'],
      username: doc.data()['username'],
      type: doc.data()['type'],
      mediaUrl: doc.data()['mediaUrl'],
      userProfileImg: doc.data()['userProfileImg'],
      comment: doc.data()['comment'],
      createdOn: doc.data()['createdOn'],
    );
  }

  showPost(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(postId: postId, userId: currentUser.id)));
  }

  configureMediaPreview(BuildContext context) {

    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (mediaUrl != null) ? CachedNetworkImageProvider(mediaUrl) : AssetImage('assets/images/user.jpg'),
                )
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like') {
      activityItemText = "liked your post ";
    }else if (type == 'follow') {
      activityItemText = "is following you";
    } else if (type == 'comment') {
      activityItemText = 'replied: $comment';
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: currentUser.id),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(style: TextStyle(fontSize: 14.0, color: Colors.black,),
                children: [
                  TextSpan(text: username, style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '$activityItemText', style: TextStyle(fontWeight: FontWeight.bold))
                ]
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: (userProfileImg != null) ? CachedNetworkImageProvider(userProfileImg) : AssetImage('assets/images/user.jpg'),
          ),
          subtitle: Text(timeago.format(createdOn.toDate()), overflow: TextOverflow.ellipsis,),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(id: profileId)));
}