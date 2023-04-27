import 'dart:convert';

class UserModel {
  String username;
  String phoneNumber;
  DateTime birthday;
  String sex;
  String rh;
  String bloodType;
  bool agreeServiceAgreement;
  bool isPremium;
  DateTime? lastSignInDatetime;
  String? mainAccountPhoneNumber;
  DateTime? lastPhysiqueRatingTime;
  bool isMainAccount;
//待加欄位
// 會員效期
// DateTime? premiumExpiration

  UserModel({
    required this.username,
    required this.phoneNumber,
    required this.birthday,
    required this.sex,
    required this.rh,
    required this.bloodType,
    required this.agreeServiceAgreement,
    required this.isPremium,
    this.lastSignInDatetime,
    this.mainAccountPhoneNumber,
    this.lastPhysiqueRatingTime,
    required this.isMainAccount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'phoneNumber': phoneNumber,
      'birthday': birthday.millisecondsSinceEpoch,
      'sex': sex,
      'rh': rh,
      'bloodType': bloodType,
      'agreeServiceAgreement': agreeServiceAgreement,
      'isPremium': isPremium,
      'lastSignInDatetime': lastSignInDatetime?.millisecondsSinceEpoch,
      'mainAccountPhoneNumber': mainAccountPhoneNumber,
      'lastPhysiqueRatingTime': lastPhysiqueRatingTime?.millisecondsSinceEpoch,
      'isMainAccount': isMainAccount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      birthday: DateTime.fromMillisecondsSinceEpoch(map['birthday'] as int),
      sex: map['sex'] as String,
      rh: map['rh'] as String,
      bloodType: map['bloodType'] as String,
      agreeServiceAgreement: map['agreeServiceAgreement'] as bool,
      isPremium: map['isPremium'] as bool,
      lastSignInDatetime: map['lastSignInDatetime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['lastSignInDatetime'] as int)
          : null,
      mainAccountPhoneNumber: map['mainAccountPhoneNumber'] != null
          ? map['mainAccountPhoneNumber'] as String
          : null,
      lastPhysiqueRatingTime: map['lastPhysiqueRatingTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['lastPhysiqueRatingTime'] as int)
          : null,
      isMainAccount: map['isPremium'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
