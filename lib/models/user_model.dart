import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ai_kampo_app/utils/utils.dart';
part 'user_model.g.dart';


Map<Gender, String> genderToText = {
  Gender.male: "男",
  Gender.female: "女",
};

Map<BloodType, String> bloodTypeToText = {
  BloodType.O: "O",
  BloodType.A: "A",
  BloodType.B: "B",
  BloodType.AB: "AB",
  BloodType.unknown: "未知",
};

Map<Rhesus, String> rhesusToText = {
  Rhesus.positive: "+",
  Rhesus.negative: "-",
  Rhesus.unknown: "未知",
};

Map<Gender, String> genderToOberonCode = {
  Gender.male: "M",
  Gender.female: "F",
};

Map<BloodType, String> bloodTypeToOberonCode = {
  BloodType.O: "0",
  BloodType.A: "1",
  BloodType.B: "2",
  BloodType.AB: "3",
  BloodType.unknown: "4",
};

Map<Rhesus, String> rhesusToOberonCode = {
  Rhesus.positive: "0",
  Rhesus.negative: "1",
  Rhesus.unknown: "2",
};

enum Gender {
  @JsonValue("M")
  male,
  @JsonValue("F")
  female,
}

enum BloodType {
  @JsonValue("0")
  O,
  @JsonValue("1")
  A,
  @JsonValue("2")
  B,
  @JsonValue("3")
  AB,
  @JsonValue("4")
  unknown,
}

enum Rhesus {
  @JsonValue("0")
  positive,
  @JsonValue("1")
  negative,
  @JsonValue("2")
  unknown,
}

@JsonSerializable()
class UserData {
  String uid;
  bool noPhoneUser;
  String username;
  String countryCode;
  String phoneNumber;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? birthday;
  @JsonKey(name: 'sex')
  Gender gender;
  Rhesus rh;
  BloodType bloodType;
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
    required this.gender,
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
    Gender? newGender,
    Rhesus? newRh,
    BloodType? newBloodType,
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
    if (newGender != null) {
      dataToUpdate["sex"] = genderToOberonCode[newGender];
    }
    if (newRh != null) {
      dataToUpdate["rh"] = rhesusToOberonCode[newRh];
    }
    if (newBloodType != null) {
      dataToUpdate["bloodType"] = bloodTypeToOberonCode[newBloodType];
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
        if (newGender != null) {
          gender = newGender;
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