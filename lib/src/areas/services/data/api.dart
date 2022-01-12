import 'dart:io';

import 'package:cokg/src/areas/models/channel-info.dart';
import 'package:cokg/src/config.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;


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
    var http;
    Response response = await http.get(uri, headers: headers);
    print(response.body);

    ChannelInfo channelInfo = channelInfoFromJson(response.body);

    return channelInfo;
  }

}