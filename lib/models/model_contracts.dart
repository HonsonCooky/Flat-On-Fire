/// Dictates the level of authorization some connection between two documents has.
enum Authorization {
  owner,
  write,
  read,
  request,
}

Authorization authFromJson(String s) {
  return Authorization.values.firstWhere((element) => element.name == s);
}
