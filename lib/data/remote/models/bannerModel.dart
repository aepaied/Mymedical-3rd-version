class BannerModel {
  List<BannerData> data;
  bool success;
  int status;

  BannerModel({this.data, this.success, this.status});

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<BannerData>();
      json['data'].forEach((v) {
        data.add(new BannerData.fromJson(v));
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

class BannerData {
  String photo;
  String url;
  int position;

  BannerData({this.photo, this.url, this.position});

  BannerData.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    url = json['url'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['url'] = this.url;
    data['position'] = this.position;
    return data;
  }
}