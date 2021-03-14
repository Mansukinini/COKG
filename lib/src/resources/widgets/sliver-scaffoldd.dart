import 'package:cokg/src/areas/screens/event/event-detail.dart';
import 'package:cokg/src/resources/widgets/navigatorBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class AppSliverScaffold {
  static Scaffold materialSliverScaffold({String navTitle, Widget pageBody, Widget bottomNavBar, BuildContext context}) {
    return Scaffold(
      
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[AppNavbar.materialNavBar(title: navTitle, pinned: false)];
        },
        body: pageBody),
        floatingActionButton: FloatingActionButton(onPressed: () {
        // ignore: todo
        // TODO: To be move to home file
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EventDetail()));
        }, child: new Icon(Icons.add),
      ),
        bottomNavigationBar: bottomNavBar,
    );
  }
}