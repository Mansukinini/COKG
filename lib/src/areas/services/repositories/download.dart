import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart'; //as firebase_storage;

class Download {
  Future<void> downloadFile(Reference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;

    final File tempFile = File('${systemTempDir.path}/tmp.jpg');

    if (tempFile.existsSync()) {
      await tempFile.delete();
    }

    await tempFile.create();
    final Reference task = ref.writeToFile(tempFile) as Reference;

    //final int byteCount = (await task.future).totalByteCount;

    var bodyBytes = downloadData.bodyBytes;
    final String name = ref.name;
    final String path = ref.fullPath;
    
    // _scaffoldKey.currentState.showSnackBar(
    //   SnackBar(
    //     backgroundColor: Colors.white,
    //     content: Image.memory(
    //       bodyBytes,
    //       fit: BoxFit.fill,
    //     ),
    //   ),
    // );
  }

  //  Future<void> _downloadFile1(firebase_storage.Reference ref) async {
  //   final Directory systemTempDir = Directory.systemTemp;
  //   final File tempFile = File('${systemTempDir.path}/temp-${ref.name}');
  //   if (tempFile.existsSync()) await tempFile.delete();

  //   await ref.writeToFile(tempFile);

  //   Scaffold.of(context).showSnackBar(SnackBar(
  //       content: Text(
  //     'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
  //     'at path: ${ref.fullPath} \n'
  //     'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
  //   )));
  // }
}