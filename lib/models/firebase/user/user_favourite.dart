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
