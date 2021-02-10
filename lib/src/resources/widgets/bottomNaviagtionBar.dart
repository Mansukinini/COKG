import 'package:cokg/src/styles/color.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget{
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.brown,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events'
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Groups'
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over),
              label: 'Sermons'
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.tv),
              label: 'Live'
            ),
          ],

          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: onItemTapped,
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}