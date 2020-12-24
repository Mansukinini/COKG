import 'package:cokg/src/areas/screens/event-detail.dart';
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

          return event.data.length > 0 ? ListView.builder(
            itemCount: event.data.length,
            itemBuilder: (context, index) {

              return Card(color: Colors.white, elevation: 2.0, 
                child: ListTile(title: Text(event.data[index].name),
                subtitle: Text(event.data[index].description),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventDetail(event: event.data[index])));
                }),
              );
            }
          ) : null;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add or Edit Event 
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EventDetail()));
        },
        tooltip: "Add new Event", child: new Icon(Icons.add),
      ),
    );
  }
}