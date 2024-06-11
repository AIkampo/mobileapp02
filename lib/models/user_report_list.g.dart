// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_report_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReportListData _$UserReportListDataFromJson(Map<String, dynamic> json) =>
    UserReportListData(
      patientSn: json['pacient_sn'] as int?,
      reseller: json['reseller'] as String?,
      thisMacSn: json['this_mac_sn'] as String?,
      oberonMac: json['oberonMac'] as String?,
      id: json['id'] as String?,
      tel1: json['tel1'] as String?,
      active: json['active'] as String?,
      name: json['name'] as String?,
      testTime: yearUntilSecondToDateTime(json['testtime'] as String),
      sex: json['sex'] as String?,
      bloodGroup: json['bloodgroup'] as String?,
      rhesus: json['rhesus'] as String?,
      birthDate: json['birthdate'] as String?,
      oberonType: json['oberonType'] as String?,
    );

Map<String, dynamic> _$UserReportListDataToJson(UserReportListData instance) =>
    <String, dynamic>{
      'pacient_sn': instance.patientSn,
      'reseller': instance.reseller,
      'this_mac_sn': instance.thisMacSn,
      'oberonMac': instance.oberonMac,
      'id': instance.id,
      'tel1': instance.tel1,
      'active': instance.active,
      'name': instance.name,
      'testtime': dateTimeToYearUntilSecond(instance.testTime),
      'sex': instance.sex,
      'bloodgroup': instance.bloodGroup,
      'rhesus': instance.rhesus,
      'birthdate': instance.birthDate,
      'oberonType': instance.oberonType,
    };
