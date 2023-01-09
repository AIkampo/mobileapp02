import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAPI {
  static final usersCollection =
      FirebaseFirestore.instance.collection('/users');
  static final storageUserAvatarRef =
      FirebaseStorage.instance.ref('userAvatar/');

  static Future<String> getUserAvatarUrl(String phoneNumber) async {
    return await storageUserAvatarRef
        .child('$phoneNumber.jpg')
        .getDownloadURL();
  }

  static Future deleteUserAvatar(String phoneNumber) async {
    return storageUserAvatarRef.child('$phoneNumber.jpg').delete();
  }

  static Future saveUserAvatar(
      {required String phoneNumber, required File? imgFile}) async {
    return await storageUserAvatarRef
        .child('$phoneNumber.jpg')
        .putFile(imgFile!);
  }

  static Future addUser(Map<String, String> userData) async {
    await usersCollection.add(userData);
  }
}
