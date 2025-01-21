class ScoreModel {
  int? id;
  String? name;
  double? d;
  String? description;
  String? img;
  String? orgname;
  String? nameCommon;
  String? title;
  String? gptUrl;

  ScoreModel({
    this.id,
    this.name,
    this.d,
    this.description,
    this.img,
    this.orgname,
    this.nameCommon,
    this.title,
    this.gptUrl,
  });

  ScoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    d = json['d'];
    description = json['description'];
    img = json['img'];
    orgname = json['orgname'];
    nameCommon = json["name_common"];
    title = json["title"];
    gptUrl = json["gpt_url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['d'] = this.d;
    data['description'] = this.description;
    data['img'] = this.img;
    data['orgname'] = this.orgname;
    data["name_common"] = this.nameCommon;
    data["title"] = this.title;
    data["gpt_url"] = this.gptUrl;
    return data;
  }
}
