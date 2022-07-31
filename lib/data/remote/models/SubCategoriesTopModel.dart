class SubCategoriesTopModel {
  bool success;
  List<SubCategoriesTopData> data;

  SubCategoriesTopModel({this.success, this.data});

  SubCategoriesTopModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<SubCategoriesTopData>();
      json['data'].forEach((v) {
        data.add(new SubCategoriesTopData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoriesTopData {
  bool selected = false;
  int id;
  String name;

  SubCategoriesTopData({this.id, this.name});

  SubCategoriesTopData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}