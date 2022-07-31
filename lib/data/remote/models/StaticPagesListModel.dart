class StaticPagesListModel {
  bool success;
  List<PageData> data;

  StaticPagesListModel({this.success, this.data});

  StaticPagesListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<PageData>();
      json['data'].forEach((v) {
        data.add(new PageData.fromJson(v));
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

class PageData {
  int id;
  String title;
  String icon;

  PageData({this.id, this.title, this.icon});

  PageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['icon'] = this.icon;
    return data;
  }
}