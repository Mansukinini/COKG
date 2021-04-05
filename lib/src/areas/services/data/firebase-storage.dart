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

  // static Future<void> downloadURLAudioFile() async {
  //   String downloadURL = await FirebaseStorage.instance
  //     .ref('audio/2.mp3')
  //     .getDownloadURL();
    
  //   // print('Download ' + downloadURL);
  // }

  // static Future<File> loadFirebase(String url) async {
  //   try {
  //     final audioFile = FirebaseStorage.instance.ref().child(url);
  //     final bytes = await audioFile.getData();

  //     return _storeFile(url, bytes);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // static Future<File> _storeFile(String url, List<int> bytes) async {
  //   final filename = basename(url);
  //   final dir = await getApplicationDocumentsDirectory();

  //   final file = File('${dir.path}/$filename');
  //   await file.writeAsBytes(bytes, flush: true);
  //   return file;
  // }
}