class SearchModel {
  List<SearchData> data;
  SearchModelLinks links;
  SearchModelMeta meta;
  bool success;
  int status;
  String country;

  SearchModel({this.data, this.links, this.meta, this.success, this.status});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<SearchData>();
      json['data'].forEach((v) {
        data.add(new SearchData.fromJson(v));
      });
    }
    links = json['links'] != null
        ? new SearchModelLinks.fromJson(json['links'])
        : null;
    meta = json['meta'] != null
        ? new SearchModelMeta.fromJson(json['meta'])
        : null;
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
    data['country'] = this.country;
    return data;
  }
}

class SearchData {
  int id;
  String name;
  String thumbnailImage;
  double basePrice;
  double baseDiscountedPrice;
  int current_stock;
  String rating;
  SearchLinks links;
  String country;
  bool isFavorite;

  SearchData(
      {this.id,
      this.name,
      this.thumbnailImage,
      this.basePrice,
      this.baseDiscountedPrice,
      this.rating,
      this.links,
      this.country,
      this.isFavorite});

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailImage = json['thumbnail_image'];
    basePrice = double.parse(json['base_price'].toString());
    baseDiscountedPrice = double.parse(json['base_discounted_price'].toString());
    current_stock = int.parse(json['current_stock'].toString());
    rating = json['rating'].toString();
    links =
        json['links'] != null ? new SearchLinks.fromJson(json['links']) : null;
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
    data['rating'] = this.rating;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}

class SearchLinks {
  String details;
  String reviews;
  String related;
  String topFromSeller;

  SearchLinks({this.details, this.reviews, this.related, this.topFromSeller});

  SearchLinks.fromJson(Map<String, dynamic> json) {
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

class SearchModelLinks {
  String first;
  String last;
  String prev;
  String next;

  SearchModelLinks({this.first, this.last, this.prev, this.next});

  SearchModelLinks.fromJson(Map<String, dynamic> json) {
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

class SearchModelMeta {
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  SearchModelMeta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.path,
      this.perPage,
      this.to,
      this.total});

  SearchModelMeta.fromJson(Map<String, dynamic> json) {
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
