import 'package:cokg/src/areas/services/reprositories/authentication.dart';
import 'package:cokg/src/areas/services/reprositories/event-provider.dart';
import 'package:cokg/src/route.dart';
import 'package:flutter/material.dart';
import 'package:cokg/src/areas/screens/home.dart';
import 'package:provider/provider.dart';

final authentication = AuthenticationBloc();
final eventProvider = EventProvider();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
  
    return MultiProvider(
      providers: [
        Provider(create: (context) => authentication),
        Provider(create: (context) => eventProvider)
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
    eventProvider.dispose();
  }
}