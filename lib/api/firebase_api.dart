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

  static Future<bool> checkPhoneNumberStatus(String phoneNumber) async {
    const int SUB_ACCOUNT = 1;
    const int PREMIUM_USER = 2;
    final res = await usersCollection
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    return res.docs.isEmpty;
  }

  static Future getSubAccounts(String phoneNumber) async {
    final res = await usersCollection
        .where('mainAccount', isEqualTo: phoneNumber)
        .get();
    return res.docs.map((doc) => doc.data()).toList();
  }

  static Future deleteSubAccount(
      String userPhoneNumber, String subAccountPhoneNumber) async {
    final res = await usersCollection
        .where('phoneNumber', isEqualTo: subAccountPhoneNumber)
        .get();
    return await res.docs[0].reference.delete();
  }
}
