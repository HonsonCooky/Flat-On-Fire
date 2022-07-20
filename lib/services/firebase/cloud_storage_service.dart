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
  // PRIVATE HELPERS
  // ----------------------------------------------------------------------------------------------------------------

  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> _avatarLocalLoc(String subFolder, String uid) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String appDirPath = appDir.path;
    return '$appDirPath/$subFolder/$uid/avatar.jpg';
  }

  String avatarFireStorageLoc(String subFolder, String uid) => "$subFolder/$uid/avatar.jpg";

  Future<File> _urlToFile(String imageUrl, String subFolder, String uid) async {
    var file = File(await _avatarLocalLoc(subFolder, uid));
    http.Response response = await http.get(Uri.parse(imageUrl));
    file.createSync(recursive: true);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  // ----------------------------------------------------------------------------------------------------------------
  // GET AVATAR
  // ----------------------------------------------------------------------------------------------------------------

  /// Get the file pointer to some avatar in the Firebase Storage.
  /// [subFolder] and [uid] are used to identify the avatar.
  /// [cacheOnly] is false by default, but if set to true, only the local file will be searched for.
  Future<File?> getAvatarFile({required String subFolder, required String uid, bool cacheOnly = false}) async {
    // Get local file
    var imageFile = await _getLocalAvatarFile(subFolder: subFolder, uid: uid);
    if (imageFile.existsSync()) return imageFile;
    if (cacheOnly) return null;
    return _getCloudAvatarFile(subFolder: subFolder, uid: uid);
  }

  Future<File> _getLocalAvatarFile({required String subFolder, required String uid}) async {
    return File(await _avatarLocalLoc(subFolder, uid));
  }

  Future<File?> _getCloudAvatarFile({required String subFolder, required String uid}) async {
    try {
      var path = avatarFireStorageLoc(subFolder, uid);
      var url = await _storageRef.child(path).getDownloadURL();
      var file = await _urlToFile(url, subFolder, uid);
      return file;
    } catch (e) {
      return null;
    }
  }

  // ----------------------------------------------------------------------------------------------------------------
  // SET AVATAR
  // ----------------------------------------------------------------------------------------------------------------

  /// Set an avatar file locally and in the cloud.
  /// [subFolder] and [uid] are used to identify the avatar.
  /// [imagePath] is used for instances where the user has selected and image to use.
  /// [imageUrl] is used for instances where a URL is provided.
  Future setAvatarFile({
    required String subFolder,
    required String uid,
    String? imagePath,
    String? imageUrl,
  }) async {
    File file;
    if (imagePath != null) {
      file = await _setAvatarFileLocalFromPath(subFolder: subFolder, uid: uid, imagePath: imagePath);
    } else if (imageUrl != null) {
      file = await _urlToFile(imageUrl, subFolder, uid);
    } else {
      throw Exception("Unable to save avatar without a reference");
    }

    await _setAvatarFileCloud(subFolder: subFolder, uid: uid, file: file);
  }

  Future<File> _setAvatarFileLocalFromPath({
    required String subFolder,
    required String uid,
    required String imagePath,
  }) async {
    var image = File(imagePath);
    var saveLoc = File(await _avatarLocalLoc(subFolder, uid));
    saveLoc.createSync(recursive: true);
    await saveLoc.writeAsBytes(image.readAsBytesSync());
    return saveLoc;
  }

  Future _setAvatarFileCloud({required String subFolder, required String uid, required File file}) async {
    await _storageRef.child(avatarFireStorageLoc(subFolder, uid)).putFile(file);
  }

  // ----------------------------------------------------------------------------------------------------------------
  // DELETE AVATAR
  // ----------------------------------------------------------------------------------------------------------------

  /// Delete an avatar file locally and in the cloud.
  /// [subFolder] and [uid] are used to identify the avatar.
  Future deleteAvatarFile({
    required String subFolder,
    required String uid,
  }) async {
    var localAvatar = File(await _avatarLocalLoc(subFolder, uid));
    if (localAvatar.existsSync()) localAvatar.delete(recursive: true);

    var path = avatarFireStorageLoc(subFolder, uid);
    await _storageRef.child(path).delete();
  }
}
