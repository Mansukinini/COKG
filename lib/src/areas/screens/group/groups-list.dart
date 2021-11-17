import 'package:cokg/src/areas/models/group.dart';
import 'package:cokg/src/areas/services/providers/groupProvider.dart';
import 'package:cokg/src/resources/widgets/list-tile.dart';
import 'package:cokg/src/resources/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var groupProvider =  Provider.of<GroupProvider>(context);

    return AppScaffold.scaffold(_pageBody(groupProvider)); 
  }

  StreamBuilder<List<Group>> _pageBody(GroupProvider groupProvider) {

    return StreamBuilder<List<Group>>(
      stream: groupProvider.groups(),
      builder: (context, group) {
        if (!group.hasData) return Center(child: CircularProgressIndicator());
        
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
                    title: group.data[index].name,
                    subtitle: group.data[index].description ?? group.data[index].name,
                    imageUrl: group.data[index].imageUrl,
                    date: (group.data[index].startDateTime != null) ? new DateFormat('MMM-dd').format(DateTime.parse(group.data[index].startDateTime)) : null,
                    time: (group.data[index].endDateTime != null) ? new DateFormat('hh:mm').format(DateTime.parse(group.data[index].endDateTime)) : null,
                    onTap: () => Navigator.of(context).pushNamed("/groupDetail/${group.data[index].id}")
                  );
                },
                childCount: group.data.length,
              ),
            ),
          ],
        ); 
      }
    );
  }
}