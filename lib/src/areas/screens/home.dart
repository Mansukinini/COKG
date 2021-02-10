import 'package:cokg/src/areas/screens/event-detail.dart';
import 'package:cokg/src/areas/screens/event-list.dart';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/navigatorBar.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  User user;

  final List<Widget> _children = [
    EventList(),
    Center(child: Text('Groups')),
    Center(child: Text('Sermons'),),
    Center(child: Text('Live'))
  ];

  @override
  void initState() {
    user = _auth.currentUser;
    super.initState();
  }

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

    final authenticate = Provider.of<Authentication>(context);
    
    return Drawer(
      child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundColor: AppColors.lightgray,
            child: Text('V', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          accountName: (user != null) ? Text(user.displayName) : null,
          accountEmail: (user != null) 
          ? Text(user.email) 
          : Text('Log In or Sign Up', style: TextStyles.buttonTextLight),
          onDetailsPressed: (user != null) 
          ? () => Navigator.of(context).pushNamed("/profile/" + user.uid) 
          : () => Navigator.of(context).pushNamed("/login"),
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
          onTap: () { },
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .25),

        AppButton(
          labelText: "Sign out", 
          onPressed: () => authenticate.signOut().then((value){
            if (value != null) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          }),
        ),
        
      ],
      ),
    );
  }
    
  Widget bottomNavigationBar() {
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
          onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}