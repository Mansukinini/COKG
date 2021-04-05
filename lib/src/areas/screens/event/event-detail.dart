import 'package:cokg/src/areas/models/Event.dart';
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
  // final nameController = TextEditingController();
  // final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context)  {
    var eventProvider = Provider.of<EventProvider>(context);
    
    if (widget.id != null) {
     return _editEvent(context, eventProvider);
    } else {
      return _addEvent(context, eventProvider);
    }
  }

  StreamBuilder _addEvent(BuildContext context, EventProvider eventProvider) {
   
    return StreamBuilder<Event>(
      stream: eventProvider.getEvent,
      builder: (context, event) => _scafford(context, eventProvider, event),
    );
  }

  FutureBuilder _editEvent(BuildContext context, EventProvider eventProvider) {
    
    return FutureBuilder<Event>(
      future: eventProvider.getEventById(widget.id),
      builder: (context, event) {

      if (!event.hasData && widget.id != null) 
        return Center(child: CircularProgressIndicator());

      return  _scafford(context, eventProvider, event);
    });
  }

  Scaffold _scafford(BuildContext context, EventProvider eventProvider, AsyncSnapshot<Event> event) {
    var action = event.data != null ? "Edit Event" : "Add Event";

    _setEvent(eventProvider, event.data, widget.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),

        title: Center(child: Text(action)),
        actions: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            child: Text('Save', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)),
            color: Theme.of(context).accentColor,
            onPressed: () {eventProvider.saveEvent().then((value) => Navigator.of(context).pop());},
          )
        ]
      ),
      body: _pageBody(context, eventProvider, event.data),
    );
  }

  Widget _pageBody(BuildContext context, EventProvider eventProvider, Event event) {
      
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: ListView(
          children: <Widget>[ 
            SizedBox(height: 20.0,),

          StreamBuilder<String>(
            stream: eventProvider.getImageUrl,
            builder: (context, event) {
              
              if (event.data != null){
                if (!event.hasData)
                  return Center(child: CircularProgressIndicator());
                
                return Container(
                  height: MediaQuery.of(context).size.height * .25,
                  child: CircleAvatar(
                    radius: 150.0,
                    backgroundImage: (event.data != null) ? NetworkImage(event.data) : AssetImage('assets/images/user.jpg'),
                    child: FileUpload(icon: Icons.camera_alt, onPressed: eventProvider.pickImage),
                  ),
                );
              } else {
                return FileUpload(icon: Icons.camera_alt, onPressed: eventProvider.pickImage);
              }
            }
          ),

          StreamBuilder<String>(
            stream: eventProvider.getName,
            builder: (context, snapshot) {
                
              return AppTextField(
                labelText: 'Title',
                initialText: (event != null) ? event.name : null,
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
                initialText: (event != null) ? event.description : null,
                onChanged: eventProvider.setDescription,
              );
            }
          ),
            
          StreamBuilder<DateTime>(
            stream: eventProvider.getDateTime,
            builder: (context, snapshot) {
              
              return AppDateTimePicker(
                dateLabelText: 'Date & Time', 
                initialValue: (event != null) ? DateTime.parse(event.date) : null,
              );
            }
          ),
        ],
      ),
    );
  }

  void _setEvent(EventProvider eventProvider, Event event, String eventId) {
    eventProvider.setId(widget.id);
    
    if (widget.id != null && event.toMap() != null) {
      // eventProvider.setChanges(event);
      eventProvider.setImageUrl(event.imageUrl ?? '');
      eventProvider.setName(event.name);
      eventProvider.setDescription(event.description);
      eventProvider.setDateTime(DateTime.parse(event.date));
    } else {
      eventProvider.setImageUrl(null);
      eventProvider.setName(null);
      eventProvider.setDescription(null);
      eventProvider.setDateTime(null);
    }
  }
  
  @override 
  void dispose() {
    // eventProvider.dispose();
    // nameController.dispose();
    // descriptionController.dispose();
    super.dispose();
  }
}