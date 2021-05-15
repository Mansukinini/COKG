import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {

  static Future<String> uploadAudio(File file , String filename) async {

    try {
      var storegeRef = await FirebaseStorage.instance.ref()
        .child('audio/$filename' + '.mp3')
        .putFile(file);

      return await storegeRef.ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<String> downloadAudio(String url) async{
    String result = await FirebaseStorage.instance.ref(url).getDownloadURL();
    return result;
  }

  static Future<String> uploadEventImage(File file, String filename) async {
    var storegeRef = await FirebaseStorage.instance.ref()
        .child('eventImages/$filename' + '.mp3')
        .putFile(file);

    return await storegeRef.ref.getDownloadURL();
  }

  static Future<String> uploadProfileImage(File file, String filename) async {
    var storegeRef = await FirebaseStorage.instance.ref()
        .child('profileImages/$filename')
        .putFile(file);

    return await storegeRef.ref.getDownloadURL();
  }
}