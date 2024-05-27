import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ai_kampo_app/utils/utils.dart';
part 'user_model.g.dart';


@JsonSerializable()
class UserData {
  String uid;
  bool noPhoneUser;
  String username;
  String countryCode;
  String phoneNumber;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? birthday;
  String sex;
  String rh;
  String bloodType;
  bool agreeServiceAgreement;
  bool isVip;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? registerDate;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? membershipExpiredDate;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? lastSignInDatetime;
  String? familyHolder;
  List<String>? familyMembers;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? lastPhysiqueRatingDateTime;
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool get isMainAccount => familyHolder == uid;

  UserData({
    required this.uid,
    required this.noPhoneUser,
    required this.username,
    required this.countryCode,
    required this.phoneNumber,
    required this.birthday,
    required this.sex,
    required this.rh,
    required this.bloodType,
    required this.agreeServiceAgreement,
    required this.isVip,
    required this.registerDate,
    required this.membershipExpiredDate,
    required this.lastSignInDatetime,
    required this.familyHolder,
    required this.familyMembers,
    required this.lastPhysiqueRatingDateTime,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
    _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  Future<String?> updateUserData({
    bool? newAgreeServiceAgreement,
    String? newUsername,
    DateTime? newBirthday,
    String? newSex,
    String? newRh,
    String? newBloodType,
    DateTime? newLastPhysiqueRatingDateTime,
  }) async {
    Map<String, dynamic> dataToUpdate = {};
    if (newAgreeServiceAgreement != null) {
      dataToUpdate["agreeServiceAgreement"] = newAgreeServiceAgreement;
    }
    if (newUsername != null) {
      dataToUpdate["username"] = newUsername;
    }
    if (newBirthday != null) {
      dataToUpdate["birthday"] = dateTimeToJson(newBirthday);
    }
    if (newSex != null) {
      dataToUpdate["sex"] = newSex;
    }
    if (newRh != null) {
      dataToUpdate["rh"] = newRh;
    }
    if (newBloodType != null) {
      dataToUpdate["bloodType"] = newBloodType;
    }
    if (newLastPhysiqueRatingDateTime != null) {
      dataToUpdate["lastPhysiqueRatingDateTime"] =
        dateTimeToJson(newLastPhysiqueRatingDateTime);
    }

    try {
      await FirebaseFirestore.instance.collection('/users')
      .doc(uid)
      .update(dataToUpdate)
      .then((value) {
        if (newAgreeServiceAgreement != null) {
          agreeServiceAgreement = newAgreeServiceAgreement;
        }
        if (newUsername != null) {
          username = newUsername;
        }
        if (newBirthday != null) {
          birthday = newBirthday;
        }
        if (newSex != null) {
          sex = newSex;
        }
        if (newRh != null) {
          rh = newRh;
        }
        if (newBloodType != null) {
          bloodType = newBloodType;
        }
        if (newLastPhysiqueRatingDateTime != null) {
          lastPhysiqueRatingDateTime = newLastPhysiqueRatingDateTime;
        }
      });
    }
    catch(err) {
      return err.toString();
    }
    return null;
  }
}