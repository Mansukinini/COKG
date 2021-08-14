import 'package:flutter/material.dart';

abstract class AppScaffold {
  static Scaffold scaffold(Widget pageBody){
      return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [headerSilverAppBar()],
        body: pageBody
      ),
    );
  }

  static SliverAppBar headerSilverAppBar() {
    return SliverAppBar(
      expandedHeight: 160.0,
      collapsedHeight: kToolbarHeight+1,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset('assets/images/main.jpg', fit: BoxFit.fill)),
    );
  }
}