import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaPlayer extends StatefulWidget {
  final String id;
  MediaPlayer({@required this.id});
  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  bool isPlaying = false; 
  IconData payButton =  Icons.play_arrow;
  AudioPlayer audioPlayer;
  AudioCache audioCache;


  Duration position = new Duration();
  Duration musicLength = new Duration();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer(); 
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.onDurationChanged.listen((Duration d) => setState(() => musicLength = d));

    audioPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));
  }
  
  @override
  Widget build(BuildContext context) {
    var devotionProvider = Provider.of<DevotionRepositry>(context);
    return Container(
      child:  _mediaPlayer(devotionProvider),
    );
  }

  Widget _mediaPlayer(DevotionRepositry devotionProvider) {

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown[200],
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

                _payAndPauseButton(devotionProvider),

                IconButton(iconSize: 45.0,color: Colors.blue, onPressed: () {}, icon: Icon(Icons.skip_next)),
              ]
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder _payAndPauseButton(DevotionRepositry devotionProvider) {

    return FutureBuilder<Devotion>(
      future: devotionProvider.getDevotionById(widget.id),
      builder: (context, snapshot) {

        if (!snapshot.hasData && snapshot.data == null)
          return Center(child: CircularProgressIndicator());
        
        return IconButton(iconSize: 62.0, color: Colors.blue[800],
          onPressed: () async {
            if (!isPlaying) {
              await audioPlayer.play(snapshot.data.url);
              setState(() {
                payButton = Icons.pause;
                isPlaying = true;
              });
            } else {
              audioPlayer.pause();
              setState(() {
                payButton = Icons.play_arrow;
                isPlaying = false;
              });
            }
          },
          icon: Icon(payButton),
        );
      }
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

  Widget slider() {
    
    return Container(
      width: 300.0,
      child: Slider.adaptive(
        activeColor: Colors.blue[800],
        inactiveColor: Colors.grey[350],
        value: position.inSeconds.toDouble(),
        max: musicLength.inSeconds.toDouble(),
        onChanged: (value) => seekToSec(value.toInt())
      ),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
  }
 
  @override
  void dispose() {
   super.dispose();
   audioPlayer.dispose();

    payButton = Icons.play_arrow;
    isPlaying = false;
 }
}