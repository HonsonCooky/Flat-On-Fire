import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flat_on_fire/models/user_settings_model.dart';

/// Outlines the datastructures of a user stored in firebase. This is PRIVATE to the user.
class UserModel {
  final String? uid;
  final bool isAdmin;
  final ProfileModel profile;
  final UserSettingsModel userSettings;

  UserModel({
    this.uid,
    required this.isAdmin,
    required this.profile,
    required this.userSettings,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        isAdmin = json["isAdmin"],
        profile = ProfileModel.fromJson(json["profile"]),
        userSettings = UserSettingsModel.fromJson(json["userSettings"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "isAdmin": isAdmin,
        "profile": profile.toJson(),
        "userSettings": userSettings.toJson(),
      };
}
