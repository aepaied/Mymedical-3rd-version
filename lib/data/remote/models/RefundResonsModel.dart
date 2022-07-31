class RefundResonsModel {
  bool success;
  List<RefundResonsData> data;

  RefundResonsModel({this.success, this.data});

  RefundResonsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<RefundResonsData>();
      json['data'].forEach((v) {
        data.add(new RefundResonsData.fromJson(v));
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

class RefundResonsData {
  int id;
  String resone;

  RefundResonsData({this.id, this.resone});

  RefundResonsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resone = json['resone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['resone'] = this.resone;
    return data;
  }
}