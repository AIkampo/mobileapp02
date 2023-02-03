class ExaminationModel {
  bool? success;
  bool? data;
  Errors? errors;
  String? type;
  String? title;
  int? status;
  String? traceId;

  ExaminationModel(
      {this.success,
      this.data,
      this.errors,
      this.type,
      this.title,
      this.status,
      this.traceId});

  ExaminationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    errors =
        json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    type = json['type'];
    title = json['title'];
    status = json['status'];
    traceId = json['traceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    if (this.errors != null) {
      data['errors'] = this.errors!.toJson();
    }
    data['type'] = this.type;
    data['title'] = this.title;
    data['status'] = this.status;
    data['traceId'] = this.traceId;
    return data;
  }
}

class Errors {
  List<String>? oberonData;

  Errors({this.oberonData});

  Errors.fromJson(Map<String, dynamic> json) {
    oberonData = json['oberonData'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oberonData'] = this.oberonData;
    return data;
  }
}
