import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevotionSubPage extends StatefulWidget {
  final String id;
  DevotionSubPage({@required this.id});
  @override
  _DevotionSubPageState createState() => _DevotionSubPageState();
}

class _DevotionSubPageState extends State<DevotionSubPage> {
 //we will need some variables
  bool playing = false; // at the begining we are not playing any song
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon

  //Now let's start by creating our music player
  //first let's declare some object
  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  //we will create a custom slider

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Now let's initialize our player
  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    _player.onDurationChanged.listen((d) {
      setState(() {
        musicLength = d;
      });
    });

    //this function will allow us to move the cursor of the slider while we are playing the song
    _player.onAudioPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    var devotionProvider = Provider.of<DevotionRepositry>(context);
    return Scaffold(
      appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 30.0,
              color: Colors.white,
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
               
                _displayName(),

                SizedBox(height: 30.0),
                
                _mediaPlayer(devotionProvider),
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
              image: AssetImage("assets/images/logo0.jpg"),
            )),
      ),
    );
  }

  Center _displayName() {
    return Center(
      child: Text("Christ Our King Global",
        style: TextStyle(color: Colors.white,fontSize: 32.0,fontWeight: FontWeight.w600,),
      ),
    );
  }

  Widget _mediaPlayer(DevotionRepositry devotionProvider) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _sliderContainer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(iconSize: 45.0, color: Colors.blue,
                  onPressed: () {},
                  icon: Icon(Icons.skip_previous),
                ),

                FutureBuilder<Devotion>(
                  future: devotionProvider.getDevotionById(widget.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                   

                    return IconButton(iconSize: 62.0, color: Colors.blue[800],
                      onPressed: () async {
                        await  _player.play(snapshot.data.url);
                      },
                      icon: Icon(playBtn,),
                    );
                  }
                ),

                IconButton(iconSize: 45.0,color: Colors.blue, onPressed: () {}, icon: Icon(Icons.skip_next),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _sliderContainer() {
    return Container(
      width: 500.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("${position.inMinutes}:${position.inSeconds.remainder(60)}",
            style: TextStyle(fontSize: 18.0),
          ),

          slider(),

          Text("${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
            style: TextStyle(fontSize: 18.0),
          ),

        ],
      ),
    );
  }
}

