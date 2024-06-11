// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserQuota _$UserQuotaFromJson(Map<String, dynamic> json) => UserQuota(
      monthlyQuota: json['monthlyQuota'] as int,
      remainingMonthlyQuota: json['remainingMonthlyQuota'] as int,
      oneTimeQuota: json['oneTimeQuota'] as int,
    );

Map<String, dynamic> _$UserQuotaToJson(UserQuota instance) => <String, dynamic>{
      'monthlyQuota': instance.monthlyQuota,
      'remainingMonthlyQuota': instance.remainingMonthlyQuota,
      'oneTimeQuota': instance.oneTimeQuota,
    };
