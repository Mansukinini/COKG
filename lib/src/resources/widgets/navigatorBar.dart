import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class AppNavbar {
  static SliverAppBar materialNavBar({@required String title, bool pinned, TabBar tabBar}){
    return SliverAppBar(
      title: Text(title, style: TextStyles.navTitleMaterial),
      backgroundColor:  AppColors.orange,
      bottom: tabBar,
      floating: true,
      pinned: (pinned == null) ? true : pinned,
      snap: true,
    );
  }
}