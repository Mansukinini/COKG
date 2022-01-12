import 'package:flutter/material.dart';

AppBar header(context, { bool isAppTitle = false, String titleText, removeNackButton = false }) {
  return AppBar(
    automaticallyImplyLeading: removeNackButton ? false : true,
    title: Text(
      isAppTitle ? "ChristOurKing Global" : titleText, 
      style: TextStyle(color: Colors.white, fontFamily: isAppTitle ? "Signatra" : "", fontSize: isAppTitle ? 36.0 : 24.0),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    ),
    centerTitle: true,
    // ignore: deprecated_member_use
    backgroundColor: Theme.of(context).accentColor,
  );
}
