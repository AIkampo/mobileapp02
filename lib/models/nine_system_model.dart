//九大組織系統檢測
class NineSystemModel {
  String? indexName;
  int? score;
  String? name;
  String? meridianName;
  String? img;

  NineSystemModel({
    this.indexName,
    this.score,
    this.name,
    this.meridianName,
    this.img
  });

  NineSystemModel.fromJson(Map<String, dynamic> json) {
    indexName = json['indexName'];
    score = json['score'];
    name = json['name'];
    meridianName = json['meridianName'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['indexName'] = this.indexName;
    data['score'] = this.score;
    data['name'] = this.name;
    data['meridianName'] = this.meridianName;
    data['img'] = this.img;
    return data;
  }
}
