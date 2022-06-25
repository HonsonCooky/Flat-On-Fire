import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_on_fire/_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<DocumentSnapshot<UserModel>> getFutureUser(BuildContext context) {
  var user = context.read<AuthProvider>().user!;
  var userInfo = context.read<AuthProvider>().userInfo(user.uid).withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (UserModel userModel, _) => userModel.toJson(),
      );
  return userInfo.get(const GetOptions(source: Source.cache));
}
