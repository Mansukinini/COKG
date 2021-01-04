import 'package:cokg/src/areas/screens/event-detail.dart';
import 'package:cokg/src/resources/widgets/sliver-scaffoldd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cokg/src/areas/services/event-provider.dart';
import 'package:cokg/src/areas/models/Event.dart';


class EventList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return AppSliverScaffold.materialSliverScaffold(
      navTitle: 'Event', pageBody: _pageBody(context)
    );
    // return Scaffold( 
    //   body: _pageBody(context),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       // Add or Edit Event 
    //       Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => EventDetail()));
    //     },
    //     child: new Icon(Icons.add),
    //   ),
    // );
  }

  Widget _pageBody(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    // return NestedScrollView(
    //   // headerSliverBuilder: ,
    // );
    return StreamBuilder<List<Event>>(
        stream: eventProvider.events,
        builder: (context, event) {
          if (!event.hasData) return Center(child: CircularProgressIndicator());
          
          return ListView.builder(
            itemCount: event.data.length,
            itemBuilder: (context, index) {

              return Card(color: Colors.white, elevation: 2.0, 
                child: ListTile(
                  title: Text(event.data[index].name),
                  subtitle: Text(event.data[index].description),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventDetail(event: event.data[index])));
                }),
              );
            }
          );
        },
      );
  }
}