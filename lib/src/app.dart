import 'package:cokg/src/areas/services/data/database.dart';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/areas/services/providers/event-provider.dart';
import 'package:cokg/src/areas/services/providers/groupProvider.dart';
import 'package:cokg/src/areas/services/providers/userProvider.dart';
import 'package:cokg/src/resources/authorization/authorize-step.dart';
import 'package:cokg/src/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'areas/services/providers/devotionRepositry.dart';


final authentication = Authentication();
final userProvider = UserProvider();
final eventProvider = EventProvider();
final groupProvider = GroupProvider();
final devotionProvider = DevotionRepositry();
final _auth = FirebaseAuth.instance;
// final farebase = DatabaseService();
final authorizeStep = AuthorizeStep();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    
    _auth.authStateChanges().listen((User user) { 
      if (user != null) {
        DatabaseService.getUserById(user.uid).then((userProfile) {
          authorizeStep.setUserProfileAuthorization(userProfile);
        });
      } 
    });

    return MultiProvider(
      providers: [
        Provider(create: (context) => authentication),
        Provider(create: (context) => userProvider),
        Provider(create: (context) => eventProvider),
        Provider(create: (context) => groupProvider),
        Provider(create: (context) => devotionProvider)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        
        home: Home(),
        onGenerateRoute: Routes.materialRoutes,
    ));
  }

  @override 
  void dispose() {
    super.dispose();
    authentication.dispose();
    userProvider.dispose();
    eventProvider.dispose();
    groupProvider.dispose();
    devotionProvider.dispose();
  }
}