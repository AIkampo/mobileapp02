class AllergenModel {
  int? id;
  String? name;
  double? d;
  String? description;
  String? img;
  String? orgname;

  AllergenModel(
      {this.id, this.name, this.d, this.description, this.img, this.orgname});

  AllergenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    d = json['d'];
    description = json['description'];
    img = json['img'];
    orgname = json['orgname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['d'] = this.d;
    data['description'] = this.description;
    data['img'] = this.img;
    data['orgname'] = this.orgname;
    return data;
  }
}
