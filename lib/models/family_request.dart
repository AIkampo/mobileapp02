import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ai_kampo_app/utils/utils.dart';
part 'family_request.g.dart';


enum RegisterState {
  @JsonValue("pending")
  pending,
  @JsonValue("accepted")
  accepted,
  @JsonValue("rejected")
  rejected,
}

@JsonSerializable()
class FamilyRequest {
  @JsonKey(defaultValue: "")
  String requestId;
  String familyHolder;
  String countryCode;
  String familyMember;
  String familyMemberPhone;
  RegisterState state;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  DateTime? registerDate;

  FamilyRequest({
    required this.requestId,
    required this.familyHolder,
    required this.countryCode,
    required this.familyMember,
    required this.familyMemberPhone,
    required this.state,
    required this.registerDate,
  });

  factory FamilyRequest.fromJson(Map<String, dynamic> json) =>
    _$FamilyRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyRequestToJson(this);
}