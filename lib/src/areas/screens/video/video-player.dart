 import 'package:cokg/src/areas/models/videos-list.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final VideoItem videoItem;
  const VideoPlayer({ this.videoItem });
 
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
 }
 
 class _VideoPlayerState extends State<VideoPlayer> {
  YoutubePlayerController _controller;
  bool _isPlayerReady;

  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoItem.video.resourceId.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      )
    )..addListener(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.videoItem.video.title),),
      body: Container(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            // print('Player is ready.');
            _isPlayerReady = true;
          },
          
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    _controller.pause();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}