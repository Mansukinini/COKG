import 'package:cokg/src/styles/base.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String date;
  final String time;
  final String id;
  final void Function() onTap;
  final void Function() onLongPress;
  final Widget Function(BuildContext) builder;

  AppListTile({
    @required this.title,
    this.subtitle,
    this.imageUrl,
    this.date = '',
    this.time = '',
    this.id,
    this.onTap,
    this.onLongPress,
    this.builder
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: (imageUrl != null) ? NetworkImage(imageUrl) : AssetImage('assets/images/user.jpg'),
            ),
            title: Text(title, style: TextStyles.subtitle),
            subtitle: Text(subtitle, style: TextStyle(fontSize: 12.0, color: Colors.black),),
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        ), 
         
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(date, style: TextStyle(color: Colors.black, fontSize: 14.0),),
            Text(time, style: TextStyle(color: Colors.black, fontSize: 14.0))
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: BaseStyles.listFieldHorizontal),
          child: Divider(color:AppColors.lightgray),
        ),
        Divider(height: 1, thickness: 1, color: Colors.blueGrey[900])
      ],
    );
  }
}