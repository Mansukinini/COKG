import 'dart:io';
import 'package:cokg/src/areas/models/firebase-file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageService {

  static Future<String> uploadAudio(File file , String filename) async {

    try {
      var storegeRef = await FirebaseStorage.instance.ref()
        .child('audio/$filename' + '.mp3')
        .putFile(file);

      return await storegeRef.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> downloadAudioFromUrl(Reference ref) async {
    print(ref);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    
    File downloadToFile = File('${appDocDir.path}/${ref.name}');
    print(downloadToFile);
    try {
     await ref.writeToFile(downloadToFile);
      print('completed');
    } catch (e) {
      print(e);
     }
  }

  static Future<List<FirebaseFile>> downloadAudio(String url) async{
    final ref = FirebaseStorage.instance.ref(url);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);
    
    return urls.asMap().map((index, url) {
      final file = FirebaseFile(ref: result.items[index], name: ref.name, url: url);
      return MapEntry(index, file);
    }).values.toList();
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) {
    return Future.wait(refs.map((e) => e.getDownloadURL()).toList());
  }

  static Future downloadFile(Reference reference) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${reference.name}');

    await reference.writeToFile(file);
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