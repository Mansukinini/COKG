import 'package:cached_network_image/cached_network_image.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/areas/services/providers/event-provider.dart';
import 'package:cokg/src/config.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class EventDetail extends StatefulWidget {
  final String id;
  EventDetail({this.id});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  TextEditingController captionController = TextEditingController();
  var mediaUrl;
  bool isEdit = false;
  bool isUploading = false;

  @override
  Widget build(BuildContext context)  {
    var eventProvider = Provider.of<EventProvider>(context);
   
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 25.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
        title: Center(child: Text('Capture Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0))),
        actions: <Widget>[
          
          TextButton(
            child: Text("Post", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
            onPressed: () {
              eventProvider.createEvent(captionController.text, currentUser.id).whenComplete(() {
                setState(() {
                  captionController.clear();
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
              });
            }
          ),

          // (currentUser != null && currentUser.email == Config.admin) ? !(isEdit) ? popupMenuButton(context) : Container() : Container(),
        ]
      ),
      body: ListView(
          children: <Widget>[
            isUploading ? linearProgress() : Text(''),
        
            ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: (currentUser != null && currentUser.photoUrl != null) ? 
                CachedNetworkImageProvider(currentUser.photoUrl) : AssetImage('assets/images/user.jpg'),
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: captionController,
                  decoration: InputDecoration(hintText: "Write a Caption...", border: InputBorder.none),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 10.0)),

            (mediaUrl == null) ?
            GestureDetector(
              onTap: () => uploadImage(eventProvider),
              child: Container(
                height: 220.0,
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(fit: BoxFit.fitHeight, image: AssetImage('assets/images/upload.jpg'))
                    ),
                  ),
                ),
              )
            ) 
            : handleImageUpload(eventProvider),

            AppButton(
              icon: FaIcon(FontAwesomeIcons.cloudUploadAlt, color: Colors.white),
              labelText: 'Upload Image',
              isAnimatedButton: false, 
              onPressed: () => uploadImage(eventProvider),
            )
          ],
      )
    );
  }

  PopupMenuButton popupMenuButton(BuildContext context) {

    return PopupMenuButton<String>(
      itemBuilder: (context) =>
        Config.menuList.map((e) => PopupMenuItem<String>(value: e, child: Text(e, style: TextStyles.suggestion))).toList(),
      onSelected: _itemSelected,
    );
  }

  void _itemSelected(String item) {
      var eventProvider = Provider.of<EventProvider>(context, listen: false);
      if (item == Config.edit) {
        setState(() => isEdit = true);
      } else
      if(item == Config.delete) {
        eventProvider.deleteEvent(widget.id).then((value) => Navigator.pop(context));
      }
    }

  void uploadImage(EventProvider eventProvider) {
    setState(() {isUploading = true;});

    eventProvider.pickImage().then((result) {
      setState(() {
        mediaUrl = result;
        result = null;
      });
    }).whenComplete(() {
      setState(() { isUploading = false;  });
    });
  }

  handleImageUpload(EventProvider eventProvider) {
    setState(() {
      isUploading = false;
    });

    return GestureDetector(
      onTap: () => uploadImage(eventProvider),
      child: Container(
        height: 220.0,
        width: MediaQuery.of(context).size.width * 0.8,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.fitHeight, image: FileImage(mediaUrl))
            ),
          ),
        ),
      )
    );
  }
}