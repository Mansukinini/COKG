import 'package:flutter/material.dart';
import 'package:cokg/screens/eventlist.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // bool _initialized = false;
  // bool _error = false;
  
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        // _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      // setState(() {
      //   _error = true;
      // });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChristOurKing Global'),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(color: Colors.blue)
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              }
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              }
            ),
          ],
          )
      ),
      
      body: EventList(),
      
      bottomNavigationBar: BottomNavigationBar(
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
        onTap: _onItemTapped,
      ),
    );
  }
}