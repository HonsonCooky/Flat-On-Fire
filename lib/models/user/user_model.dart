import 'package:flat_on_fire/_app_bucket.dart';

/// Outlines the saved user settings for some user.
class UserModel {
  final String? uid;
  final bool isAdmin;
  final String themeMode;
  final bool onBoarded;
  final UserProfileModel profile;
  final Map<String, Authorization>? groups;
  final Map<String, Authorization>? tables;

  UserModel({
    this.uid,
    required this.isAdmin,
    required this.themeMode,
    required this.onBoarded,
    required this.profile,
    this.groups,
    this.tables,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        isAdmin = json["isAdmin"],
        themeMode = json["themeMode"],
        onBoarded = json["onBoarded"],
        profile = UserProfileModel.fromJson(json["profile"]),
        groups = authorizationMapFromJson(json["groups"]),
        tables = authorizationMapFromJson(json["tables"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "isAdmin": isAdmin,
        "themeMode": themeMode,
        "onBoarded": onBoarded,
        "profile": profile.toJson(),
        "groups": authorizationMapToJson(groups),
        "tables": authorizationMapToJson(tables),
      };
}
