class ProductsModel {
  List<ProductsData> data;
  Links links;
  Meta meta;
  bool success;
  int status;

  ProductsModel({this.data, this.links, this.meta, this.success, this.status});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductsData>();
      json['data'].forEach((v) {
        data.add(new ProductsData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
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

class ProductsData {
  int id;
  String name;
  String description;
  List<String> photos;
  String thumbnailImage;
  double basePrice;
  double baseDiscountedPrice;
  double todaysDeal;
  int featured;
  String current_stock;
  String tags;
  String hashtagIds;
  int discount;
  String discountType;
  String country;
  String rating;
  int sales;
  ProductLinks links;
  bool isFavorite;

  ProductsData(
      {this.id,
      this.name,
      this.description,
      this.photos,
      this.thumbnailImage,
      this.basePrice,
      this.baseDiscountedPrice,
      this.todaysDeal,
      this.featured,
      this.current_stock,
      this.tags,
      this.hashtagIds,
      this.discount,
      this.discountType,
        this.country,
      this.rating,
      this.sales,
      this.links,
      this.isFavorite});

  ProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json.containsKey("description") ? json['description'] : null;
    photos =  json['photos']==null?null: json['photos'].cast<String>();
    thumbnailImage = json['thumbnail_image'];
    basePrice = double.parse(json['base_price'].toString());
    baseDiscountedPrice = double.parse(json['base_discounted_price'].toString());
    todaysDeal = double.parse(json['todays_deal'].toString());
    featured = json['featured'];
    current_stock = json['current_stock'].toString();
    tags = json['tags'];
    hashtagIds = json['hashtag_ids'];
    discount = json['discount'];
    discountType = json['discount_type'];
    country = json['country'].toString();
    rating = json['rating'].toString();
    sales = json['sales'];
    isFavorite = json['is_favorite'];
    links =
        json['links'] != null ? new ProductLinks.fromJson(json['links']) : null;
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
    data['current_stock'] = this.current_stock;
    data['tags'] = this.tags;
    data['hashtag_ids'] = this.hashtagIds;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['country'] = this.country;
    data['rating'] = this.rating;
    data['sales'] = this.sales;
    data['is_favorite'] = this.isFavorite;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class ProductLinks {
  String details;
  String reviews;
  String related;
  String topFromSeller;

  ProductLinks({this.details, this.reviews, this.related, this.topFromSeller});

  ProductLinks.fromJson(Map<String, dynamic> json) {
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

class Links {
  String first;
  String last;
  String prev;
  String next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
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
