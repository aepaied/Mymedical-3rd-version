class BestSellerModel {
  BestSellerData data;
  bool success;
  int status;

  BestSellerModel({this.data, this.success, this.status});

  BestSellerModel.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new BestSellerData.fromJson(json['data']) : null;
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }
}

class BestSellerData {
  String title;
  String endDate;
  Products products;

  BestSellerData({this.title, this.endDate, this.products});

  BestSellerData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    endDate = json['end_date'];
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['end_date'] = this.endDate;
    if (this.products != null) {
      data['products'] = this.products.toJson();
    }
    return data;
  }
}

class Products {
  List<BestSellerProductsData> data;

  Products({this.data});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<BestSellerProductsData>();
      json['data'].forEach((v) {
        data.add(new BestSellerProductsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BestSellerProductsData {
  int id;
  String name;
  String description;
  List<String> photos;
  String thumbnailImage;
  int basePrice;
  int baseDiscountedPrice;
  int todaysDeal;
  int featured;
  String unit;
  Null tags;
  String hashtagIds;
  int discount;
  String discountType;
  double rating;
  int sales;
  Links links;

  BestSellerProductsData(
      {this.id,
      this.name,
      this.description,
      this.photos,
      this.thumbnailImage,
      this.basePrice,
      this.baseDiscountedPrice,
      this.todaysDeal,
      this.featured,
      this.unit,
      this.tags,
      this.hashtagIds,
      this.discount,
      this.discountType,
      this.rating,
      this.sales,
      this.links});

  BestSellerProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    photos = json['photos'].cast<String>();
    thumbnailImage = json['thumbnail_image'];
    basePrice = json['base_price'];
    baseDiscountedPrice = json['base_discounted_price'];
    todaysDeal = json['todays_deal'];
    featured = json['featured'];
    unit = json['unit'];
    tags = json['tags'];
    hashtagIds = json['hashtag_ids'];
    discount = json['discount'];
    discountType = json['discount_type'];
    rating = double.parse(json['rating'].toString());
    sales = json['sales'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['photos'] = this.photos;
    data['thumbnail_image'] = this.thumbnailImage;
    data['base_price'] = this.basePrice;
    data['base_discounted_price'] = this.baseDiscountedPrice;
    data['todays_deal'] = this.todaysDeal;
    data['featured'] = this.featured;
    data['unit'] = this.unit;
    data['tags'] = this.tags;
    data['hashtag_ids'] = this.hashtagIds;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['rating'] = this.rating;
    data['sales'] = this.sales;
    if (this.links != null) {
      data['links'] = this.links.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['details'] = this.details;
    data['reviews'] = this.reviews;
    data['related'] = this.related;
    data['top_from_seller'] = this.topFromSeller;
    return data;
  }
}
