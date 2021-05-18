import 'package:cokg/src/areas/screens/devotion/devotion-list.dart';
import 'package:cokg/src/areas/screens/event/event-list.dart';
import 'package:cokg/src/areas/screens/group/groups-list.dart';
import 'package:cokg/src/areas/screens/home/profile.dart';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/utils/floatingActionButton.dart';
import 'package:cokg/src/resources/widgets/navigatorBar.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app-state.dart';
import '../../../config.dart';

final _auth = FirebaseAuth.instance; 
final appState = AppState();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  User user;

  final List<Widget> _children = [
    EventList(),
    GroupList(),
    DevotionList(),
    Profile()
    // Center(child: Text('Live'))
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
          return <Widget>[AppNavbar.materialNavBar(title: '', pinned: false, menuButton: popupMenuButton(context))];
        },
        body: _children[_selectedIndex]
      ),
      floatingActionButton: (user.email == Config.admin) ? AppFloatingActionButton(tapNo: _selectedIndex) : null,
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget drawer(BuildContext context) { 

    return Drawer(
      child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundColor: AppColors.lightgray,
            backgroundImage: (user != null) ? NetworkImage(user.photoURL) : AssetImage('assets/images/user.jpg'),
          ),

          accountName: (user != null) ? Text(user.displayName) : null,
          accountEmail: (user != null) 
          ? Text(user.email) 
          : Text('Log In or Sign Up', style: TextStyles.body),
          
          onDetailsPressed: (user != null) 
          ? () => Navigator.of(context).pushNamed("/profile/" + user.uid) 
          : () => Navigator.of(context).pushNamed("/login"),
        ),
        
        ListTile(
          title: Text('ChristOurKing', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.home_max_outlined, size: 35.0, color: Colors.black),,
          onTap: () => Navigator.pushNamed(context, '/home'),
        ),

        ListTile(
          leading: Icon(Icons.arrow_circle_down, size: 35.0, color: Colors.black),
          title: Text('Download', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          onTap: () { },
        ),

        ListTile(
          title: Text('Inbox', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.inbox_rounded, size: 35.0, color: Colors.black),
          onTap: () {},
        ),

        ListTile(
          title: Text('Giving', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.favorite_border, size: 35.0, color: Colors.black),
          onTap: () { },
        ),

        ListTile(
          title: Text('About', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.info_outline, size: 35.0, color: Colors.black),
          onTap: () => Navigator.pushNamed(context, '/about'),
        ),

        (user != null) ? ListTile(
          title: Text('Sign Out', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.exit_to_app, size: 35.0, color: Colors.black),
          onTap: () => Navigator.pushNamed(context, '/home'),
        ) : ListTile(
          title: Text('Sign In', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.reset_tv_outlined, size: 35.0, color: Colors.black),
          onTap: () => Navigator.pushNamed(context, '/login'),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .18),

        Padding(
          padding: const EdgeInsets.only(top:12.0, left: 10.0, right: 25.0, bottom: 15.0),
          child: Text('Version 0.0.1', textAlign: TextAlign.right, style: TextStyle(fontSize: 13.0)),
        )
      ]),
    );
  }
    
  Widget bottomNavigationBar() {
    
    return BottomNavigationBar(
      backgroundColor: AppColors.brown,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_rounded),
              label: 'Events'
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Groups'
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over),
              label: 'Devotion'
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile'
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

  PopupMenuButton popupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return Config.homeBarList.map((e) => PopupMenuItem<String>(value: e, child: Text(e),)).toList();
      },
      onSelected: _itemSelected,
    );
  }

  void _itemSelected(String item) {
    var auth = Provider.of<Authentication>(context, listen: false);

    if (item == Config.signOut) {
      auth.signOut().then((value) =>
        Navigator.pushReplacementNamed(context, '/home'));
    } 
  }
}