import 'package:flutter/material.dart';

class AppFloatingActionButton extends StatelessWidget {
  final int tapNo;
  
  AppFloatingActionButton({
    this.tapNo 
  });

  @override
  Widget build(BuildContext context) {
    print(tapNo.toString());
    switch(tapNo) {
      case 0:
        return FloatingActionButton(child: Icon(Icons.add), onPressed:() => Navigator.of(context).pushNamed("/eventDetail"));
      case 1:
        return FloatingActionButton(child: Icon(Icons.add), onPressed:() => Navigator.of(context).pushNamed("/groupDetail"));
      case 2:
        return FloatingActionButton(child: Icon(Icons.add), onPressed:() => Navigator.of(context).pushNamed("/SermonDetail"));
      case 3:
        return FloatingActionButton(child: Icon(Icons.add), onPressed:() => Navigator.of(context).pushNamed("/groupDetail"));

      default:
        return FloatingActionButton(child: Icon(Icons.add), onPressed:() => Navigator.of(context).pushNamed("/login"));
    }
  }
}