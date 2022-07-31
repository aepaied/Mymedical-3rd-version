class AddVendorProductModel {
  bool success;
  VendorProductProduct product;

  AddVendorProductModel({this.success, this.product});

  AddVendorProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    product =
    json['product'] != null ? new VendorProductProduct.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class VendorProductProduct {
  int id;
  String countryAr;
  String countryEn;
  String lightHeavyShipping;
  String nameEn;
  String nameAr;
  String descriptionAr;
  String slugAr;
  String slugEn;
  String addedBy;
  int userId;
  int categoryId;
  int subcategoryId;
  int subsubcategoryId;
  int brandId;
  List<String> photos;
  String thumbnailImg;
  String hashtagIds;
  String videoProvider;
  String videoLink;
  String tagsEn;
  String tagsAr;
  String descriptionEn;
  int unitPrice;
  int purchasePrice;
  int variantProduct;
  String attributes;
  String choiceOptions;
  String colors;
  String variations;
  int todaysDeal;
  int published;
  int featured;
  int currentStock;
  String unit;
  int minQty;
  int discount;
  String discountType;
  String tax;
  String taxType;
  String shippingType;
  int shippingCost;
  int numOfSale;
  String metaTitleEn;
  String metaDescriptionEn;
  String metaImg;
  String pdf;
  int refundable;
  int rating;
  String barcode;
  int digital;
  String fileName;
  String filePath;
  String metaTitleAr;
  String metaDescriptionAr;
  String createdAt;
  String updatedAt;

  VendorProductProduct(
      {this.id,
        this.countryAr,
        this.countryEn,
        this.lightHeavyShipping,
        this.nameEn,
        this.nameAr,
        this.descriptionAr,
        this.slugAr,
        this.slugEn,
        this.addedBy,
        this.userId,
        this.categoryId,
        this.subcategoryId,
        this.subsubcategoryId,
        this.brandId,
        this.photos,
        this.thumbnailImg,
        this.hashtagIds,
        this.videoProvider,
        this.videoLink,
        this.tagsEn,
        this.tagsAr,
        this.descriptionEn,
        this.unitPrice,
        this.purchasePrice,
        this.variantProduct,
        this.attributes,
        this.choiceOptions,
        this.colors,
        this.variations,
        this.todaysDeal,
        this.published,
        this.featured,
        this.currentStock,
        this.unit,
        this.minQty,
        this.discount,
        this.discountType,
        this.tax,
        this.taxType,
        this.shippingType,
        this.shippingCost,
        this.numOfSale,
        this.metaTitleEn,
        this.metaDescriptionEn,
        this.metaImg,
        this.pdf,
        this.refundable,
        this.rating,
        this.barcode,
        this.digital,
        this.fileName,
        this.filePath,
        this.metaTitleAr,
        this.metaDescriptionAr,
        this.createdAt,
        this.updatedAt});

  VendorProductProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryAr = json['country_ar'];
    countryEn = json['country_en'];
    lightHeavyShipping = json['light_heavy_shipping'];
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
    descriptionAr = json['description_ar'];
    slugAr = json['slug_ar'];
    slugEn = json['slug_en'];
    addedBy = json['added_by'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    subsubcategoryId = json['subsubcategory_id'];
    brandId = json['brand_id'];
    photos = json['photos'].cast<String>();
    thumbnailImg = json['thumbnail_img'];
    hashtagIds = json['hashtag_ids'];
    videoProvider = json['video_provider'];
    videoLink = json['video_link'];
    tagsEn = json['tags_en'];
    tagsAr = json['tags_ar'];
    descriptionEn = json['description_en'];
    unitPrice = json['unit_price'];
    purchasePrice = json['purchase_price'];
    variantProduct = json['variant_product'];
    attributes = json['attributes'];
    choiceOptions = json['choice_options'];
    colors = json['colors'];
    variations = json['variations'];
    todaysDeal = json['todays_deal'];
    published = json['published'];
    featured = json['featured'];
    currentStock = json['current_stock'];
    unit = json['unit'];
    minQty = json['min_qty'];
    discount = json['discount'];
    discountType = json['discount_type'];
    tax = json['tax'];
    taxType = json['tax_type'];
    shippingType = json['shipping_type'];
    shippingCost = json['shipping_cost'];
    numOfSale = json['num_of_sale'];
    metaTitleEn = json['meta_title_en'];
    metaDescriptionEn = json['meta_description_en'];
    metaImg = json['meta_img'];
    pdf = json['pdf'];
    refundable = json['refundable'];
    rating = json['rating'];
    barcode = json['barcode'];
    digital = json['digital'];
    fileName = json['file_name'];
    filePath = json['file_path'];
    metaTitleAr = json['meta_title_ar'];
    metaDescriptionAr = json['meta_description_ar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_ar'] = this.countryAr;
    data['country_en'] = this.countryEn;
    data['light_heavy_shipping'] = this.lightHeavyShipping;
    data['name_en'] = this.nameEn;
    data['name_ar'] = this.nameAr;
    data['description_ar'] = this.descriptionAr;
    data['slug_ar'] = this.slugAr;
    data['slug_en'] = this.slugEn;
    data['added_by'] = this.addedBy;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['subsubcategory_id'] = this.subsubcategoryId;
    data['brand_id'] = this.brandId;
    data['photos'] = this.photos;
    data['thumbnail_img'] = this.thumbnailImg;
    data['hashtag_ids'] = this.hashtagIds;
    data['video_provider'] = this.videoProvider;
    data['video_link'] = this.videoLink;
    data['tags_en'] = this.tagsEn;
    data['tags_ar'] = this.tagsAr;
    data['description_en'] = this.descriptionEn;
    data['unit_price'] = this.unitPrice;
    data['purchase_price'] = this.purchasePrice;
    data['variant_product'] = this.variantProduct;
    data['attributes'] = this.attributes;
    data['choice_options'] = this.choiceOptions;
    data['colors'] = this.colors;
    data['variations'] = this.variations;
    data['todays_deal'] = this.todaysDeal;
    data['published'] = this.published;
    data['featured'] = this.featured;
    data['current_stock'] = this.currentStock;
    data['unit'] = this.unit;
    data['min_qty'] = this.minQty;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['tax'] = this.tax;
    data['tax_type'] = this.taxType;
    data['shipping_type'] = this.shippingType;
    data['shipping_cost'] = this.shippingCost;
    data['num_of_sale'] = this.numOfSale;
    data['meta_title_en'] = this.metaTitleEn;
    data['meta_description_en'] = this.metaDescriptionEn;
    data['meta_img'] = this.metaImg;
    data['pdf'] = this.pdf;
    data['refundable'] = this.refundable;
    data['rating'] = this.rating;
    data['barcode'] = this.barcode;
    data['digital'] = this.digital;
    data['file_name'] = this.fileName;
    data['file_path'] = this.filePath;
    data['meta_title_ar'] = this.metaTitleAr;
    data['meta_description_ar'] = this.metaDescriptionAr;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}