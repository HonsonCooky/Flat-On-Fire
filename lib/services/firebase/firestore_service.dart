import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flat_on_fire/services/firebase/_firestore_bucket.dart';
import 'package:path_provider/path_provider.dart';

class FirestoreService {
  static const profileSubDoc = "public/profile";

  static avatarFireStorageLoc(String uid) => "fof_avatars/$uid.jpg";
  static avatarTmpLoc(String uid) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    return '$tempPath/$uid.png';
  }

  final UserService userService = UserService();
  final GroupService groupService = GroupService();
  final storageRef = FirebaseStorage.instance.ref();

  static final FirestoreService _firestoreService = FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  FirestoreService._internal();

  static DocumentReference<Map<String, dynamic>> getDoc(String path) {
    return FirebaseFirestore.instance.doc(path);
  }
}
