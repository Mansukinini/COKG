import 'package:flutter/material.dart';
import 'package:cokg/screens/eventlist.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
  // List<Event> events = List<Event>();
  // DbHelper helper = DbHelper();
  // helper.initializeDatabase();

  // DateTime today = DateTime.now();
  // Event event = Event("Faith & Imagination", "Talk about faith", today.toString());
  // helper.insertEvent(event);

    return MaterialApp(
      title: 'ChristOurKing Global',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Events', style: optionStyle),
    Text('Index 1: Groups', style: optionStyle),
    Text('Index 2: Sermons', style: optionStyle),
    Text('Index 3: Live', style: optionStyle),
  ];

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
