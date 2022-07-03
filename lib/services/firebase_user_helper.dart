import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flat_on_fire/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const userCollectionName = "users";
const profileCollectionName = "profiles";



Future<DocumentSnapshot<UserModel>>? getUser(BuildContext context) {
  try {
    var userInfo = context.read<AuthService>().userInfo();
    return userInfo.getCacheFirst();
  } catch (_) {
    return null;
  }
}
