import 'dart:io';
import 'package:cokg/src/areas/models/firebase-file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageService {

  static Future<String> uploadImage(imageFile, filename) async {
    TaskSnapshot uploadTask = await FirebaseStorage.instance.ref()
        .child('eventImages/$filename.jpg')
        .putFile(imageFile);

      String downloadUrl = await uploadTask.ref.getDownloadURL();

    return downloadUrl;
  }

  static Future<String> uploadAudio(File file , String filename) async {
     
    try {
      TaskSnapshot uploadAudioTask = await FirebaseStorage.instance.ref()
        .child('audio/$filename' + '.mp3')
        .putFile(file);

        String downloadAudioUrl = await uploadAudioTask.ref.getDownloadURL();

      return downloadAudioUrl;
    } catch (e) {
      return null;
    }
  }

  static Future<void> downloadAudioFromUrl(Reference ref) async {
    // final downloadDir = await getDownloadsDirectory();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    
    File downloadToFile = File('${appDocDir.path}/${ref.name}');
    // print(downloadToFile);
    try {
     await ref.writeToFile(downloadToFile);
      // print('completed');
    } catch (e) {
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

  /*static Future downloadFile(Reference reference) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${reference.name}');

    await reference.writeToFile(file);
  }*/

  static Future<String> uploadEventImage(File file, String filename) async {
    var storegeRef = await FirebaseStorage.instance.ref()
        .child('eventImages/$filename')
        .putFile(file);

    return await storegeRef.ref.getDownloadURL();
  }

  // static Future<String> uploadEventImage(File file, String filename) async {
  //   print('$file uploaded');
  //   var storegeRef = await FirebaseStorage.instance.ref()s
  //       .child('eventImages')
  //       .putFile(file);

  //   return await storegeRef.ref.getDownloadURL();
  // }

  static Future<String> uploadProfileImage(File file, String filename) async {
    var storegeRef = await FirebaseStorage.instance.ref()
        .child('profileImages/$filename')
        .putFile(file);

    return await storegeRef.ref.getDownloadURL();
  }

  static  Future<void> downloadFile(Reference ref, BuildContext context) async {
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);
    
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
      'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
      'at path: ${ref.fullPath} \n'
      'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
    )));
  }
}