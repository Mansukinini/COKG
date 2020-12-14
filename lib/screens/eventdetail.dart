import 'package:flutter/material.dart';
import 'package:cokg/models/Event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final List<String> options = const <String>[
  'Save & Back',
  'Delete',
  'Back'
];

const menuSave = 'Save & Back';
const menuDelete = 'Delete';
const menuBack = 'Back';


class EventDetail extends StatefulWidget {
  
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {

  Event event;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final ref = FirebaseFirestore.instance.collection('event');
  
  @override
  Widget build(BuildContext context)  {
  
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Add Event"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: (){save();},
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(children: <Widget>[ Column(
          children: <Widget>[
            Container(
              height: 240,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.yellow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
                ),
            ),

            TextField(
              controller: nameController,
              style: textStyle,
              onChanged: null,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: textStyle,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0), 
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: null,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
            )
            
           ], 
            )
          ],
        ),
      ),
    );
  }

  void select(String value) {
    switch (value) {
      case menuSave:
        save();
        break;
      default:
    }
  }

  void save() {
    FirebaseFirestore.instance.collection('event').add({
      "name": nameController.text,
      "description": descriptionController.text
    }).then((value) => print(value.id));
  }
}