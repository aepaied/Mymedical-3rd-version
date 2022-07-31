class RelatedProduct {
  List<Details> details;
  bool success;
  int status;

  RelatedProduct({this.details, this.success, this.status});

  RelatedProduct.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      details = <Details>[];
      json['data'].forEach((v) {
        details.add(Details.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (details != null) {
      data['data'] = details.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['status'] = status;
    return data;
  }
}

class Details {
  int id;
  int variantProduct;
  String name;
  String country;
  String description;
  List<String> photos;
  String thumbnailImage;
  double basePrice;
  double baseDiscountedPrice;
  double todaysDeal;
  int featured;
  bool isFavorite;
  String unit;
  int currentStock;
  dynamic tags;
  String hashtagIds;
  int discount;
  String discountType;
  int rating;
  int sales;
  Links links;

  Details(
      {this.id,
      this.variantProduct,
      this.name,
      this.country,
      this.description,
      this.photos,
      this.thumbnailImage,
      this.basePrice,
      this.baseDiscountedPrice,
      this.todaysDeal,
      this.featured,
      this.isFavorite,
      this.unit,
      this.currentStock,
      this.tags,
      this.hashtagIds,
      this.discount,
      this.discountType,
      this.rating,
      this.sales,
      this.links});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variantProduct = json['variant_product'];
    name = json['name'];
    country = json['country'];
    description = json['description'];
    photos = json['photos'].cast<String>();
    thumbnailImage = json['thumbnail_image'];
    basePrice = double.parse(json['base_price'].toString());
    baseDiscountedPrice =
        double.parse(json['base_discounted_price'].toString());
    todaysDeal = double.parse(json['todays_deal'].toString());
    featured = json['featured'];
    isFavorite = json['is_favorite'];
    unit = json['unit'];
    currentStock = json['current_stock'];
    tags = json['tags'];
    hashtagIds = json['hashtag_ids'];
    discount = json['discount'];
    discountType = json['discount_type'];
    rating = json['rating'];
    sales = json['sales'];
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['variant_product'] = variantProduct;
    data['name'] = name;
    data['country'] = country;
    data['description'] = description;
    data['photos'] = photos;
    data['thumbnail_image'] = thumbnailImage;
    data['base_price'] = basePrice;
    data['base_discounted_price'] = baseDiscountedPrice;
    data['todays_deal'] = todaysDeal;
    data['featured'] = featured;
    data['is_favorite'] = isFavorite;
    data['unit'] = unit;
    data['current_stock'] = currentStock;
    data['tags'] = tags;
    data['hashtag_ids'] = hashtagIds;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['rating'] = rating;
    data['sales'] = sales;
    if (links != null) {
      data['links'] = links.toJson();
    }
    return data;
  }
}

class Links {
  String details;
  String reviews;
  String related;
  String topFromSeller;

  Links({this.details, this.reviews, this.related, this.topFromSeller});

  Links.fromJson(Map<String, dynamic> json) {
    details = json['details'];
    reviews = json['reviews'];
    related = json['related'];
    topFromSeller = json['top_from_seller'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['details'] = details;
    data['reviews'] = reviews;
    data['related'] = related;
    data['top_from_seller'] = topFromSeller;
    return data;
  }
}
