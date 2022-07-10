import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CloudStorageService {
  // ----------------------------------------------------------------------------------------------------------------
  // SINGLETON SETUP
  // ----------------------------------------------------------------------------------------------------------------
  static final CloudStorageService _cloudStorageService = CloudStorageService._internal();

  factory CloudStorageService() {
    return _cloudStorageService;
  }

  CloudStorageService._internal();

  // ----------------------------------------------------------------------------------------------------------------
  // COMMON COMPONENTS
  // ----------------------------------------------------------------------------------------------------------------

  final storageRef = FirebaseStorage.instance.ref();

  String avatarFireStorageLoc(String subFolder, String uid) => "fof_avatars/$subFolder/$uid.jpg";

  Future<String> avatarLocalLoc(String subFolder, String uid) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String appDirPath = appDir.path;
    return '$appDirPath/$subFolder/$uid.png';
  }

  Future<File> urlToFile(String imageUrl, String subFolder, String uid) async {
    var file = File(await CloudStorageService().avatarLocalLoc(subFolder, uid));
    http.Response response = await http.get(Uri.parse(imageUrl));
    file.createSync(recursive: true);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
}
