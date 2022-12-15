//九大組織系統檢測
class NineSystemModel {
  int? score;
  String? name;
  String? img;

  NineSystemModel({this.score, this.name, this.img});

  NineSystemModel.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    name = json['name'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['name'] = this.name;
    data['img'] = this.img;
    return data;
  }
}
