class ViewAdvsProductModel {
  bool success;
  ViewAdvsProductData data;

  ViewAdvsProductModel({this.success, this.data});

  ViewAdvsProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new ViewAdvsProductData.fromJson(json['data']) : null;
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

class ViewAdvsProductData {
  int id;
  String nameEn;
  int published;
  int status;
  String addedBy;
  int userId;
  int categoryId;
  int subcategoryId;
  int subsubcategoryId;
  int brandId;
  String photos;
  String thumbnailImg;
  String locationAr;
  String locationEn;
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
  String nameAr;
  String descriptionAr;
  String slugAr;
  String metaTitleAr;
  String metaDescriptionAr;
  String createdAt;
  String updatedAt;
  String name;
  String slug;
  User user;

  ViewAdvsProductData(
      {this.id,
        this.nameEn,
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
        this.locationAr,
        this.locationEn,
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
        this.nameAr,
        this.descriptionAr,
        this.slugAr,
        this.metaTitleAr,
        this.metaDescriptionAr,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.slug,
        this.user});

  ViewAdvsProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    published = json['published'];
    status = json['status'];
    addedBy = json['added_by'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    subsubcategoryId = json['subsubcategory_id'];
    brandId = json['brand_id'];
    photos = json['photos'];
    thumbnailImg = json['thumbnail_img'];
    locationAr = json['location_ar'];
    locationEn = json['location_en'];
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
    nameAr = json['name_ar'];
    descriptionAr = json['description_ar'];
    slugAr = json['slug_ar'];
    metaTitleAr = json['meta_title_ar'];
    metaDescriptionAr = json['meta_description_ar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    slug = json['slug'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_en'] = this.nameEn;
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
    data['location_ar'] = this.locationAr;
    data['location_en'] = this.locationEn;
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
    data['name_ar'] = this.nameAr;
    data['description_ar'] = this.descriptionAr;
    data['slug_ar'] = this.slugAr;
    data['meta_title_ar'] = this.metaTitleAr;
    data['meta_description_ar'] = this.metaDescriptionAr;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['slug'] = this.slug;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String phone;

  User({this.id, this.name, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}