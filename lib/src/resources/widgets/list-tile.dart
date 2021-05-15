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
  final void Function() onTap;
  final void Function() onLongPress;
  final Widget Function(BuildContext) builder;

  AppListTile({
    @required this.title,
    this.subtitle,
    this.imageUrl,
    this.date = '',
    this.time = '',
    this.onTap,
    this.onLongPress,
    this.builder
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: (imageUrl != null) ? NetworkImage(imageUrl) : AssetImage('assets/images/user.jpg'),
              ),
              title: Text(title ?? '', style: TextStyles.title),
              subtitle: Text(subtitle ?? '', style: TextStyles.subtitle),
              onTap: onTap,
              onLongPress: onLongPress,
            ),
          ), 
           
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(date ?? '', style: TextStyles.suggestion),
              Text(time ?? '', style: TextStyles.suggestion)
            ],
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: BaseStyles.listFieldHorizontal),
            child: Divider(color:AppColors.lightgray),
          ),
          Divider(height: 1, thickness: 1, color: Colors.blueGrey[900])
        ],
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26)),
      )
    );
  }
}