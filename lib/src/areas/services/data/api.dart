import 'dart:io';

import 'package:cokg/src/areas/models/channel-info.dart';
import 'package:cokg/src/areas/models/videos-list.dart';
import 'package:cokg/src/config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class Api {
  static const CHANNEL_ID = 'UCMy1MSdGwpzWLDxX_yj9GuQ';
  static const _baseUrl = 'youtube.googleapis.com';


  static Future<ChannelInfo> getChannelInfo() async {
    Map<String, String> parameters = {
      'part': 'snippet,contentDetails,statistics',
      'id': CHANNEL_ID,
      'key': Config.API_KEY,
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/channels', parameters);
  
    Response response = await http.get(uri, headers: headers);

    ChannelInfo channelInfo = channelInfoFromJson(response.body);

    return channelInfo;
  }

  static Future<VideosList> getVideosList({String playListId, String pageToken}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playListId,
      'maxResults': '8',
      'pageToken': pageToken,
      'key': Config.API_KEY,
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/playlistItems', parameters);
  
    Response response = await http.get(uri, headers: headers);
    
    VideosList videosList = videosListFromJson(response.body);
    return videosList;
  }
}