class VerifiedPhonesModel {
  bool success;
  List<PhonesData> data;

  VerifiedPhonesModel({this.success, this.data});

  VerifiedPhonesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<PhonesData>();
      json['data'].forEach((v) {
        data.add(new PhonesData.fromJson(v));
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

class PhonesData {
  int id;
  String phone;

  PhonesData({this.id, this.phone});

  PhonesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    return data;
  }
}