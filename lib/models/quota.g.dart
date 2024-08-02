// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserQuota _$UserQuotaFromJson(Map<String, dynamic> json) => UserQuota(
      monthlyQuota: (json['monthlyQuota'] as num).toInt(),
      remainingMonthlyQuota: (json['remainingMonthlyQuota'] as num).toInt(),
      oneTimeQuota: (json['oneTimeQuota'] as num).toInt(),
    );

Map<String, dynamic> _$UserQuotaToJson(UserQuota instance) => <String, dynamic>{
      'monthlyQuota': instance.monthlyQuota,
      'remainingMonthlyQuota': instance.remainingMonthlyQuota,
      'oneTimeQuota': instance.oneTimeQuota,
    };
