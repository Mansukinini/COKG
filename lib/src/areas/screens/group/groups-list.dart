import 'package:cokg/src/resources/widgets/list-tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.zero,
            child: Image.asset('assets/images/logo0.jpg', fit: BoxFit.cover,))
        ]),

        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
        AppListTile(
          title: 'Cell Group',
          subtitle: 'Prayer and Bible study',
          date: new DateFormat('MMM-dd').format(DateTime.parse('2021-02-20T19:56:07.064407')),
          time: new DateFormat('hh:mm').format(DateTime.parse('2021-02-20T19:56:07.064407')),
        ),
      ],
    );
  }
}