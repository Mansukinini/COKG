import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/event-provider.dart';


class EventDetail extends StatefulWidget {
  final Event event;
  EventDetail({this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime dateController;
  

  List<AssetImage> listOfImage;
  
  @override
  void initState() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    
    if (widget.event != null) {
      nameController.text = widget.event.name;
      descriptionController.text = widget.event.description;
      dateController = DateTime.parse(widget.event.date);

      eventProvider.setChanges(widget.event);
    } 

    super.initState();
  }

  void getImages() {
    listOfImage = List();
    for (int i = 0; i < 3; i++) {
      listOfImage.add(AssetImage('assests/images/Image' + i.toString() + '.jpeg'));
    }
    print('$listOfImage');
  }
  
  @override
  Widget build(BuildContext context)  {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    final eventProvider = Provider.of<EventProvider>(context);

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
            onPressed: () {
              eventProvider.save();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0,),
        child: ListView(children: <Widget>[ Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assests/images/Image0.jpeg'),
                    child: ClipOval(
                      child: new SizedBox(width: 180.0, height: 180.0,),
                    ),
                  ),
                ),
                // Add Photo
                Padding(
                  padding: EdgeInsets.only(top:60.0),
                  child: IconButton(icon: Icon(Icons.add_a_photo), iconSize: 30.0,
                  onPressed: (){
                  
                  },
                  ),
                )
              ],
            ),
            
            TextField(
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: textStyle,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
              ),
              style: textStyle,
              controller: nameController,
              onChanged: (String value) => eventProvider.name = value,
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0), 
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
                controller: descriptionController,
                onChanged: (String value) => eventProvider.description = value,
                style: textStyle,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: DateTimeField(
                onDateSelected: (DateTime dateTime) {
                  setState(() {
                    if (dateTime != null)
                      eventProvider.date = dateTime;
                  });
                },
                decoration: InputDecoration(labelStyle: textStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                selectedDate: eventProvider.date,
                label: 'Date Time',
                firstDate: DateTime.now().subtract(new Duration(days: 365)),
                lastDate: DateTime.now().add(new Duration(days: 365)),
                dateFormat: null,
              ),
            ),
            
          ],)
        ],),
      ),
    );
  }

  Future<DateTime> datePicker(BuildContext context) async {
    final DateTime datePicker = await showDatePicker(context: context, initialDate: DateTime.now(), 
    firstDate: DateTime(2018), lastDate: DateTime(2050), fieldHintText: 'YYYY/MM/DD');
     
    if (datePicker == null) return null;

    return datePicker;
  }
  
  @override 
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}