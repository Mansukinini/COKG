import 'package:cokg/src/resources/widgets/list-tile.dart';
import 'package:cokg/src/resources/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cokg/src/areas/services/providers/event-provider.dart';
import 'package:cokg/src/areas/models/event.dart';

class EventList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return AppScaffold.scaffold(pageBody(eventProvider));
  }
  
  StreamBuilder<List<Event>> pageBody(EventProvider eventProvider) {

    return StreamBuilder<List<Event>>(
      stream: eventProvider.events,
      builder: (context, event) {
        if (!event.hasData) return Center(child: CircularProgressIndicator());
        
        return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text('SliverAppBar'),
              background: Image.asset('assets/images/main.jpg', fit: BoxFit.fill),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {

                return AppListTile(
                  title: event.data[index].name,
                  subtitle: event.data[index].description ?? event.data[index].name,
                  imageUrl: event.data[index].imageUrl,
                  date: (event.data[index].date != null) ? new DateFormat('MMM-dd').format(DateTime.parse(event.data[index].date)) : null,
                  time: (event.data[index].date != null) ? new DateFormat('hh:mm').format(DateTime.parse(event.data[index].date)) : null,
                  onTap: () => Navigator.of(context).pushNamed("/eventDetail/${event.data[index].id}")
                );
              },
              childCount: event.data.length,
            ),
          ),
        ],
      ); 
    });
  }
}