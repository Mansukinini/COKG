import 'package:cokg/models/Event.dart';
import 'package:cokg/screens/eventdetail.dart';
import 'package:cokg/utils/dbhelper.dart';
import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventListState();
}

class EventListState extends State {
  DbHelper helper = DbHelper();
  List<Event> events;

  @override
  Widget build(BuildContext context) {
    if (events == null) {
      events = List<Event>();
      getData();
    }

    return Scaffold( 
      body: eventListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addEvent();
        },
        
        tooltip: "Add new Event", child: new Icon(Icons.add),
      ),
    );
  }

  ListView eventListItems() {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(child: Text(this.events[0].id.toString()),
            ),
            title: Text(this.events[0].name),
            subtitle: Text(this.events[0].description),
          ),
        );
      },
    );
  }

  void getData() {
    // CollectionReference events = FirebaseFirestore.instance.collection('event');

    // final dbFuture = helper.initializeDatabase();

    // dbFuture.then((result) {
    //   final eventFuture = helper.getEvents();

    //   eventFuture.then((result){
    //     List<Event> eventList = List<Event>();

    //     for(int i = 0; i < result.length; i++) {
    //       eventList.add(Event.fromObject(result[i]));
    //     }

    //     setState(() {
    //       events = eventList;
    //     });
    //   });
    // });
  }
  
  void addEvent() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetail()));
  }
}