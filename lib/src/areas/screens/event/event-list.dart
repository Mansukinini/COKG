import 'package:cokg/src/resources/widgets/list-tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cokg/src/areas/services/providers/event-provider.dart';
import 'package:cokg/src/areas/models/Event.dart';

class EventList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              collapsedHeight: kToolbarHeight+1,
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.asset('assets/images/main.jpg', fit: BoxFit.cover)
                  )
                ]
              ),
            )
          ];
        },
        body: _pageBody(context, eventProvider)
      ),
    );
  }

  StreamBuilder<List<Event>> _pageBody(BuildContext context, EventProvider eventProvider) {
    return StreamBuilder<List<Event>>(
      stream: eventProvider.events,
      builder: (context, event) {
        if (!event.hasData) return Center(child: CircularProgressIndicator());
        
        return ListView.builder(
          itemCount: event.data.length,
          itemBuilder: (context, index) {

            return AppListTile(
              title: event.data[index].name,
              subtitle: event.data[index].description,
              imageUrl: event.data[index].imageUrl,
              date: (event.data[index].date != null) ? new DateFormat('MMM-dd').format(DateTime.parse(event.data[index].date)) : null,
              time: (event.data[index].date != null) ? new DateFormat('hh:mm').format(DateTime.parse(event.data[index].date)) : null,
              onTap: () => Navigator.of(context).pushNamed("/eventDetail/${event.data[index].id}")
            );
          }
        );
      },
    );
  }
}