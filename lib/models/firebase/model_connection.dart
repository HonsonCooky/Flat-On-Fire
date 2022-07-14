import 'package:flat_on_fire/_app_bucket.dart';

class ModelConnection<T> {
  final Authorization level;
  final T profile;

  ModelConnection(this.level, this.profile);

  ModelConnection.fromJson(Map<String, dynamic> json)
      : level = authFromJson(json["level"]),
        profile = (T as dynamic).fromJson(json["profile"]);

  Map<String, dynamic> toJson() => {
        "level": level.name,
        "profile": (profile as dynamic).toJson(),
      };
}
