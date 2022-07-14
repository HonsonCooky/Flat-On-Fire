/// Outlines the saved user settings for some user.
class UserModel {
  final String? uid;
  final bool onBoarded;
  final String themeMode;
  final UserProfileModel profile;

  UserModel({
    this.uid,
    required this.themeMode,
    required this.onBoarded,
    required this.profile,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        themeMode = json["themeMode"],
        onBoarded = json["onBoarded"],
        profile = UserProfileModel.fromJson(json["profile"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "themeMode": themeMode,
        "onBoarded": onBoarded,
        "profile": profile.toJson(),
      };
}

/// UserProfileModel outlines the public information of a user
class UserProfileModel {
  final String name;
  final String? avatarPath;

  UserProfileModel({required this.name, this.avatarPath});

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        avatarPath = json["avatarPath"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "avatarPath": avatarPath,
      };
}

class UserFavourite {
  final String body;
  final String? subtitle;
  final String? imagePath;
  final String? contentPath;

  UserFavourite({required this.body, this.subtitle, this.imagePath, this.contentPath});

  UserFavourite.fromJson(Map<String, dynamic> json)
      : body = json["body"],
        subtitle = json["subtitle"],
        imagePath = json["imagePath"],
        contentPath = json["contentPath"];

  Map<String, dynamic> toJson() => {
        "body": body,
        "subtitle": subtitle,
        "imagePath": imagePath,
        "contentPath": contentPath,
      };
}
