import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the datastructures of a user stored in firebase. This is PRIVATE to the user. 
class UserModel {
  final String uid;
  final bool isAdmin;
  final ProfileModel profile;

  UserModel(this.uid, this.isAdmin, this.profile);

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        isAdmin = json["isAdmin"],
        profile = ProfileModel.fromJson(json["profile"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "isAdmin": isAdmin,
        "profile": profile.toJson(),
      };
}