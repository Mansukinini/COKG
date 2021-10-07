import 'package:cokg/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class AppNavbar {
  static SliverAppBar materialNavBar({@required String title, bool pinned, TabBar tabBar}){
    return SliverAppBar(
      title: Text(title, style: TextStyles.navTitleMaterial),
      backgroundColor: Colors.brown,
      bottom: tabBar,
      floating: true,
      pinned: (pinned == null) ? true : pinned,
      snap: true,
      // actions: <Widget>[menuButton],
      // expandedHeight: 160.0,
      // collapsedHeight: kToolbarHeight+1,
      // flexibleSpace: FlexibleSpaceBar(
      //   background: Image.asset('assets/images/main.jpg', fit: BoxFit.fill)),
    );
  }
}