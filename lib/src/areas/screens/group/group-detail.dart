import 'package:cokg/src/areas/models/group.dart';
import 'package:cokg/src/areas/services/providers/groupProvider.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config.dart';

class GroupDetail extends StatefulWidget {
    final String id;
  GroupDetail({this.id});
  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    var groupProvider = Provider.of<GroupProvider>(context);

    if (widget.id != null) {
     return _editEvent(context, groupProvider);
    } else {
      return _addEvent(context, groupProvider);
    }
  }

  FutureBuilder _editEvent(BuildContext context, GroupProvider groupProvider) {
    
    return FutureBuilder<Group>(
      future: groupProvider.getGroupById(widget.id),
      builder: (context, group) {

      if (!group.hasData && widget.id != null) 
        return Center(child: CircularProgressIndicator());

      return  _scafford(context, groupProvider, group);
    });
  }

  StreamBuilder _addEvent(BuildContext context, GroupProvider groupProvider) {
     isEdit = true;
    return StreamBuilder<Group>(
      stream: groupProvider.getGroup,
      builder: (context, group) => _scafford(context, groupProvider, group),
    );
  }

  Scaffold _scafford(BuildContext context, GroupProvider groupProvider, AsyncSnapshot<Group> group) {
    var action = group.data != null ? (isEdit) ? "Edit Event" : "" : "Add Event";

    // _setEvent(eventProvider, event.data, widget.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
        title: Center(child: Text(action)),
        actions: <Widget>[
          (isEdit) ? IconButton(icon: Icon(Icons.check), iconSize: 35.0, color: Colors.white, onPressed: () => groupProvider.saveGroup()) : Container(),
          !(isEdit) ? popupMenuButton(context) : Container(),
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
          stream: groupProvider.getImageUrl,
          builder: (context, snapshot) {
            
            if (!snapshot.hasData || snapshot.data == "") {
              return AppButton(labelText: 'Add Image',
                onPressed: () => groupProvider.pickImage(),
              );
            }

            return Column(
              children: <Widget>[
                Padding(padding: BaseStyles.listPadding,
                child: Image.network(snapshot.data),
                ),

                (isEdit) ? AppButton(labelText: 'Change Image',
                  onPressed: () => groupProvider.pickImage(),
                ) : Container()
              ],
            );
          }
        ),   
        StreamBuilder<String>(
          stream: null,
          builder: (context, snapshot) {

            return AppTextField(
              labelText: 'Name',
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
              onChanged: groupProvider.setDescription,
              maxLines: 2,
              readOnly: !isEdit,
            );
          }
        )
    ]);
  }
}