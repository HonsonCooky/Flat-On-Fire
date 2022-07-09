import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';

class GroupService {
// ----------------------------------------------------------------------------------------------------------------
// CONSTANT VALUES
// ----------------------------------------------------------------------------------------------------------------

  final groupCollectionName = "groups";
  final groupProfileCollectionName = "group_profiles";

// ----------------------------------------------------------------------------------------------------------------
// PRIVATE ASSISTANT METHODS
// ----------------------------------------------------------------------------------------------------------------

  /// Get the path to a groups PRIVATE information.
  String _groupPath(String? uid, String exception) {
    if (uid == null) throw Exception(exception);
    return "$groupCollectionName/$uid";
  }

  /// Get the path to a groups PUBLIC information
  String _groupProfilePath(String? uid, String exception) {
    if (uid == null) throw Exception(exception);
    return "$groupProfileCollectionName/$uid";
  }

  /// Access to the PRIVATE group information
  DocumentReference<GroupModel> _groupModelDocument(String uid) {
    var doc = FirestoreService.getDoc(_groupPath(
      uid,
      "Unauthorized access to group information",
    ));
    return doc.withConverter<GroupModel>(
      fromFirestore: (snapshot, _) => GroupModel.fromJson(snapshot.data()!),
      toFirestore: (groupModel, _) => groupModel.toJson(),
    );
  }

  /// Access to the PUBLIC group information (given a UID, that group will be found)
  DocumentReference<GroupProfileModel> groupProfileDocument(String uid) {
    var path = _groupProfilePath(
      uid,
      "Unauthorized access to group information",
    );
    var doc = FirestoreService.getDoc(path);
    return doc.withConverter<GroupProfileModel>(
      fromFirestore: (snapshot, _) => GroupProfileModel.fromJson(snapshot.data()!),
      toFirestore: (profileModel, _) => profileModel.toJson(),
    );
  }
}
