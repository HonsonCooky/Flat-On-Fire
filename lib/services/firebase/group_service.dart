import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';

class GroupService {
  static const groupKey = "groups";
// ----------------------------------------------------------------------------------------------------------------
// PRIVATE ASSISTANT METHODS
// ----------------------------------------------------------------------------------------------------------------

  /// Get the path to a groups PRIVATE information.
  String _groupPath(String? uid, String exception) {
    if (uid == null) throw Exception(exception);
    return "$groupKey/$uid";
  }

  /// Get the path to a groups PUBLIC information
  String _groupProfileSubDocPath(String? uid, String exception) {
    return "${_groupPath(uid, exception)}/${FirestoreService().profileSubDocPath(groupKey)}";
  }

  /// Access to the PRIVATE group information
  DocumentReference<GroupModel> _groupDocument() {
    var path = _groupPath("SOME_UID", "Unauthorized access to group information");
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<GroupModel>(
      fromFirestore: (snapshot, _) => GroupModel.fromJson(snapshot.data()!),
      toFirestore: (settingsModel, _) => settingsModel.toJson(),
    );
  }

  /// Access to the PROFILE group information (given a UID, that group will be found)
  DocumentReference<GroupProfileModel> _groupProfileDocument(String uid) {
    var path = _groupProfileSubDocPath(
      uid,
      "Unauthorized access to group information",
    );
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<GroupProfileModel>(
      fromFirestore: (snapshot, _) => GroupProfileModel.fromJson(snapshot.data()!),
      toFirestore: (profileModel, _) => profileModel.toJson(),
    );
  }
// ----------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
// ----------------------------------------------------------------------------------------------------------------

}
