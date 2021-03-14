import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/data/database.dart';
import 'package:cokg/src/areas/services/providers/event-provider.dart';
import 'package:cokg/src/resources/widgets/dateTimePicker.dart';
import 'package:cokg/src/resources/widgets/file-upload.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EventDetail extends StatefulWidget {
  final String id;
  EventDetail({this.id});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final dbService = DatabaseService();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime dateController;

  @override
  Widget build(BuildContext context)  {
    var eventProvider = Provider.of<EventProvider>(context);
    
    if (widget.id != null) {
      return FutureBuilder<Event>(
        future: eventProvider.getEventById(widget.id),
        builder: (context, event) {
        
        
        if (!event.hasData && widget.id != null) 
          return Center(child: CircularProgressIndicator());

        loadEvents(eventProvider, event.data, widget.id);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),

          title: Center(child: Text("Add Event")),
          actions: <Widget>[
            RaisedButton(
              child: Text('Save', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)),
              color: Theme.of(context).accentColor,
              onPressed: () {
                eventProvider.save();
                Navigator.of(context).pop();
              }
            )
          ]),
          body: _pageBody(context, eventProvider, event.data),
        );
      });
    } else {
      return StreamBuilder<Event>(
      stream: eventProvider.getEvent,
      builder: (context, event) 
      {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),

            title: Center(child: Text("Add Event")),
            actions: <Widget>[
              RaisedButton(
                child: Text('Save', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  eventProvider.save();
                  Navigator.of(context).pop();
                }
              )
            ]),
            body: _pageBody(context, eventProvider, event.data),
          );
        },
      );
    }
  }

  Widget _pageBody(BuildContext context, EventProvider eventProvider, Event event) {
     
    return Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
        child: ListView(children: <Widget>[ Column(
          children: <Widget>[
            SizedBox(height: 20.0,),

            StreamBuilder<String>(
              stream: eventProvider.getImageUrl,
              builder: (context, event) {

                if (!event.hasData){
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  height: MediaQuery.of(context).size.height * .25,
                  child: CircleAvatar(
                    radius: 150.0,
                    backgroundImage: (event.data != null) ? NetworkImage(event.data) : AssetImage('assests/images/Image0.jpeg'),
                    child: FileUpload(icon: Icons.camera_alt, onPressed: eventProvider.pickImage),
                  ),
                );
              }
            ),

            StreamBuilder<String>(
              stream: eventProvider.getName,
              builder: (context, snapshot) {
                  
                return AppTextField(
                  labelText: 'Title',
                  initialText: (event != null) ? event.name.toString() : null,
                  onChanged: eventProvider.setName,
                );
              }
            ),
            
            StreamBuilder<String>(
              stream: eventProvider.getDescription,
              builder: (context, snapshot) {
                  
                return AppTextField(
                  labelText: 'Enter Description',
                  maxLines: 3,
                  initialText: (event != null) ? event.description.toString() : null,
                  onChanged: eventProvider.setDescription,
                );
              }
            ),
            
            StreamBuilder<DateTime>(
              stream: eventProvider.getDateTime,
              builder: (context, event) {

                if (!event.hasData){
                  return Center(child: CircularProgressIndicator());
                }

                return AppDateTimePicker(
                  dateLabelText: 'Date', 
                  timeLabelText: "Hour", 
                  initialValue: (event != null) ? event.data.toIso8601String() : null,
                  onChanged: (val) {eventProvider.setDateTime(DateTime.parse(val));}
                );
              }
            ),
          ],)
        ],),
      );
  }

  loadEvents(EventProvider eventProvider, Event event, String eventId) {
    eventProvider.setId(eventId);
    
    if (eventId != null) {
      eventProvider.setImageUrl(event.imageUrl);
      eventProvider.setName(event.name);
      eventProvider.setDescription(event.description);
      eventProvider.setDateTime(DateTime.parse(event.date.toString()));
    } else {
      eventProvider.setName(null);
      eventProvider.setDescription(null);
    }
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