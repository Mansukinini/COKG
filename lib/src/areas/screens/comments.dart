import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/resources/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String postId;
  final String postCreatedBy;
  final String postMediaUrl;

  Comments({ this.postId, this.postCreatedBy, this.postMediaUrl});

  @override
  CommentsState createState() => CommentsState( postId: this.postId, postCreatedBy: this.postCreatedBy, postMediaUrl: this.postMediaUrl);
}

class CommentsState extends State<Comments> {
  // final String currentUserId = 'xdc5kPEYmQXK1gihk3lC659sCzQ2';
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postCreatedBy;
  final String postMediaUrl;

  CommentsState({ this.postId, this.postCreatedBy, this.postMediaUrl});

  buildComments() {
    return StreamBuilder(
      stream: commetsRef.doc(postId).collection('comments').orderBy("createdOn", descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        List<Comment> comments = [];

        snapshot.data.docs.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });

        return ListView(children: comments);
      }
    );
  }

  addComment() {
    commetsRef.doc(postId).collection("comments")
      .add({
        "userId": currentUser.id,
        "username": currentUser.username,
        "avatarUrl": currentUser.photoUrl,
        "comment": commentController.text,
        "createdBy": currentUser.id,
        "createdOn": timestamp,
      });

    activityFeedRef.doc(postCreatedBy).collection("feedItems")
      .add({
        "userId": currentUser.id,
        "postId": postId,
        "username": currentUser.username,
        "userProfileImg": currentUser.photoUrl, // currentUser.image
        "type": "comment",
        "comment": commentController.text,
        "mediaUrl": postMediaUrl,
        "createdOn": timestamp,
      });

    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: header(context, titleText: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Write a comment...")
            ),
            trailing: OutlinedButton(
              onPressed: addComment,
              style: OutlinedButton.styleFrom(side: BorderSide.none),
              child: Text("Post"),
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userId;
  final String username;
  final String avatarUrl;
  final String comment;
  final Timestamp createdOn;

  Comment({
    this.userId,
    this.username,
    this.avatarUrl,
    this.comment,
    this.createdOn,
  });

  factory Comment.fromDocument(DocumentSnapshot doc){
    return Comment(
      userId: doc['userId'],
      username: doc['username'],
      avatarUrl: doc['avatarUrl'],
      comment: doc['comment'],
      createdOn: doc['createdOn'],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: (avatarUrl != null) ? CachedNetworkImageProvider(avatarUrl) : AssetImage('assets/images/user.jpg'),
          ),
          subtitle: Text(timeago.format(createdOn.toDate())),
        ),
        Divider()
      ],
    );
  }
}