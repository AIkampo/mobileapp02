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
      gender: $enumDecode(_$GenderEnumMap, json['sex']),
      rh: $enumDecode(_$RhesusEnumMap, json['rh']),
      bloodType: $enumDecode(_$BloodTypeEnumMap, json['bloodType']),
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
      'sex': _$GenderEnumMap[instance.gender]!,
      'rh': _$RhesusEnumMap[instance.rh]!,
      'bloodType': _$BloodTypeEnumMap[instance.bloodType]!,
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

const _$GenderEnumMap = {
  Gender.male: 'M',
  Gender.female: 'F',
};

const _$RhesusEnumMap = {
  Rhesus.positive: '0',
  Rhesus.negative: '1',
  Rhesus.unknown: '2',
};

const _$BloodTypeEnumMap = {
  BloodType.O: '0',
  BloodType.A: '1',
  BloodType.B: '2',
  BloodType.AB: '3',
  BloodType.unknown: '4',
};
