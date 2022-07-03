import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the datastructures of a user stored in firebase. This is PRIVATE to the user.
class UserModel {
  final String? uid;
  final bool isAdmin;
  final UserProfileModel userProfile;
  final UserSettingsModel userSettings;

  UserModel({
    this.uid,
    required this.isAdmin,
    required this.userProfile,
    required this.userSettings,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        isAdmin = json["isAdmin"],
        userProfile = UserProfileModel.fromJson(json["userProfile"]),
        userSettings = UserSettingsModel.fromJson(json["userSettings"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "isAdmin": isAdmin,
        "userProfile": userProfile.toJson(),
        "userSettings": userSettings.toJson(),
      };
}
