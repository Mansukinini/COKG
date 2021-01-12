import 'package:cokg/src/areas/screens/event-detail.dart';
import 'package:cokg/src/areas/screens/event-list.dart';
import 'package:cokg/src/resources/widgets/navigatorBar.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    EventList(),
    Center(child: Text('Groups')),
    Center(child: Text('Sermons'),),
    Center(child: Text('Live'))
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: drawer(context),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[AppNavbar.materialNavBar(title: '', pinned: false)];
        },
        body: _children[_selectedIndex],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventDetail()));
        }, 
        child: new Icon(Icons.add),
      ),
        bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget drawer(BuildContext context) { 
    return Drawer(
      child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // UserAccountsDrawerHeader(
        //   currentAccountPicture: CircleAvatar(
        //     backgroundColor: AppColors.lightgray,
        //     child: Text('V', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold)),
        //   ),
        //   accountName: Text('Visi Mansukinini'),
        //   accountEmail: Text('visi05mansukinini@gmail.com'),
        // ),
        DrawerHeader(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 30.0,
            ),
            title: Text('Name'),
            subtitle: Text('View profile'),
            onTap: () {
              print('login');
              Navigator.of(context).pushNamed("/login");
            },
          ),
          decoration: BoxDecoration(
            color: Colors.deepOrange,
          ),
        ),
        ListTile(
          title: Text('Search', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
          trailing: Icon(Icons.search, size: 35.0, color: Colors.black),
          onTap: () {},
        ),
        ListTile(
          title: Text('Download', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.arrow_circle_down, size: 35.0, color: Colors.black),
          onTap: () { },
        ),
        ListTile(
          title: Text('Inbox', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.inbox_rounded, size: 35.0, color: Colors.black),
          onTap: () {},
        ),
        ListTile(
          title: Text('Giving', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.inbox_sharp, size: 35.0, color: Colors.black),
          onTap: () {},
        ),
        
      ],
      ),
    );
  }
    
  Widget bottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}