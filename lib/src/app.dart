import 'package:cokg/src/areas/services/event-provider.dart';
import 'package:cokg/src/route.dart';
import 'package:flutter/material.dart';
import 'package:cokg/src/areas/screens/home.dart';
import 'package:provider/provider.dart';


class App extends StatelessWidget {
  final eventProvider = EventProvider();
  @override
  Widget build(BuildContext context) {
  
    return MultiProvider(
      providers: [
        Provider(create: (context) => eventProvider)
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        
        home: Home(),
        onGenerateRoute: Routes.materialRoutes,
    ));
  }
}