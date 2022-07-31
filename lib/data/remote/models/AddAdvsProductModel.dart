import 'dart:convert';

class AddAdvsProductModel {
  bool success;
  AddAdvsProductData data;

  AddAdvsProductModel({this.success, this.data});

  AddAdvsProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new AddAdvsProductData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class AddAdvsProductData {
  String nameEn;
  String nameAr;
  String addedBy;
  int userId;
  String categoryId;
  String subcategoryId;
  String subsubcategoryId;
  String brandId;
  String conditon;
  String locationAr;
  String locationEn;
  // String photos;
  List<String> photos;
  String thumbnailImg;
  String unit;
  String tagsEn;
  String tagsAr;
  String descriptionEn;
  String descriptionAr;
  String videoProvider;
  String videoLink;
  String unitPrice;
  String unitDiscount;
  String metaTitleEn;
  String metaTitleAr;
  String metaDescriptionEn;
  String metaDescriptionAr;
  String metaImg;
  String slugEn;
  String slugAr;
  String updatedAt;
  String createdAt;
  int id;

  AddAdvsProductData(
      {this.nameEn,
        this.nameAr,
        this.addedBy,
        this.userId,
        this.categoryId,
        this.subcategoryId,
        this.subsubcategoryId,
        this.brandId,
        this.conditon,
        this.locationAr,
        this.locationEn,
        this.photos,
        this.thumbnailImg,
        this.unit,
        this.tagsEn,
        this.tagsAr,
        this.descriptionEn,
        this.descriptionAr,
        this.videoProvider,
        this.videoLink,
        this.unitPrice,
        this.unitDiscount,
        this.metaTitleEn,
        this.metaTitleAr,
        this.metaDescriptionEn,
        this.metaDescriptionAr,
        this.metaImg,
        this.slugEn,
        this.slugAr,
        this.updatedAt,
        this.createdAt,
        this.id});

  AddAdvsProductData.fromJson(Map<String, dynamic> json) {
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
    addedBy = json['added_by'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    subsubcategoryId = json['subsubcategory_id'];
    brandId = json['brand_id'];
    conditon = json['conditon'];
    locationAr = json['location_ar'];
    locationEn = json['location_en'];
    // photos = json['photos'];
    photos = jsonDecode(json['photos'].toString()).cast<String>();
    thumbnailImg = json['thumbnail_img'];
    unit = json['unit'];
    tagsEn = json['tags_en'];
    tagsAr = json['tags_ar'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    videoProvider = json['video_provider'];
    videoLink = json['video_link'];
    unitPrice = json['unit_price'];
    unitDiscount = json['unitDiscount'];
    metaTitleEn = json['meta_title_en'];
    metaTitleAr = json['meta_title_ar'];
    metaDescriptionEn = json['meta_description_en'];
    metaDescriptionAr = json['meta_description_ar'];
    metaImg = json['meta_img'];
    slugEn = json['slug_en'];
    slugAr = json['slug_ar'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name_en'] = this.nameEn;
    data['name_ar'] = this.nameAr;
    data['added_by'] = this.addedBy;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['subsubcategory_id'] = this.subsubcategoryId;
    data['brand_id'] = this.brandId;
    data['conditon'] = this.conditon;
    data['location_ar'] = this.locationAr;
    data['location_en'] = this.locationEn;
    data['photos'] = this.photos;
    data['thumbnail_img'] = this.thumbnailImg;
    data['unit'] = this.unit;
    data['tags_en'] = this.tagsEn;
    data['tags_ar'] = this.tagsAr;
    data['description_en'] = this.descriptionEn;
    data['description_ar'] = this.descriptionAr;
    data['video_provider'] = this.videoProvider;
    data['video_link'] = this.videoLink;
    data['unit_price'] = this.unitPrice;
    data['unitDiscount'] = this.unitDiscount;
    data['meta_title_en'] = this.metaTitleEn;
    data['meta_title_ar'] = this.metaTitleAr;
    data['meta_description_en'] = this.metaDescriptionEn;
    data['meta_description_ar'] = this.metaDescriptionAr;
    data['meta_img'] = this.metaImg;
    data['slug_en'] = this.slugEn;
    data['slug_ar'] = this.slugAr;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}