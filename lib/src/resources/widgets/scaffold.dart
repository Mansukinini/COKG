import 'package:flutter/material.dart';

abstract class AppScaffold {
  static Scaffold scaffold(Widget pageBody){
      return Scaffold(
      body: pageBody
      // body: Container(child: pageBody)
      
      // NestedScrollView(
      //   headerSliverBuilder: (context, _) => [headerSilverAppBar()],
      //   body: Container(child: pageBody)
      // ),
    );
  }

  // static SliverAppBar headerSilverAppBar() {
  //   return SliverAppBar(
  //     expandedHeight: 160.0,
  //     collapsedHeight: kToolbarHeight+1,
  //     flexibleSpace: FlexibleSpaceBar(
  //       background: Image.asset('assets/images/main.jpg', fit: BoxFit.fill)),
  //   );
  // }
}