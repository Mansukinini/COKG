import 'package:cached_network_image/cached_network_image.dart';
import 'package:cokg/src/areas/models/channel-info.dart';
import 'package:cokg/src/areas/models/videos-list.dart';
import 'package:cokg/src/areas/screens/video/video-player.dart';
import 'package:cokg/src/areas/services/data/api.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/resources/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  YoutubePlayerController _controller;
  bool _isPlayerReady;
  bool isAreaPlaying = true;
  ChannelInfo channelInfo;
  VideosList _videosList;
  Item item;
  bool loading = false;
  String _playListId;
  String _nextPageToken;
  ScrollController _scrollController;
  String videoTitle;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;

  @override
  void initState() {
    super.initState();
    loading = true;
    _nextPageToken = '';
    _videosList = VideosList();
    _videosList.videos = [];
    _scrollController = ScrollController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    getChannelInfo();

    _isPlayerReady = false;
  }

  getChannelInfo() async {
    channelInfo = await Api.getChannelInfo();
    item = channelInfo.items[0];
    _playListId = item.contentDetails.relatedPlaylists.uploads;
    await loadVideos();
    setState(() {
      loading = false;
    });
  }

  loadVideos() async {
    VideosList tempVideosList = await Api.getVideosList(playListId: _playListId, pageToken: _nextPageToken);

    _nextPageToken = tempVideosList.nextPageToken;
    _videosList.videos.addAll(tempVideosList.videos);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: header(context, titleText: 'YouTube'),
  // isAreaPlaying ? header(context, titleText: loading ? 'Loading...' : 'YouTube') : null,
      body: Column(
        children: <Widget>[
          // Flexible(
          //   flex: 2,
          //   child: isAreaPlaying ?
          //     buildInfoView()
          //     : Container(
          //         child: Column(
          //           children: <Widget>[
          //             Expanded(
          //               child: YoutubePlayer(
          //                 controller: _controller,
          //                 showVideoProgressIndicator: true,
          //                 onReady: () {
          //                   print('Player is ready.');
          //                   _isPlayerReady = true;
          //                 },
          //               ),
          //             ),
          //           ],
          //         )
          //   ),
          // ),
          SizedBox(width: 20.0),
          Flexible(flex: 3, child: buildVideosContent()),
        ],
      ),
    );
  }

  buildInfoView() {
    return loading
      ? circularProgress()
      : Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(20.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(backgroundImage: CachedNetworkImageProvider(item.snippet.thumbnails.medium.url)),
                  SizedBox(width: 20.0),
                  Expanded(child: Text(item.snippet.title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400))),
                  Text(item.statistics.videoCount),
                  SizedBox(width: 20.0),
                ],
              ),
            ),
          ),
        );
  }

  Container buildVideosContent() {

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollNotification notification) {
          if (_videosList.videos.length >= int.parse(item.statistics.videoCount)) 
            return true;

          if (notification.metrics.pixels == notification.metrics.maxScrollExtent) 
            loadVideos();

          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _videosList.videos.length,
          itemBuilder: (context, index) {
            VideoItem videoItem = _videosList.videos[index];

        
            return GestureDetector(
              onTap: () async {
                // if (!isAreaPlaying) {
                //   print(videoItem.video.);
                // }

                setState(() {
                  isAreaPlaying = false;
                  videoTitle = videoItem.video.title;
                });
                
                // youTubeVideosController(videoItem);
                Navigator.push(context,MaterialPageRoute(builder: (context) => VideoPlayer(videoItem: videoItem)));
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Image.network(videoItem.video.thumbnails.thumbnailsDefault.url),
                    SizedBox(width: 20.0),
                    Flexible(child: Text(videoItem.video.title)),
                    SizedBox(width: 20.0),
                  ],
                )
              ),
            );
          }
        ),
      )
    );
  }

  youTubeVideosController(VideoItem videoItem) {
    print(videoItem.video.resourceId.videoId);

    _controller = YoutubePlayerController(
      initialVideoId: videoItem.video.resourceId.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      )
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    if (!isAreaPlaying)
      _controller.pause();
  }

  @override
  void dispose() {
    super.dispose();
    if (!isAreaPlaying)
      _controller.dispose();
  }
}