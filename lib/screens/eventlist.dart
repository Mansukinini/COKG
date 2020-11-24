import 'package:cokg/models/Event.dart';
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
        onPressed: () {},
        
        tooltip: "Add new Event", child: new Icon(Icons.add),
      ),
    );
  }

  ListView eventListItems() {
    return ListView.builder(
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
    final dbFuture = helper.initializeDatabase();

    dbFuture.then((result) {
      final eventFuture = helper.getEvents();

      eventFuture.then((result){
        List<Event> eventList = List<Event>();

        for(int i = 0; i < result.length; i++) {
          eventList.add(Event.fromObject(result[i]));
          debugPrint(eventList[i].name);
        }

        setState(() {
          events = eventList;
        });
      });
    });
  }
}