import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestItem implements HTTPRequest<Item> {
  final String url;
  const RequestItem({ this.url });
  Future<Item> execute() async {
  // HTTP request
  final response = await http.get(url);
  if (response.statusCode != 200) {
  throw http.ClientException("Oh darn!");
  }
  // Use the model class to make a JSON-to-Item conversion
  return _parseJson(response.body);
  }
  Item _parseJson(String response) => Item.fromJson(jsonDecode(response));
}

class Item {
  static fromJson(jsonDecode) {}

}

abstract class HTTPRequest<T> {
Future<T> execute();
}