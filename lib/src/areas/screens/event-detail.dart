import 'package:cokg/src/areas/services/data/database.dart';
import 'package:cokg/src/styles/base.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/reprositories/event-provider.dart';


class EventDetail extends StatefulWidget {
  // final String id;
  final Event event;
  EventDetail({this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final dbService = DatabaseService();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime dateController;

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context)  {
    final eventProvider = Provider.of<EventProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Center(child: Text("Add Event")),
        actions: <Widget>[
          RaisedButton(
            child: Text('Save', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),),
            color: Theme.of(context).accentColor,
            onPressed: () {
              eventProvider.save();
              Navigator.of(context).pop();
            }, )
        ],
      ),
      body: _pageBody(context, eventProvider),
    );
  }

  Widget _pageBody(BuildContext context, EventProvider eventProvider) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    // Event event;

    if (widget.event != null) {
      // dbService.getEventById(widget.id).then((result) => event = result);

      nameController.text = widget.event.name;
      descriptionController.text = widget.event.description;
      dateController = DateTime.parse(widget.event.date);

      eventProvider.setChanges(widget.event);
    } else {
      eventProvider.setImageUrl(null);
      // eventProvider.date = DateTime.parse('');
      // eventProvider.setChanges(null);
    }
    
    return Padding(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 20.0),
        child: ListView(children: <Widget>[ Column(
          children: <Widget>[
            StreamBuilder<bool>(
              stream: eventProvider.isUploaded,
              builder: (context, isUploaded){
                if (isUploaded.hasData && isUploaded.data == true){
                  CircularProgressIndicator();
                } 
                return Container();
              }
            ),
            StreamBuilder<String>(
              stream: eventProvider.imageUrl,
              builder: (context, event) {
                if (!event.hasData) {
                  return RaisedButton(child: Text('Upload Image'), onPressed: () => eventProvider.pickImage(),);
                }

                return Column(children: <Widget>[
                  Padding(padding: BaseStyles.listPadding, child: Image.network(event.data, height: 300)),
                  RaisedButton(child: Text('Change Image'), onPressed: () => eventProvider.pickImage(),)
                ],);
              },
            ),
            
            TextField(
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: textStyle,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(BaseStyles.borderRadius))
              ),
              style: textStyle,
              controller: nameController,
              onChanged: (String value) => eventProvider.setName(value),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0), 
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(BaseStyles.borderRadius))
                ),
                controller: descriptionController,
                onChanged: (String value) => eventProvider.setDescription(value),
                style: textStyle,
              ),
            ),
            
            StreamBuilder<DateTime>(
              stream: eventProvider.date,
              builder: (context, date) {
              
                if (date.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'yyyy-MM-dd',
                    initialValue: eventProvider.date.toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) {eventProvider.setDate(DateTime.parse(val)); print(val);},
                    validator: (val) {    
                      print(val);
                      return null;
                    }
                    )
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(top:15.0),
                  child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'yyyy-MM-dd',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  onChanged: (val) {eventProvider.setDate(DateTime.parse(val)); print(val);},
                  validator: (val) {    
                    print(val);
                    return null;
                  },
                    // onSaved: (val) => eventProvider.setDate(DateTime.parse(val)),
                  )
                );
              },
            ),
            
            
          ],)
        ],),
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