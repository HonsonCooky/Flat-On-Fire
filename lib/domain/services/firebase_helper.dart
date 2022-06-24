import 'package:cloud_firestore/cloud_firestore.dart';

/// Check If Document Exists
Future<bool> checkIfDocExists(String path) async {
  try {
    var collectionRef = FirebaseFirestore.instance.doc(path);
    var doc = await collectionRef.get();
    print(doc.exists);
    return doc.exists;
  } catch (e) {
    rethrow;
  }
}
