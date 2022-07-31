class ShopProductsModel {
  List<ShopProductData> data;
  DataLinks links;
  Meta meta;
  bool success;
  int status;

  ShopProductsModel(
      {this.data, this.links, this.meta, this.success, this.status});

  ShopProductsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ShopProductData>();
      json['data'].forEach((v) {
        data.add(new ShopProductData.fromJson(v));
      });
    }
    if(json.containsKey("links")){
      links = json['links'] != null ? new DataLinks.fromJson(json['links']) : null;
    }
    if(json.containsKey("meta")){
      meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    }

    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }
}

class ShopProductData {
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
  String tags;
  String hashtagIds;
  int discount;
  String discountType;
  int rating;
  int sales;
  ShopProductLinks links;

  ShopProductData(
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

  ShopProductData.fromJson(Map<String, dynamic> json) {
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
    rating = json['rating'];
    sales = json['sales'];
    links = json['links'] != null ? new ShopProductLinks.fromJson(json['links']) : null;
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

class ShopProductLinks {
  String details;
  String reviews;
  String related;
  String topFromSeller;

  ShopProductLinks({this.details, this.reviews, this.related, this.topFromSeller});

  ShopProductLinks.fromJson(Map<String, dynamic> json) {
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

class DataLinks {
  String first;
  String last;
  String prev;
  String next;

  DataLinks({this.first, this.last, this.prev, this.next});

  DataLinks.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}