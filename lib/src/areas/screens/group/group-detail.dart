import 'package:cokg/src/resources/widgets/list-tile.dart';
import 'package:cokg/src/styles/base.dart';
import 'package:flutter/material.dart';

class GroupDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(children: <Widget>[
          Padding(
            padding: BaseStyles.listPadding,
            child: Image.asset('assests/images/logo0.jpg'))
        ]),

      
      ],
    );
  }
}