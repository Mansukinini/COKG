import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevotionSubPage extends StatefulWidget {
  final String id;
  DevotionSubPage({this.id});
  @override
  _DevotionSubPageState createState() => _DevotionSubPageState();
}

class _DevotionSubPageState extends State<DevotionSubPage> {
  bool isPlaying = false; 
  IconData payButton =  Icons.play_arrow;
  // AudioPlayer _player;
  // AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  @override
  Widget build(BuildContext context) {
    var devotionProvider = Provider.of<DevotionRepositry>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 30.0, color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: _pageBody(context, devotionProvider),
    );
  }

  Widget _pageBody(BuildContext context, DevotionRepositry devotionProvider) {

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.brown[800],
              Colors.brown[200],
            ]),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 48.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: 20.0),
                
                _imageCenter(),
                
                SizedBox(height: 18.0),
               
                _displayTitle("Christ Our King Global"),

                SizedBox(height: 30.0),
                
                // MediaPlayer(id: widget.id),
                // _mediaPlayer(devotionProvider),
              ],
            ),
          ),
    );
  }

  Center _imageCenter() {

    return Center(
      child: Container(
        width: 280.0,
        height: 280.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: DecorationImage(
              image: AssetImage("assets/images/audio.jpg"),
            )),
      ),
    );
  }

  Center _displayTitle(String title) {
    return Center(
      child: Text(title ?? '', style: TextStyle(color: Colors.white, fontSize: 32.0,fontWeight: FontWeight.w600,)),
    );
  }
}

