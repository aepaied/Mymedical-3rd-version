class MyPackageModel {
  bool success;
  MyPackageData data;

  MyPackageModel({this.success, this.data});

  MyPackageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new MyPackageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class MyPackageData {
  int id;
  String name;
  String logo;
  int amount;
  int productUpload;

  MyPackageData({this.id, this.name, this.logo, this.amount, this.productUpload});

  MyPackageData.fromJson(Map<String, dynamic> json) {
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