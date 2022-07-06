import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/services/firebase/_firestore_bucket.dart';

class FirestoreService {
  final UserService userService = UserService();
  static final FirestoreService _firestoreService = FirestoreService._internal();
  
  
  factory FirestoreService() {
    return _firestoreService;
  }
  
  FirestoreService._internal();
  
  static DocumentReference<Map<String, dynamic>> getDoc(String path) {
    return FirebaseFirestore.instance.doc(path);
  }
}

