// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyRequest _$FamilyRequestFromJson(Map<String, dynamic> json) =>
    FamilyRequest(
      requestId: json['requestId'] as String? ?? '',
      familyHolder: json['familyHolder'] as String,
      countryCode: json['countryCode'] as String,
      familyMember: json['familyMember'] as String,
      familyMemberPhone: json['familyMemberPhone'] as String,
      state: $enumDecode(_$RegisterStateEnumMap, json['state']),
      registerDate: dateTimeFromJson(json['registerDate'] as Timestamp?),
    );

Map<String, dynamic> _$FamilyRequestToJson(FamilyRequest instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'familyHolder': instance.familyHolder,
      'countryCode': instance.countryCode,
      'familyMember': instance.familyMember,
      'familyMemberPhone': instance.familyMemberPhone,
      'state': _$RegisterStateEnumMap[instance.state]!,
      'registerDate': dateTimeToJson(instance.registerDate),
    };

const _$RegisterStateEnumMap = {
  RegisterState.pending: 'pending',
  RegisterState.accepted: 'accepted',
  RegisterState.rejected: 'rejected',
};
