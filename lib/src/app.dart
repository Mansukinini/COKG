import 'package:cokg/src/areas/services/event-provider.dart';
import 'package:flutter/material.dart';
import 'package:cokg/src/areas/screens/home.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    return ChangeNotifierProvider(
      create: (context) => EventProvider(), 
      child:  MaterialApp(
        title: 'ChristOurKing Global',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: Home(),
    ),);
  }
}