import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAPI {
  static final usersCollection = FirebaseFirestore.instance.collection('/users');

  static final nbcInTcmCollection = FirebaseFirestore.instance.collection('/nbc.in.tcm');
  static final storageUserAvatarRef = FirebaseStorage.instance.ref('userAvatar/');

  static Future addEvaluationRating(
      String phoneNumber, List userRating, DateTime evaluationTime, String type) async {
    return nbcInTcmCollection
        .doc(phoneNumber)
        .collection(evaluationTime.millisecondsSinceEpoch.toString())
        .add({
      "phoneNumber": phoneNumber,
      "rating": userRating,
      'evaluationTime': evaluationTime,
      "type": type
    });
  }

  static Future<Map<String, dynamic>> getUserDataWithDocId(String docId) async {
    return usersCollection
        .doc(docId)
        .get()
        .then((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>);
  }

  static Future<String> getUserAvatarUrl(String phoneNumber) async {
    return await storageUserAvatarRef
        .child('$phoneNumber.jpg')
        .getDownloadURL()
        .catchError((e) => "");
  }

  static Future deleteUserAvatar(String phoneNumber) async {
    return storageUserAvatarRef.child('$phoneNumber.jpg').delete();
  }

  static Future saveUserAvatar({required String phoneNumber, required File? imgFile}) async {
    return await storageUserAvatarRef.child('$phoneNumber.jpg').putFile(imgFile!);
  }

  static Future getUserData(String phoneNumber) async {
    return await usersCollection
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get()
        .then((res) => res.docs.isNotEmpty ? res.docs[0].data() : throw "No User data!")
        .catchError((e) => throw e);
  }

  static Future updateUserData(String docId, Map<String, dynamic> data) async {
    return usersCollection.doc(docId).update(data);
  }

  static Future getUserDocId(String phoneNumber) async {
    return usersCollection.where('phoneNumber', isEqualTo: phoneNumber).get().then((res) {
      return res.docs[0].id;
    }).catchError((e) => throw Exception('無法取得DocId'));
  }

  static Future addUser(Map<String, dynamic> userData) async {
    await usersCollection.add(userData);
  }

  static Future<bool> checkPhoneNumberStatus(String phoneNumber) async {
    final res = await usersCollection.where('phoneNumber', isEqualTo: phoneNumber).get();
    return res.docs.isEmpty;
  }

  static Future getSubAccounts(String phoneNumber) async {
    final res = await usersCollection.where('mainAccountPhoneNumber', isEqualTo: phoneNumber).get();
    return res.docs.map((doc) => doc.data()).toList();
  }

  static Future deleteSubAccount(String userPhoneNumber, String subAccountPhoneNumber) async {
    final res = await usersCollection.where('phoneNumber', isEqualTo: subAccountPhoneNumber).get();
    return await res.docs[0].reference.delete();
  }
}
