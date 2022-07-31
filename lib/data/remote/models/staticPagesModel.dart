class StaticPagesModel {
  Data data;
  bool success = false;

  StaticPagesModel({this.data});

  StaticPagesModel.fromJson(Map<String, dynamic> json) {
    // data = json['data'] != null ? new Data.fromJson(json['data']) : null;

    if (json['data'] != null) {
      success = true;
      data = new Data.fromJson(json['data']);
    } else {
      success = false;
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String title;
  String content;
  String cover_photo;
  String site_link;

  Data({this.title, this.content, this.cover_photo});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    cover_photo = json['cover_photo'];
    site_link = json['site_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['cover_photo'] = this.cover_photo;
    data['site_link'] = this.site_link;
    return data;
  }
}
