import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/services/firebase/_firestore_bucket.dart';

class FirestoreService {
  // ----------------------------------------------------------------------------------------------------------------
  // SINGLETON SETUP
  // ----------------------------------------------------------------------------------------------------------------
  static final FirestoreService _firestoreService = FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  FirestoreService._internal();

  // ----------------------------------------------------------------------------------------------------------------
  // COMMON COMPONENTS
  // ----------------------------------------------------------------------------------------------------------------
  
  final UserService userService = UserService();
  final GroupService groupService = GroupService();

  DocumentReference<Map<String, dynamic>> getDoc(String path) {
    return FirebaseFirestore.instance.doc(path);
  }
}
