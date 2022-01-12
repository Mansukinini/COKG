import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/screens/home/drawer/activity-feed.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  @override
  void initState() {
    super.initState();
    // handleSearch();
  }

  handleSearch() async{
    
    // Future<QuerySnapshot> users = userRef.where('username', isGreaterThanOrEqualTo: query).get();
    QuerySnapshot users = await userRef.get();
    setState(() {
      // searchResultsFuture = users;
    });
    return users;
  }

  void clearSearch() {
    searchController.clear();
  }
  
  AppBar buildSearchField() {

    return AppBar(
      leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.brown)),
      backgroundColor: Colors.white,
      title: Text("Members", style: TextStyle(color: Colors.brown),)
      // TextFormField(
      //   decoration: InputDecoration(hintText: "Search for a user...", filled: true,
      //     prefixIcon: Icon(Icons.account_box, size: 28.0),
      //     suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: clearSearch)
      //   ),
      //   // onFieldSubmitted: handleSearch,
      // ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[

            SvgPicture.asset('assets/images/search.svg', 
              height: orientation == Orientation.portrait ? 300.0 : 200.0),

            Text('Find Users', textAlign: TextAlign.center, style: 
              TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0
              )
            )
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    
    return FutureBuilder(
      future: handleSearch(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return circularProgress();

        List<UserResult> searchResults = [];
        snapshot.data.docs.forEach((doc) {
          AuthUser user = AuthUser.fromDocument(doc);
          searchResults.add(UserResult(user));
        });

        return ListView(children: searchResults);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.withOpacity(0.8),
      appBar: buildSearchField(),
      body: handleSearch() == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final AuthUser user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}