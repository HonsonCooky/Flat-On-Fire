import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';

class GroupService {
  static const groupKey = "groups";
  static const memberKey = "members";

// ----------------------------------------------------------------------------------------------------------------
// PRIVATE ASSISTANT METHODS
// ----------------------------------------------------------------------------------------------------------------

  String _groupPath(String uid) {
    return "$groupKey/$uid";
  }

  String _membersCollection(String uid) {
    return "${_groupPath(uid)}/$memberKey";
  }

  /// Access to the PRIVATE group information
  DocumentReference<GroupModel> _groupDocument(String uid) {
    var path = _groupPath(uid);
    var doc = FirestoreService().getDoc(path);
    return doc.withConverter<GroupModel>(
      fromFirestore: (snapshot, _) => GroupModel.fromJson(snapshot.data()!),
      toFirestore: (settingsModel, _) => settingsModel.toJson(),
    );
  }

// ----------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
// ----------------------------------------------------------------------------------------------------------------

// void createNewGroup({
//   required UserModel owner,
//   required String name,
//   String? avatarLocalFilePath,
//   FirebaseSyncFuncs? syncFuncs,
// }) {
//   _groupDocument().
// }
}
