import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cokg/src/areas/services/event-provider.dart';
import 'package:cokg/src/areas/models/Event.dart';

class EventList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return Scaffold( 
      body: StreamBuilder<List<Event>>(
        stream: eventProvider.events,
        builder: (context, event) {
          return ListView.builder(
            itemCount: event.data.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(event.data[index].name),
              subtitle: Text(event.data[index].description),
              onTap: (){},
              );
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addEvent();
        },
        tooltip: "Add new Event", child: new Icon(Icons.add),
      ),
    );
  }

  // Stream<List<Event>> getData()  {
  //   return databaseService.getEvents();
  // }
  
  void addEvent() async {
    // await Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetail()));
  }
}