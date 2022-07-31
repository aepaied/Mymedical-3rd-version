class HomeCategoriesModel {
  List<HomeCategoriesData> data;
  bool success;
  int status;

  HomeCategoriesModel({this.data, this.success, this.status});

  HomeCategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<HomeCategoriesData>();
      json['data'].forEach((v) {
        print(v);
        data.add(new HomeCategoriesData.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }
}

class HomeCategoriesData {
  String name;
  String banner;
  String icon;
  Links links;
  int id;

  HomeCategoriesData({this.name, this.banner, this.icon, this.links,this.id});

  HomeCategoriesData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    banner = json['banner'];
    icon = json['icon'];
    id = json['id'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['banner'] = this.banner;
    data['icon'] = this.icon;
    data['id'] = this.id;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class Links {
  String products;
  String subCategories;

  Links({this.products, this.subCategories});

  Links.fromJson(Map<String, dynamic> json) {
    products = json['products'];
    subCategories = json['sub_categories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    data['sub_categories'] = this.subCategories;
    return data;
  }
}