import 'package:ai_kampo_app/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_report_list.g.dart';


enum AnalysisDeviceType {
  unknown,
  mobile,
  windows,
  kiosk,
}

@JsonSerializable()
class UserReportListData {
  @JsonKey(name: 'pacient_sn')
  int? patientSn;
  String? reseller;
  @JsonKey(name: 'this_mac_sn')
  String? thisMacSn;
  String? oberonMac;
  String? id;
  String? tel1;
  String? active;
  String? name;
  @JsonKey(name: 'testtime', fromJson: yearUntilSecondToDateTime, toJson: dateTimeToYearUntilSecond)
  DateTime? testTime;
  String? sex;
  @JsonKey(name: 'bloodgroup')
  String? bloodGroup;
  String? rhesus;
  @JsonKey(name: 'birthdate')
  String? birthDate;
  String? oberonType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late AnalysisDeviceType deviceType;

  UserReportListData({
    required this.patientSn,
    required this.reseller,
    required this.thisMacSn,
    required this.oberonMac,
    required this.id,
    required this.tel1,
    required this.active,
    required this.name,
    required this.testTime,
    required this.sex,
    required this.bloodGroup,
    required this.rhesus,
    required this.birthDate,
    required this.oberonType,
  }) {
    String typeStr = thisMacSn == null? "unknown": thisMacSn!.split("@")[0];
    if (typeStr == "" || typeStr == "KIOSK") {
      deviceType = AnalysisDeviceType.kiosk;
    }
    else if (typeStr == "MOBILE") {
      deviceType = AnalysisDeviceType.mobile;
    }
    else if (typeStr == "Windows") {
      deviceType = AnalysisDeviceType.windows;
    }
    else {
      deviceType = AnalysisDeviceType.unknown;
    }
  }

  factory UserReportListData.fromJson(Map<String, dynamic> json) =>
    _$UserReportListDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserReportListDataToJson(this);
}
