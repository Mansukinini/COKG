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
  final Widget Function(BuildContext) builder;

  AppListTile({
    @required this.title,
    this.subtitle,
    this.imageUrl,
    this.date,
    this.time,
    this.id,
    this.builder
  });

  @override
  Widget build(BuildContext context) {

    return Card(child: Row(
      children: <Widget>[
          Expanded(
            child:  ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                // backgroundImage: NetworkImage(imageUrl),
              ),
              title: Text(title, style: TextStyles.subtitle,),
              subtitle: Text(subtitle, style: TextStyle(fontSize: 12.0, color: Colors.black),),
              onTap: () {
                if (id != null){
                  Navigator.of(context).pushNamed("/eventDetail/$id");
                }
              },
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
    ));
  }
}