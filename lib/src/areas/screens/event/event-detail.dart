import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/providers/event-provider.dart';
import 'package:cokg/src/config.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/dateTimePicker.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/base.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _auth = FirebaseAuth.instance;

class EventDetail extends StatefulWidget {
  final String id;
  EventDetail({this.id});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  bool isEdit = false;
  User user;

  @override
  void initState() {
    user = _auth.currentUser;
    super.initState();
  }

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
    isEdit = true;

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
    var action = event.data != null ? (isEdit) ? "Edit Event" : "" : "Add Event";
    eventProvider.setEvent(event.data, widget.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
        title: Center(child: Text(action, style: TextStyles.navTitle)),
        actions: <Widget>[
          (isEdit) ? IconButton(icon: Icon(Icons.check), iconSize: 35.0, color: Colors.white, onPressed: () => eventProvider.saveEvent()) : Container(),
          (user != null && user.email == Config.admin) ? !(isEdit) ? popupMenuButton(context) : Container() : Container(),
        ]
      ),
      body: _pageBody(context, eventProvider, event.data),
    );
  }

  PopupMenuButton popupMenuButton(BuildContext context) {

    return PopupMenuButton<String>(
      itemBuilder: (context) =>
        Config.menuList.map((e) => PopupMenuItem<String>(value: e, child: Text(e, style: TextStyles.suggestion,))).toList(),
      onSelected: _itemSelected,
    );
  }

  Widget _pageBody(BuildContext context, EventProvider eventProvider, Event event) {
      
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: ListView(children: <Widget>[ 
          SizedBox(height: 20.0,),

          StreamBuilder<String>(
            stream: eventProvider.getImageUrl,
            builder: (context, snapshot) {
              
              if (!snapshot.hasData || snapshot.data == "") {
                return AppButton(labelText: 'Add Image', onPressed: () => eventProvider.pickImage());
              }

              return Column(
                children: <Widget>[
                  Padding(padding: BaseStyles.listPadding,
                  child: Image.network(snapshot.data),
                  ),

                  (isEdit) ? AppButton(labelText: 'Change Image',
                    onPressed: () => eventProvider.pickImage(),
                  ) : Container()
                ],
              );
            }
          ),

          StreamBuilder<String>(
            stream: eventProvider.getName,
            builder: (context, snapshot) {
                
              return AppTextField(
                labelText: 'Title',
                initialText: (event != null && event.name != null) ? event.name : null,
                onChanged: eventProvider.setName,
                errorText: snapshot.error,
                readOnly: !isEdit,
              );
            }
          ),
            
          StreamBuilder<String>(
            stream: eventProvider.getDescription,
            builder: (context, snapshot) {
                
              return AppTextField(
                labelText: 'Enter Description',
                maxLines: 3,
                initialText: (event != null && event.description != null) ? event.description : null,
                onChanged: eventProvider.setDescription,
                errorText: snapshot.error,
                readOnly: !isEdit,
              );
            }
          ),
            
          StreamBuilder<DateTime>(
            stream: eventProvider.getDateTime,
            builder: (context, snapshot) {
              
              return AppDateTimePicker(
                dateLabelText: 'Date & Time', 
                initialValue: (event != null && event.date != null) ? DateTime.parse(event.date) : null,
                onChanged: eventProvider.setDateTime,
                readyOnly: !isEdit,
              );
            }
          ),
        ],
      ),
    );
  }

  void _itemSelected(String item) {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    if (item == Config.edit) {
      setState(() => isEdit = true);
    } else
    if(item == Config.delete) {
      eventProvider.deleteEvent(widget.id).then((value) => Navigator.pop(context));
    }
  }
}