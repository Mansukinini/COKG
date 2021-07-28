import 'package:cokg/src/areas/models/group.dart';
import 'package:cokg/src/areas/services/providers/groupProvider.dart';
import 'package:cokg/src/resources/widgets/list-tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var groupProvider =  Provider.of<GroupProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _){
          return [
            SliverAppBar(
              expandedHeight: 150.0,
              collapsedHeight: kToolbarHeight+1,
              flexibleSpace: FlexibleSpaceBar(background: Image.asset('assets/images/logo0.jpg', fit: BoxFit.fill)),
            )
          ];
        },
        body: _pageBody(context, groupProvider),
      ),
    );
  }

  StreamBuilder<List<Group>> _pageBody(BuildContext context, GroupProvider groupProvider) {
    
    return StreamBuilder<List<Group>>(
      stream: groupProvider.groups(),
      builder: (context, group) {
        if (!group.hasData) return Center(child: CircularProgressIndicator());
        
        return ListView.builder(
          itemCount: group.data.length,
          itemBuilder: (context, index) {

            return AppListTile(
              title: group.data[index].name,
              subtitle: group.data[index].description ?? group.data[index].name,
              imageUrl: group.data[index].imageUrl,
              date: (group.data[index].startDateTime != null) ? new DateFormat('MMM-dd').format(DateTime.parse(group.data[index].startDateTime)) : null,
              time: (group.data[index].endDateTime != null) ? new DateFormat('hh:mm').format(DateTime.parse(group.data[index].endDateTime)) : null,
              onTap: () => Navigator.of(context).pushNamed("/groupDetail/${group.data[index].id}")
            );
          }
        );
      },
    );
  }
}