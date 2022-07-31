class AllShopsModel {
  List<ShopData> data;
  bool success;
  int status;

  AllShopsModel({this.data, this.success, this.status});

  AllShopsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ShopData>();
      json['data'].forEach((v) {
        data.add(new ShopData.fromJson(v));
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

class ShopData {
  int id;
  String name;
  String logo;
  List<String> sliders;
  String address;
  String facebook;
  String google;
  String twitter;
  String youtube;
  String instagram;
  int verificationStatus;
  ShopUser user;
  ShopLinks links;

  ShopData(
      {this.id,
      this.name,
      this.logo,
      this.sliders,
      this.address,
      this.facebook,
      this.google,
      this.twitter,
      this.youtube,
      this.instagram,
      this.verificationStatus,
      this.user,
      this.links});

  ShopData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    sliders =json['sliders'] != null? json['sliders'].cast<String>(): null;
    address = json['address'];
    facebook = json['facebook'];
    google = json['google'];
    twitter = json['twitter'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    verificationStatus = json['verification_status'];
    user = json['user'] != null ? new ShopUser.fromJson(json['user']) : null;
    links =
        json['links'] != null ? new ShopLinks.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['sliders'] = this.sliders;
    data['address'] = this.address;
    data['facebook'] = this.facebook;
    data['google'] = this.google;
    data['twitter'] = this.twitter;
    data['youtube'] = this.youtube;
    data['instagram'] = this.instagram;
    data['verification_status'] = this.verificationStatus;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class ShopUser {
  String name;
  String email;
  String avatar;
  String avatarOriginal;

  ShopUser({this.name, this.email, this.avatar, this.avatarOriginal});

  ShopUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    avatarOriginal = json['avatar_original'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['avatar_original'] = this.avatarOriginal;
    return data;
  }
}

class ShopLinks {
  String featured;
  String top;
  String new_;
  String all;

  ShopLinks({this.featured, this.top, this.new_, this.all});

  ShopLinks.fromJson(Map<String, dynamic> json) {
    featured = json['featured'];
    top = json['top'];
    new_ = json['new'];
    all = json['all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['featured'] = this.featured;
    data['top'] = this.top;
    data['new'] = this.new_;
    data['all'] = this.all;
    return data;
  }
}
