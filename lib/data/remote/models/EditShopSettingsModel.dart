class EditShopSettingsModel {
  ShopData shop;

  EditShopSettingsModel({this.shop});

  EditShopSettingsModel.fromJson(Map<String, dynamic> json) {
    shop = json['shop'] != null ? new ShopData.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    return data;
  }
}

class ShopData {
  int id;
  int userId;
  String nameEn;
  String logo;
  List<String> sliders;
  String addressEn;
  String facebook;
  String google;
  String twitter;
  String youtube;
  String slug;
  String metaTitleEn;
  String metaDescriptionEn;
  String nameAr;
  String metaTitleAr;
  String metaDescriptionAr;
  String addressAr;
  String pickUpPointId;
  String shippingCost;
  String createdAt;
  String updatedAt;

  ShopData(
      {this.id,
        this.userId,
        this.nameEn,
        this.logo,
        this.sliders,
        this.addressEn,
        this.facebook,
        this.google,
        this.twitter,
        this.youtube,
        this.slug,
        this.metaTitleEn,
        this.metaDescriptionEn,
        this.nameAr,
        this.metaTitleAr,
        this.metaDescriptionAr,
        this.addressAr,
        this.pickUpPointId,
        this.shippingCost,
        this.createdAt,
        this.updatedAt});

  ShopData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    nameEn = json['name_en'];
    logo = json['logo'];
    sliders = json['sliders'].cast<String>();
    addressEn = json['address_en'];
    facebook = json['facebook'];
    google = json['google'];
    twitter = json['twitter'];
    youtube = json['youtube'];
    slug = json['slug'];
    metaTitleEn = json['meta_title_en'];
    metaDescriptionEn = json['meta_description_en'];
    nameAr = json['name_ar'];
    metaTitleAr = json['meta_title_ar'];
    metaDescriptionAr = json['meta_description_ar'];
    addressAr = json['address_ar'];
    pickUpPointId = json['pick_up_point_id'];
    shippingCost = json['shipping_cost'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name_en'] = this.nameEn;
    data['logo'] = this.logo;
    data['sliders'] = this.sliders;
    data['address_en'] = this.addressEn;
    data['facebook'] = this.facebook;
    data['google'] = this.google;
    data['twitter'] = this.twitter;
    data['youtube'] = this.youtube;
    data['slug'] = this.slug;
    data['meta_title_en'] = this.metaTitleEn;
    data['meta_description_en'] = this.metaDescriptionEn;
    data['name_ar'] = this.nameAr;
    data['meta_title_ar'] = this.metaTitleAr;
    data['meta_description_ar'] = this.metaDescriptionAr;
    data['address_ar'] = this.addressAr;
    data['pick_up_point_id'] = this.pickUpPointId;
    data['shipping_cost'] = this.shippingCost;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}