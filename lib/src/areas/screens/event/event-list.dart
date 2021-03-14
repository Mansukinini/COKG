import 'package:cokg/src/resources/widgets/list-tile.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cokg/src/areas/services/providers/event-provider.dart';
import 'package:cokg/src/areas/models/Event.dart';


class EventList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Stack(children: <Widget>[
            Positioned(child: Image.asset('assets/images/logo0.jpg')),
          ],),flex: 2,
        ),

        Flexible(
          child: StreamBuilder<List<Event>>(
            stream: eventProvider.events,
            builder: (context, event) {
              if (!event.hasData) return Center(child: CircularProgressIndicator());
              
              return ListView.builder(
                itemCount: event.data.length,
                itemBuilder: (context, index) {

                  return AppListTile(
                    id: event.data[index].id,
                    title: event.data[index].name,
                    subtitle: event.data[index].description,
                    imageUrl: event.data[index].imageUrl,
                    date: new DateFormat('MMM-dd').format(DateTime.parse(event.data[index].date)),
                    time: new DateFormat('hh:mm').format(DateTime.parse(event.data[index].date)),
                  );
                }
              );
            },
          ),
          flex: 3,
        )
      ],
    );
  }
}