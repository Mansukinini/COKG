import 'package:cokg/src/areas/models/group.dart';
import 'package:cokg/src/areas/services/providers/groupProvider.dart';
import 'package:cokg/src/resources/utils/circularProgressIndicator.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/dateTimePicker.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/base.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config.dart';

final _auth = FirebaseAuth.instance;

class GroupDetail extends StatefulWidget {
    final String id;
  GroupDetail({this.id});
  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  bool isEdit = false;
  User user;

  @override
  void initState() {
    user = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var groupProvider = Provider.of<GroupProvider>(context);
    
    if (widget.id != null) {
     return _editGroup(context, groupProvider);
    } else {
      return _addGroup(context, groupProvider);
    }
  }

  FutureBuilder _editGroup(BuildContext context, GroupProvider groupProvider) {
    
    return FutureBuilder<Group>(
      future: groupProvider.getGroupById(widget.id),
      builder: (context, group) {

      if (!group.hasData && widget.id != null) 
        return Center(child: CircularProgressIndicator());

      return  _scafford(context, groupProvider, group);
    });
  }

  StreamBuilder _addGroup(BuildContext context, GroupProvider groupProvider) {
    isEdit = true;
    
    return StreamBuilder<Group>(
      stream: groupProvider.getGroup,
      builder: (context, group) => _scafford(context, groupProvider, group),
    );
  }

  Scaffold _scafford(BuildContext context, GroupProvider groupProvider, AsyncSnapshot<Group> group) {
    var action = group.data != null ? (isEdit) ? "Edit Group" : "" : "Add Group";
    
    groupProvider.setGroup(group.data, widget.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 25.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
        title: Center(child: Text(action, style: TextStyles.navTitle,)),
        actions: <Widget>[
          (isEdit) ? IconButton(icon: Icon(Icons.check), iconSize: 25.0, color: Colors.white, 
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Adding Group ...')));

            await groupProvider.saveGroup().then((value) => Navigator.pop(context));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group Added'), backgroundColor: Colors.green));
          }) : Container(),
          (user != null && user.email == Config.admin) ? !(isEdit) ? popupMenuButton(context) : Container() : Container(),
        ]
      ),
      body: _pageBody(context, groupProvider, group.data),
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
    var groupProvider = Provider.of<GroupProvider>(context, listen: false);
    
    if (item == Config.edit) {
      setState(() => isEdit = true);
    } else
    if(item == Config.delete) {
      groupProvider.deleteGroup(widget.id).then((value) => Navigator.pop(context));
    }
  }

  Widget _pageBody(BuildContext context, GroupProvider groupProvider, Group group) {

    return ListView(children: <Widget>[
        StreamBuilder<String>(
          stream: null,
          builder: (context, snapshot) {

            return AppTextField(
              labelText: 'Name',
              initialText: (group != null && group.name != null) ? group.name : null,
              onChanged: groupProvider.setName,
               readOnly: !isEdit
            );
          }
        ),

        StreamBuilder<String>(
          stream: null,
          builder: (context, snapshot) {

            return AppTextField(
              labelText: 'Description',
              initialText: (group != null && group.description != null) ? group.description : null,
              onChanged: groupProvider.setDescription,
              maxLines: 2,
              readOnly: !isEdit,
            );
          }
        ), 

        StreamBuilder<DateTime>(
          stream: groupProvider.getStartDateTime,
          builder: (context, snapshot) {
            
            return AppDateTimePicker(
              dateLabelText: 'Date & Time', 
              initialValue: (group != null && group.startDateTime != null) ? DateTime.parse(group.startDateTime) : null,
              onChanged: groupProvider.setStartDateTime,
              readyOnly: !isEdit,
            );
          }
        ),

        StreamBuilder<String>(
          stream: groupProvider.getImageUrl,
          builder: (context, snapshot) {
            
            if ((!snapshot.hasData || snapshot.data == "") && isEdit) {
              return AppButton(labelText: 'Add Image',
                onPressed: () => uploadImage(groupProvider),
              );
            }

            return Column(
              children: <Widget>[
                Padding(padding: BaseStyles.listPadding,
                child: snapshot.data != null ? Image.network(snapshot.data) : Container(),
                ),

                (isEdit) ? AppButton(labelText: 'Change Image',
                  onPressed: () => uploadImage(groupProvider),
                ) : Container()
              ],
            );
          }
        ), 
     ]
    );
  }

  void uploadImage(GroupProvider groupProvider) {
    groupProvider.pickImage().whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.loadingSnackBar('Uploading...'));
    });
  }
}