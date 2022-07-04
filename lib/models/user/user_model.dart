import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the information maintained in a User Document. 
/// This information is available to everyone. 
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
