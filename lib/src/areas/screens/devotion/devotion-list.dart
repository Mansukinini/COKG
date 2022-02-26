import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/screens/devotion/devotion-preview.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/resources/widgets/header.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';


class DevotionList extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String mediaUrl;
  final bool isUploaded;
  final String createdBy;
  final Timestamp createdOn;

  DevotionList({
    this.id,
    this.title,
    this.description,
    this.mediaUrl,
    this.isUploaded,
    this.createdBy,
    this.createdOn
  });

  factory DevotionList.fromDocument(DocumentSnapshot doc) {

    return DevotionList(
      id: doc.data()['id'],
      title: doc.data()['title'],
      description: doc.data()['description'],
      mediaUrl: doc.data()['mediaUrl'],
      isUploaded: doc.data()['isUploaded'],
      createdBy: doc.data()['createdBy'],
      createdOn: doc.data()['createdOn']
    );
  }
  @override
  _DevotionListState createState() => _DevotionListState(
    id: this.id,
    title: this.title,
    description: this.description,
    mediaUrl: this.mediaUrl,
    isUploaded: this.isUploaded,
    createdBy: this.createdBy,
    createdOn: this.createdOn
  );
}

class _DevotionListState extends State<DevotionList> {
  final String id;
  final String title; 
  final String description;
  final String mediaUrl;
  final bool isUploaded;
  final String createdBy;
  final Timestamp createdOn;

  _DevotionListState({
    this.id,
    this.title,
    this.description,
    this.mediaUrl,
    this.isUploaded,
    this.createdBy,
    this.createdOn
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: header(context, titleText: "Devotion", removeNackButton: true),
      body: _pageBody()
    );
  }

  _pageBody() {

    return StreamBuilder(
      stream: devotionRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return circularProgress();
        
        List<DevotionList> devotionResults = [];

        snapshot.data.docs.forEach((doc){
          devotionResults.add(DevotionList.fromDocument(doc));
        });

        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(background: Image.asset('assets/images/main.jpg', fit: BoxFit.fitWidth)),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {

                  return DevotionResult(devotionResults[index]);
                },
                childCount: devotionResults.length,
              ),
            ),
          ],
        ); 
      }
    );
  }
}

class DevotionResult extends StatelessWidget {
  final DevotionList devotion;
  DevotionResult(this.devotion);

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[ 
                    Expanded(
                      child: ListTile(
                        leading: Icon(Icons.headphones_rounded, size: 35.0, color: Colors.black),
                        title: Text(devotion.title, style: TextStyles.title, overflow: TextOverflow.ellipsis,),
                        subtitle: Text(devotion.description ?? devotion.title, style: TextStyles.subtitle, overflow: TextOverflow.ellipsis,),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DevotionPreview(devotion))),
                        onLongPress: () => Navigator.of(context).pushNamed("/devotionDetail/${devotion.id}"),
                      ),
                    )
                  ]
                ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          child: Divider(),
        ),
      ],
    );
  }
}