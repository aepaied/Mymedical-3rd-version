class SubSubCategoryModel {
  int id;
  String name;
  String icon;

  SubSubCategoryModel({this.id, this.name, this.icon});

  SubSubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

}