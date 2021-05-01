import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevotionDetail extends StatefulWidget {
  @override
  _DevotionDetailState createState() => _DevotionDetailState();
}

class _DevotionDetailState extends State<DevotionDetail> {
  
  @override
  Widget build(BuildContext context) {
    var devotionProvider = Provider.of<DevotionRepositry>(context);
    
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),

          title: Center(child: Text("Add devotion")),
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
                devotionProvider.saveDevotion().then((value) => Navigator.of(context).pop());
              }
            )
          ]),
          body: _pageBody(context, devotionProvider),
    );
  }
    
  Widget _pageBody(BuildContext context, DevotionRepositry devotionRepositry) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<String>(
              stream: devotionRepositry.getTitle,
              builder: (context, devotion) {

                return AppTextField(labelText: "Title",
                  onChanged: devotionRepositry.setTitle,
                );
              }
            ),

            StreamBuilder<String>(
              stream: devotionRepositry.getDescription,
              builder: (context, snapshot) {

                return AppTextField(labelText: "Description",
                  maxLines: 2,
                 onChanged: devotionRepositry.setDescription,);
              }
            ),

            AppButton(
              labelText: "Upload Audio file", 
              onPressed: () {
                devotionRepositry.uploadFile();
              }
            ),
          ],
        ),
      );
  }
}


