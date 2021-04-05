import 'package:cokg/src/app.dart';
import 'package:cokg/src/areas/services/providers/groupProvider.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var groupProvider = Provider.of<GroupProvider>(context);
    
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),

          title: Center(child: Text("Add Groups")),
          actions: <Widget>[
            // ignore: deprecated_member_use
            RaisedButton(
              child: Text('Cancel', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.of(context).pop()
            ),

            // ignore: deprecated_member_use
            RaisedButton(
              child: Text('Save', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)),
              color: Theme.of(context).accentColor,
              onPressed: () {
                groupProvider.save().then((value) => Navigator.of(context).pop());
              }
            )
          ]),
          body: _pageBody(context),
    );
  }
  Widget _pageBody(BuildContext context) {
    return ListView(
      children: <Widget>[
            Column(
              children: <Widget>[
              
              
            ]),

            StreamBuilder<String>(
              stream: null,
              builder: (context, snapshot) {

                return AppTextField(
                  labelText: 'Name',
                  onChanged: groupProvider.setName,
                );
              }
            ),

            StreamBuilder<String>(
              stream: null,
              builder: (context, snapshot) {

                return AppTextField(
                  labelText: 'Description',
                  onChanged: groupProvider.setDescription,
                  maxLines: 2,
                );
              }
            )
    ]);
  }
}