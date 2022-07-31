import 'dart:convert';

class AddsProductsModel {
  bool success;
  List<AddsProductsData> data;

  AddsProductsModel({this.success, this.data});

  AddsProductsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<AddsProductsData>();
      json['data'].forEach((v) {
        data.add(new AddsProductsData.fromJson(v));
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

class AddsProductsData {
  int id;
  String name;
  int published;
  int status;
  String addedBy;
  int userId;
  int categoryId;
  int subcategoryId;
  int subsubcategoryId;
  int brandId;
  List<String> photos;
  String thumbnailImg;
  String location;
  String videoProvider;
  String videoLink;
  String unit;
  String conditon;
  String tagsEn;
  String tagsAr;
  String descriptionEn;
  int unitPrice;
  int unitDiscount;
  String metaTitleEn;
  String metaDescriptionEn;
  String metaImg;
  String pdf;
  String slugEn;
  String descriptionAr;
  String slugAr;
  String metaTitleAr;
  String metaDescriptionAr;
  String createdAt;
  String updatedAt;
  String country;
  String phone;
  bool isFavorite;

  AddsProductsData(
      {this.id,
      this.name,
      this.published,
      this.status,
      this.addedBy,
      this.userId,
      this.categoryId,
      this.subcategoryId,
      this.subsubcategoryId,
      this.brandId,
      this.photos,
      this.thumbnailImg,
      this.location,
      this.phone,
      this.videoProvider,
      this.videoLink,
      this.unit,
      this.conditon,
      this.tagsEn,
      this.tagsAr,
      this.descriptionEn,
      this.unitPrice,
      this.unitDiscount,
      this.metaTitleEn,
      this.metaDescriptionEn,
      this.metaImg,
      this.pdf,
      this.slugEn,
      this.descriptionAr,
      this.slugAr,
      this.metaTitleAr,
      this.metaDescriptionAr,
      this.createdAt,
      this.updatedAt,
      this.country});

  AddsProductsData.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    name = json['name'];
    published = json['published'];
    status = json['status'];
    addedBy = json['user']['name'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    subsubcategoryId = json['subsubcategory_id'];
    brandId = json['brand_id'];
    photos = json['photos'] == null
        ? null
        : jsonDecode(json['photos'].toString()).cast<String>();
    thumbnailImg = json['thumbnail_img'];
    location = json['location'];
    phone = json['user']['phone'];
    videoProvider = json['video_provider'];
    videoLink = json['video_link'];
    unit = json['unit'];
    conditon = json['conditon'];
    tagsEn = json['tags_en'];
    tagsAr = json['tags_ar'];
    descriptionEn = json['description_en'];
    unitPrice = json['unit_price'];
    unitDiscount = json['unit_discount'];
    metaTitleEn = json['meta_title_en'];
    metaDescriptionEn = json['meta_description_en'];
    metaImg = json['meta_img'];
    pdf = json['pdf'];
    slugEn = json['slug_en'];
    descriptionAr = json['description_ar'];
    slugAr = json['slug_ar'];
    metaTitleAr = json['meta_title_ar'];
    metaDescriptionAr = json['meta_description_ar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['published'] = this.published;
    data['status'] = this.status;
    data['added_by'] = this.addedBy;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['subsubcategory_id'] = this.subsubcategoryId;
    data['brand_id'] = this.brandId;
    data['photos'] = this.photos;
    data['thumbnail_img'] = this.thumbnailImg;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['video_provider'] = this.videoProvider;
    data['video_link'] = this.videoLink;
    data['unit'] = this.unit;
    data['conditon'] = this.conditon;
    data['tags_en'] = this.tagsEn;
    data['tags_ar'] = this.tagsAr;
    data['description_en'] = this.descriptionEn;
    data['unit_price'] = this.unitPrice;
    data['unitDiscount'] = this.unitDiscount;
    data['meta_title_en'] = this.metaTitleEn;
    data['meta_description_en'] = this.metaDescriptionEn;
    data['meta_img'] = this.metaImg;
    data['pdf'] = this.pdf;
    data['slug_en'] = this.slugEn;
    data['description_ar'] = this.descriptionAr;
    data['slug_ar'] = this.slugAr;
    data['meta_title_ar'] = this.metaTitleAr;
    data['meta_description_ar'] = this.metaDescriptionAr;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
