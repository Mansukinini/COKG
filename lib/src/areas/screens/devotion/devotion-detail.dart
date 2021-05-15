import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config.dart';

final _auth = FirebaseAuth.instance;

class DevotionDetail extends StatefulWidget {
  final String id;
  DevotionDetail({this.id});
  @override
  _DevotionDetailState createState() => _DevotionDetailState();
}

class _DevotionDetailState extends State<DevotionDetail> {
  bool isEdit = false;
  User user;

  @override
  void initState() {
    user = _auth.currentUser;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var devotionProvider = Provider.of<DevotionRepositry>(context);

    if (widget.id != null) {
     return _editDevotion(context, devotionProvider);
    } else {
      return _addDevotion(context, devotionProvider);
    }
  }

  FutureBuilder _editDevotion(BuildContext context, DevotionRepositry devotionProvider) {
    
    return FutureBuilder<Devotion>(
      future: devotionProvider.getDevotionById(widget.id),
      builder: (context, devotion) {

      if (!devotion.hasData && widget.id != null) 
        return Center(child: CircularProgressIndicator());

      return  _scafford(context, devotionProvider, devotion);
    });
  }

  StreamBuilder _addDevotion(BuildContext context, DevotionRepositry devotionProvider) {
    isEdit = true;
    
    return StreamBuilder<Devotion>(
      stream: devotionProvider.getDevotion,
      builder: (context, devotion) => _scafford(context, devotionProvider, devotion),
    );
  }

  Scaffold _scafford(BuildContext context, DevotionRepositry devotionProvider, AsyncSnapshot<Devotion> devotion) {
    var action = devotion.data != null ? (isEdit) ? "Edit Devotion" : "" : "Add Devotion";
    
    devotionProvider.setDevotion(devotion.data, widget.id);

    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
        title: Center(child: Text(action, style: TextStyles.navTitle)),
          actions: <Widget>[
            // ignore: deprecated_member_use
            (isEdit) ? RaisedButton(
              child: Text('Cancel', style: TextStyles.actionText),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.of(context).pop()
            ) : Container(),

            // ignore: deprecated_member_use
            (isEdit) ? RaisedButton(
            child: Text('Save', style: TextStyles.actionText),
            color: Theme.of(context).accentColor,
            onPressed: () => devotionProvider.saveDevotion().then((value) => Navigator.of(context).pop())
            ) : Container(),
            (user.email == Config.admin) ? !(isEdit) ? popupMenuButton(context) : Container() : Container(),
          ]),
          body: _pageBody(context, devotionProvider, devotion.data),
    );
  }

  PopupMenuButton popupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return Config.menuList.map((e) => PopupMenuItem<String>(value: e, child: Text(e),)).toList();
      },
      onSelected: _itemSelected,
    );
  }

  void _itemSelected(String item) {
    var devotionProvider = Provider.of<DevotionRepositry>(context, listen: false);
    
    if (item == Config.edit) {
      setState(() => isEdit = true);
    } else
    if(item == Config.delete) {
      devotionProvider.deleteDevotion(widget.id).then((value) => Navigator.pop(context));
    }
  }
    
  Widget _pageBody(BuildContext context, DevotionRepositry devotionRepositry, Devotion devotion) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<String>(
              stream: devotionRepositry.getTitle,
              builder: (context, snapshots) {

                return AppTextField(labelText: "Title",
                  readOnly: !isEdit,
                  initialText: devotion != null ? devotion.title : null,
                  onChanged: devotionRepositry.setTitle,
                );
              }
            ),

            StreamBuilder<String>(
              stream: devotionRepositry.getDescription,
              builder: (context, snapshot) {

                return AppTextField(labelText: "Description",
                  maxLines: 2,
                  readOnly: !isEdit,
                  onChanged: devotionRepositry.setDescription,
                  initialText: devotion != null ? devotion.description : null
                );
              }
            ),

            (isEdit) ? AppButton(
              labelText: "Upload Audio file", 
              onPressed: () => devotionRepositry.uploadFile()
            ) : Container(),
          ],
        ),
      );
  }
}


