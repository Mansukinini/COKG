import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/screens/devotion/devotion-detail.dart';
import 'package:cokg/src/areas/screens/devotion/devotion-list.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

 
class DevotionPreview extends StatefulWidget {
  final DevotionList devotion;
   DevotionPreview(this.devotion);

  @override
  State<DevotionPreview> createState() => _DevotionPreviewState();
}

class _DevotionPreviewState extends State<DevotionPreview> {
  
  buildDevotions() {
    
    return StreamBuilder(
      stream: devotionRef.doc(widget.devotion.id).collection('devotionalSeries').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        List<DevotionalSeries> devotionalSeries = [];

        snapshot.data.docs.forEach((doc) {
          devotionalSeries.add(DevotionalSeries.fromDocument(doc));
        });

        return ListView(children: devotionalSeries);
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(widget.devotion.title),
        actions: <Widget>[
          IconButton(
            onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => DevotionDetail(id: widget.devotion.id))),
            icon: Icon(Icons.add, size: 30.0),
          )
        ],
      ),

      body: Column(
        children: [
          Image.asset('assets/images/main.jpg', fit: BoxFit.fitWidth),
          titleSection(),
          Expanded(child: buildDevotions()),
        ],
      ),
    );
  }

  Widget titleSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(widget.devotion.title, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(widget.devotion.description, style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  } 

  Widget buttonSection(BuildContext context){
    Color color = Theme.of(context).primaryColorDark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, FaIcon(FontAwesomeIcons.download, color: Colors.black), 'Download', () {}),
        _buildButtonColumn(color, FaIcon(FontAwesomeIcons.headphones, color: Colors.black), 'Listen', () {}),
        _buildButtonColumn(color, FaIcon(FontAwesomeIcons.share, color: Colors.black), 'SHARE', () {}),
      ],
    );
  } 

  Column _buildButtonColumn(Color color, Widget icon, String label, Function onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(onPressed: onPressed, icon: icon, 
          label: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ), 
      ],
    );
  }
}

class DevotionalSeries extends StatefulWidget {
  final String id;
  final String title;
  final String mediaUrl;
  final int ordinal;
  final String createdBy;
  final Timestamp createdOn;

  DevotionalSeries({
    this.id,
    this.title,
    this.mediaUrl,
    this.ordinal,
    this.createdBy,
    this.createdOn
  });

  factory DevotionalSeries.fromDocument(DocumentSnapshot doc) {

    return DevotionalSeries(
      id: doc.data()["id"],
      title: doc.data()['title'],
      mediaUrl: doc.data()['mediaUrl'],
      ordinal: doc.data()['ordinal'],
      createdBy: doc.data()['createdBy'],
      createdOn: doc.data()['createdOn'],
    );
  }

  @override
  State<DevotionalSeries> createState() => _DevotionalSeriesState(
    id: this.id,
    title: this.title,
    mediaUrl: this.mediaUrl,
    ordinal: this.ordinal,
    createdBy: this.createdBy,
    createdOn: this.createdOn
  );
}

class _DevotionalSeriesState extends State<DevotionalSeries> {
  final String id;
  final String title;
  final String mediaUrl;
  final int ordinal;
  final String createdBy;
  final Timestamp createdOn;

  bool isPlaying = false; 
  IconData payButton =  Icons.play_circle_outline;
  AudioPlayer audioPlayer;
  AudioCache audioCache;
  double currentPlayingPosition = 0;
  double currentPayingDuration = 0;
  dynamic devotionalPlaying;

  _DevotionalSeriesState({
    this.id,
    this.title,
    this.mediaUrl,
    this.ordinal,
    this.createdBy,
    this.createdOn
  });

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer(); 
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.onPlayerError.listen((event) {
      setState(() {
        currentPayingDuration = 0.0;
        currentPlayingPosition = 0.0;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() => currentPlayingPosition = p.inSeconds.toDouble());
    });

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => currentPayingDuration = d.inSeconds.toDouble());
    });

    audioPlayer.onPlayerCompletion.listen((_) {
      devotionalPlaying = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.headphones_rounded, size: 45.0, color: Colors.black),
          title: Text(title, style: TextStyles.title, overflow: TextOverflow.ellipsis),
          trailing: buildPlayAndPauseButton(),
        ),

        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          child: Divider(),
        ),
      ],
    );
  }

  payAndStopButton() {

  }

  buildPlayingContainer() {
    return Column(
      children: <Widget>[
        // Expanded(child: child),

        Container(
          padding: EdgeInsets.all(5.0),
          color: Colors.brown,
          height: 100.0,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () => payAndStopButton(),
                icon: Icon(audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause_circle_outline_outlined : Icons.play_circle_outline_outlined)
              ),

              Expanded(
                child: Slider(
                  value: currentPlayingPosition,
                  min: 0.0,
                  max: currentPayingDuration,
                  onChanged: (double value) {
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                )
              ),

              IconButton(
                icon: Icon(Icons.close_sharp),
                onPressed: () => handleStopPlaying,
              )
            ],
          ),
        )
      ],
    );
  }

  buildPlayAndPauseButton() {
    
    return IconButton(
      icon: Icon(payButton),
      iconSize: 35.0, color: Colors.amber[200],
      onPressed: () => handlePlayAndPause()
    );
  }

  handlePlayAndPause() {
    if (audioCache.fixedPlayer.state == AudioPlayerState.PLAYING){
      audioPlayer.stop();
      setState(() {
        payButton = Icons.play_circle_outline;
        isPlaying = false;
      });
    }

    if (!isPlaying && mediaUrl !=null && audioCache.fixedPlayer.state != AudioPlayerState.PLAYING) {
      audioPlayer.play(mediaUrl, stayAwake: true, respectSilence: true);

      setState(() {
        payButton = Icons.pause_circle_outline_outlined;
        isPlaying = true;
      });
    } else {
      audioPlayer.pause();
      setState(() {
        payButton = Icons.play_circle_outline;
        isPlaying = false;
      });
    }
  }

  void togglePause() {
    setState(() {
      if (audioPlayer.state == AudioPlayerState.PLAYING) {
        audioPlayer.pause();
      } else {
        audioPlayer.resume();
      }
    });
  }

  playDevotional(String url) {
    audioPlayer.stop();
    audioCache.play(url);
    setState(() {
      devotionalPlaying = url;
    }); 
  }

  void stopPlayingDevotion() {
    audioPlayer.stop();
    setState(() {
      devotionalPlaying = null;
    });
  }

  handleStopPlaying() {
    audioPlayer.stop();
  }

  @override
  void dispose() {
    super.dispose();
    audioCache.fixedPlayer.stop();
    audioCache.fixedPlayer.dispose();

    payButton = Icons.play_circle_outline;
    isPlaying = false;
  }
}