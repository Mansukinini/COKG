import 'package:cokg/src/resources/widgets/bottomNaviagtionBar.dart';
import 'package:flutter/material.dart';
import 'package:cokg/src/areas/screens/event-list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChristOurKing Global")),
      body: EventList(),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}