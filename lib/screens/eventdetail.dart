import 'package:cokg/models/Event.dart';
import 'package:flutter/material.dart';

final List<String> options = const <String>[
  'Save & Back',
  'Delete',
  'Back'
];

const menuSave = 'Save & Back';
const menuDelete = 'Delete';
const menuBack = 'Back';

class EventDetail extends StatefulWidget {
  // final Event event;
  // EventDetail(this.event);

  @override
  State<StatefulWidget> createState() => EventDetailState();
}

class EventDetailState extends State {
  Event event;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  
  EventDetailState();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    // titleController.text = event.name;
    // descriptionController.text = event.description;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Add Event"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) => options
              .map((e) => PopupMenuItem<String>(value: e, child: Text(e))).toList(),
          )
        ],
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(children: <Widget>[ Column(
          children: <Widget>[
            
            TextField(
              // controller: titleController,
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
                // controller: titleController,
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

  }
}