import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/screens/event-detail.dart';
import 'package:cokg/src/areas/services/event-provider.dart';
import 'package:cokg/src/resources/widgets/bottomNaviagtionBar.dart';
import 'package:cokg/src/resources/widgets/sliver-scaffoldd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return AppSliverScaffold.materialSliverScaffold(
      navTitle: 'Events', pageBody: _pageBody(context), 
      bottomNavBar: BottomNavigation(),
      context: context 
    );
  }

  Widget _pageBody(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
      
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Stack(children: <Widget>[
            Positioned(child: Image.asset('assests/images/cokg.PNG')),
            // Positioned(child: GestureDetector(child: Container(),),)
          ],),flex: 2,
        ),

        Flexible(
          child:StreamBuilder<List<Event>>(
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
                    },
                    leading: CircleAvatar(backgroundImage: NetworkImage(event.data[index].imageUrl),)
                    ,
                    )
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