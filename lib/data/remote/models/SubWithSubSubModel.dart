class SubWithSubSubModel {
  bool success;
  List<SubWithSubSubData> data;

  SubWithSubSubModel({this.success, this.data});

  SubWithSubSubModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<SubWithSubSubData>();
      json['data'].forEach((v) {
        data.add(new SubWithSubSubData.fromJson(v));
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

class SubWithSubSubData {
  int id;
  String name;
  SubSub subSub;

  double widgetHeight = 0;

  SubWithSubSubData({this.id, this.name, this.subSub});

  SubWithSubSubData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subSub =
    json['subSub'] != null ? new SubSub.fromJson(json['subSub']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.subSub != null) {
      data['subSub'] = this.subSub.toJson();
    }
    return data;
  }
}

class SubSub {
  bool viewAll;
  List<SubSubData> data;

  SubSub({this.viewAll, this.data});

  SubSub.fromJson(Map<String, dynamic> json) {
    viewAll = json['viewAll'];
    if (json['data'] != null) {
      data = new List<SubSubData>();
      json['data'].forEach((v) {
        data.add(new SubSubData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['viewAll'] = this.viewAll;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSubData {
  int id;
  String name;
  String icon;

  SubSubData({this.id, this.name, this.icon});

  SubSubData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}