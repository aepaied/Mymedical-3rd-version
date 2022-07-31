class WishlistModel {
  List<WishlistData> data;
  bool success;
  int status;

  WishlistModel({this.data, this.success, this.status});

  WishlistModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<WishlistData>();
      json['data'].forEach((v) {
        data.add(new WishlistData.fromJson(v));
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

class WishlistData {
  int id;
  WishlistProduct product;

  WishlistData({this.id, this.product});

  WishlistData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null
        ? new WishlistProduct.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class WishlistProduct {
  int id;
  String name;
  String thumbnailImage;
  double basePrice;
  double baseDiscountedPrice;
  String unit;
  String rating;
  Links links;
  String country;
  bool isFavorite;
  WishlistProduct(
      {this.id,
      this.name,
      this.thumbnailImage,
      this.basePrice,
      this.baseDiscountedPrice,
      this.unit,
      this.rating,
      this.links,
      this.country,
      this.isFavorite});

  WishlistProduct.fromJson(Map<String, dynamic> json) {
    print(json['base_price']);
    id = json['id'];
    name = json['name'];
    thumbnailImage = json['thumbnail_image'];
    basePrice = double.parse(json['base_price'].toString());
    baseDiscountedPrice =
        double.parse(json['base_discounted_price'].toString());
    unit = json['unit'];
    rating = json['rating'].toString();
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    country = json['country'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumbnail_image'] = this.thumbnailImage;
    data['base_price'] = this.basePrice;
    data['base_discounted_price'] = this.baseDiscountedPrice;
    data['unit'] = this.unit;
    data['rating'] = this.rating;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    data['country'] = this.country;
    data['is_favorite'] = this.isFavorite;
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
