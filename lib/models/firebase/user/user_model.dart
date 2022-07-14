import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the saved user settings for some user.
class UserModel {
  final String? uid;
  final String themeMode;
  final bool onBoarded;
  final UserProfileModel profile;
  final Map<String, ModelConnection<GroupProfileModel>>? groups;

  UserModel({
    this.uid,
    required this.themeMode,
    required this.onBoarded,
    required this.profile,
    this.groups,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        themeMode = json["themeMode"],
        onBoarded = json["onBoarded"],
        profile = UserProfileModel.fromJson(json["profile"]),
        groups = json["groups"]?.map((key, value) => MapEntry(key, ModelConnection.fromJson(value)));

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "themeMode": themeMode,
        "onBoarded": onBoarded,
        "profile": profile.toJson(),
        "groups": groups?.map((key, value) => MapEntry(key, value.toJson())),
      };
}
