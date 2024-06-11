import 'package:json_annotation/json_annotation.dart';

part 'quota.g.dart';


@JsonSerializable()
class UserQuota {
  int monthlyQuota;
  int remainingMonthlyQuota;
  int oneTimeQuota;

  UserQuota({
    required this.monthlyQuota,
    required this.remainingMonthlyQuota,
    required this.oneTimeQuota,
  });

  factory UserQuota.fromJson(Map<String, dynamic> json) =>
    _$UserQuotaFromJson(json);
  Map<String, dynamic> toJson() => _$UserQuotaToJson(this);
}