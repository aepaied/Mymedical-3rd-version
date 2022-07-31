class SliderModel {
  List<SliderData> data;
  bool success;
  int status;

  SliderModel({this.data, this.success, this.status});

  SliderModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<SliderData>();
      json['data'].forEach((v) {
        print(v);
        data.add(new SliderData.fromJson(v));
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

class SliderData {
  String photo;
  String link;

  SliderData({this.photo, this.link});

  SliderData.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['link'] = this.link;
    return data;
  }
}