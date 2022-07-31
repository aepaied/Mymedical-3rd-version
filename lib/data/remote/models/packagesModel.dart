class PackagesModel {
  bool success;
  List<PackagesData> data;

  PackagesModel({this.success, this.data});

  PackagesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<PackagesData>();
      json['data'].forEach((v) {
        data.add(new PackagesData.fromJson(v));
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

class PackagesData {
  int id;
  String name;
  String logo;
  int amount;
  int productUpload;

  PackagesData({this.id, this.name, this.logo, this.amount, this.productUpload});

  PackagesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    amount = json['amount'];
    productUpload = json['product_upload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['amount'] = this.amount;
    data['product_upload'] = this.productUpload;
    return data;
  }
}