import 'package:cokg/src/styles/color.dart';
import 'package:flutter/material.dart';

class AppBottomNavigation extends StatefulWidget{
  @override
  _AppBottomNavigationState createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
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

  int onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    return _selectedIndex;
  }
}