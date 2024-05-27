import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


// TODO: to be deprecated
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
}
