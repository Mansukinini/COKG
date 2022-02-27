import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/screens/comments.dart';
import 'package:cokg/src/areas/screens/home/drawer/profile.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class EventList extends StatefulWidget {

  final String id;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final bool isUploaded;
  final dynamic likes;
  final String createdBy;
  final Timestamp createdOn;

  EventList({
    this.id,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.isUploaded,
    this.likes,
    this.createdBy,
    this.createdOn
  });

  factory EventList.fromDocument(DocumentSnapshot doc) {
    return EventList(
      id: doc.data()['id'],
      username: doc.data()['username'],
      location: doc.data()['location'],
      description: doc.data()['description'],
      mediaUrl: doc.data()['mediaUrl'],
      isUploaded: doc.data()['isUploaded'],
      likes: doc.data()['likes'],
      createdBy: doc.data()['createdBy']
      // createdOn: doc.data()['createdOn']
    );
  }

  int getLikecount(likes) {
    
    if (likes == null) {
      return 0;
    }

    int count = 0;

    likes.values.forEach((val){
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  State<EventList> createState() => _EventListState(
    id: this.id,
    username: this.username,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    likes: this.likes,
    likeCount: getLikecount(this.likes),
    createdBy: this.createdBy,
    createdOn: this.createdOn
  );
}

class _EventListState extends State<EventList> {
  final String currentUserId = currentUser?.id;
  final String id;
  final String userId;
  final String username;
  final String location; 
  final String description;
  final String mediaUrl;
  final String createdBy;
  final Timestamp createdOn;
  int likeCount;
  Map likes;
  bool isLiked;
  bool showHeart = false;

  _EventListState({
    this.id,
    this.userId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
    this.createdBy,
    this.createdOn
  });

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildEventListHeader(),
        buildEventImage(),
        buildEventFooter()
      ],
    );
  }

  buildEventListHeader() {
   
    return FutureBuilder(
      future: userRef.doc(createdBy).get(),
      builder: (context, snapshot) {
        
        if (!snapshot.hasData) {
          return circularProgress();
        }

        AuthUser user = AuthUser.fromDocument(snapshot.data);
        bool isCreatedBy = currentUserId == createdBy;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: (user != null && user.photoUrl != null) 
            ? CachedNetworkImageProvider(user.photoUrl) 
            : AssetImage('assets/images/user.jpg'),
          ),

          title: GestureDetector(
            onTap: () => showProfile(context, profileId: createdBy),
            child: Text(user.displayName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          
          // subtitle: Text(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(user.createdOn))),
          trailing: isCreatedBy ? IconButton(
            onPressed: () => handleDeleteEvent(context),
            icon: Icon(Icons.more_vert),
          ) : Text(''),
        );
      }
    );
  }

  handleDeleteEvent(BuildContext parentContext) {

    return showDialog(
      context: parentContext, builder: (context) {

        return SimpleDialog(title: Text("Remove this Post?"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                deleteEvent();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red))),
            SimpleDialogOption(child: Text('Cancel'), onPressed: () => Navigator.pop(context),)
          ],
        );
      });
  }

  // Note: Only the person created the poster should delete it
  deleteEvent() async {
    // delete post
    eventRef.doc(createdBy)
      .collection('userEvents')
      .doc(id).get()
      .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });

    // delete uploaded image for the post
    storageRef.child(createdBy).delete();

    //then delete activity feed
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
      .doc(createdBy).collection('feedItems').where('postId', isEqualTo: id).get();

      activityFeedSnapshot.docs.forEach((item) { 
        if (item.exists) {
          item.reference.delete();
        }
      });

    // then Delete all comment
    QuerySnapshot commentsSnapshot = await commetsRef.doc(id).collection('comments').get();

    commentsSnapshot.docs.forEach((item) { 
      if (item.exists) {
        item.reference.delete();
      }
    });
  }

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(id: profileId)));
  }

  handleLikePost() {
    bool isLike = likes[currentUserId] == true;

    if(isLike) {
      eventRef.doc(createdBy)
      .collection('userEvents')
      .doc(id)
      .update({ 'likes.$currentUserId': false });

      removeLikeFromActivityFeed();

      setState(() {
        likeCount -= 1;
        isLiked = false; 
        likes[currentUserId] = false;
      });
    } else if (!isLiked) {
      eventRef.doc(createdBy)
      .collection('userEvents')
      .doc(id)
      .update({ 'likes.$currentUserId': true });

      addLikeToActivityFeed();

      setState(() {
        likeCount += 1;
        isLiked = true; 
        likes[currentUserId] = true;
        showHeart = true;
      });

      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      }); 
    }
  }

  addLikeToActivityFeed() {
    // add a notification to the post owner's activity feed only if comment made by other user (to avoind getting notification for our own like)
    bool isNotPostOwner = currentUserId != createdBy;

    if (isNotPostOwner) {
      activityFeedRef.doc(createdBy).collection("feedItems").doc(id)
        .set({
          "userId": currentUserId,
          "postId": id,
          "username": currentUser.username,
          "userProfileImg": currentUser.photoUrl,
          "type": "like",
          "mediaUrl": mediaUrl,
          "createdOn": timestamp,
        });
    }
  }

  removeLikeFromActivityFeed() {
    // add a motification to the postowner's activity feed only if comment made by other user (to avoind getting notification for our own like)
    bool isNotPostOwner = currentUserId != createdBy;

    if (isNotPostOwner) {
      activityFeedRef.doc(createdBy).collection("feedItems").doc(id).get()
      .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  buildEventImage() { 

    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // cachedNetworkImage(mediaUrl)
          Image.network(mediaUrl),

          showHeart ? Animator(
            duration: Duration(milliseconds: 300),
            tween: Tween(begin: 0.8, end: 1.4),
            curve: Curves.elasticInOut,
            cycles: 0,
            builder: (context, anim, child) => Transform.scale(scale: anim.value, child:Icon(Icons.favorite, size: 80.0, color: Colors.red)),
          ) : Text(''),
          
        ],
      ),
    );
  }

  buildEventFooter() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: handleLikePost,
              child: Icon( isLiked ? Icons.favorite : Icons.favorite_border, size: 28.0, color: Colors.pink,),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(context, postId: id, createdBy: createdBy, mediaUrl: mediaUrl),
              child: Icon(Icons.chat, size: 28.0, color: Colors.blue[900],),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text("$likeCount likes", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text("${currentUser.username} likes", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }

  showComments(BuildContext context, {String postId, String createdBy, String mediaUrl }) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Comments(postId: postId, postCreatedBy: createdBy, postMediaUrl: mediaUrl);
    }));
  }
}