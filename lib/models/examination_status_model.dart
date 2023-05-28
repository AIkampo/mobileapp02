class ExaminationStatusModel {
  bool? success;
  String? data;

  ExaminationStatusModel({this.success, this.data});

  ExaminationStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    return data;
  }
}
