

class AllBrandsModel {
  List<BrandsData> data;
  bool success;
  int status;

  AllBrandsModel({this.data, this.success, this.status});

  AllBrandsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<BrandsData>();
      json['data'].forEach((v) {
        data.add(new BrandsData.fromJson(v));
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

class BrandsData {
  int id;
  String name;
  String logo;
  Links links;

  BrandsData({this.id, this.name, this.logo, this.links});

  BrandsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class Links {
  String products;

  Links({this.products});

  Links.fromJson(Map<String, dynamic> json) {
    products = json['products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    return data;
  }
}