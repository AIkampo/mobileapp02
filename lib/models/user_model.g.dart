// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      uid: json['uid'] as String,
      noPhoneUser: json['noPhoneUser'] as bool,
      username: json['username'] as String,
      countryCode: json['countryCode'] as String,
      phoneNumber: json['phoneNumber'] as String,
      birthday: dateTimeFromJson(json['birthday'] as Timestamp?),
      sex: json['sex'] as String,
      rh: json['rh'] as String,
      bloodType: json['bloodType'] as String,
      agreeServiceAgreement: json['agreeServiceAgreement'] as bool,
      isVip: json['isVip'] as bool,
      registerDate: dateTimeFromJson(json['registerDate'] as Timestamp?),
      membershipExpiredDate:
          dateTimeFromJson(json['membershipExpiredDate'] as Timestamp?),
      lastSignInDatetime:
          dateTimeFromJson(json['lastSignInDatetime'] as Timestamp?),
      familyHolder: json['familyHolder'] as String?,
      familyMembers: (json['familyMembers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lastPhysiqueRatingDateTime:
          dateTimeFromJson(json['lastPhysiqueRatingDateTime'] as Timestamp?),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'uid': instance.uid,
      'noPhoneUser': instance.noPhoneUser,
      'username': instance.username,
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'birthday': dateTimeToJson(instance.birthday),
      'sex': instance.sex,
      'rh': instance.rh,
      'bloodType': instance.bloodType,
      'agreeServiceAgreement': instance.agreeServiceAgreement,
      'isVip': instance.isVip,
      'registerDate': dateTimeToJson(instance.registerDate),
      'membershipExpiredDate': dateTimeToJson(instance.membershipExpiredDate),
      'lastSignInDatetime': dateTimeToJson(instance.lastSignInDatetime),
      'familyHolder': instance.familyHolder,
      'familyMembers': instance.familyMembers,
      'lastPhysiqueRatingDateTime':
          dateTimeToJson(instance.lastPhysiqueRatingDateTime),
    };
