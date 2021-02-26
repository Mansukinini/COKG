import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

  Future<String> uploadEventImage(File file, String filename) async {
    var storegeRef = await storage.ref()
        .child('eventImages/$filename')
        .putFile(file);

    return await storegeRef.ref.getDownloadURL();
  }

  Future<String> uploadProfileImage(File file, String filename) async {
    var storegeRef = await storage.ref()
        .child('profileImages/$filename')
        .putFile(file);

    return await storegeRef.ref.getDownloadURL();
  }
}