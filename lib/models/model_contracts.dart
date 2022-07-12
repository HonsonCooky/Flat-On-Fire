/// Dictates the level of authorization some connection between two documents has.
enum Authorization {
  admin,
  write,
  read,
  request,
}

Map<String, Authorization>? authorizationMapFromJson(Map<String, dynamic>? json) {
  if (json == null || json.isEmpty) return null;
  return json.map((key, value) => MapEntry(key, Authorization.values.firstWhere((e) => e.toString() == value)));
}

Map<String, String>? authorizationMapToJson(Map<String, Authorization>? auths) {
  if (auths == null || auths.isEmpty) return null;
  return auths.map((key, value) => MapEntry(key, value.name));
}
