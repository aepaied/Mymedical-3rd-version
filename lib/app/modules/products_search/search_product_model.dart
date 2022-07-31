class SearchProduct {
  Products products;
  List<String> allColors;
  dynamic selectedColor;
  dynamic query;
  dynamic categoryId;
  dynamic sellerId;
  dynamic brandId;
  dynamic sortBy;
  dynamic minPrice;
  dynamic maxPrice;
  double originalMaxPrice;
  double originalMinPrice;
  List<Attributes> attributes;
  List<Attributes> selectedAttributes;

  SearchProduct(
      {this.products,
      this.allColors,
      this.selectedColor,
      this.query,
      this.categoryId,
      this.sellerId,
      this.brandId,
      this.sortBy,
      this.minPrice,
      this.maxPrice,
      this.originalMaxPrice,
      this.originalMinPrice,
      this.attributes,
      this.selectedAttributes});

  SearchProduct.fromJson(Map<String, dynamic> json) {
    products =
        json['products'] != null ? Products.fromJson(json['products']) : null;
    allColors = json['all_colors'].cast<String>();
    selectedColor = json['selected_color'];
    query = json['query'];
    categoryId = json['category_id'];
    sellerId = json['seller_id'];
    brandId = json['brand_id'];
    sortBy = json['sort_by'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    originalMaxPrice = double.parse(json['original_max_price'].toString());
    originalMinPrice = double.parse(json['original_min_price'].toString());
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes.add(Attributes.fromJson(v));
      });
    }
    if (json['selected_attributes'] != null) {
      selectedAttributes = <Attributes>[];
      json['selected_attributes'].forEach((v) {
        selectedAttributes.add(Attributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products.toJson();
    }
    data['all_colors'] = allColors;
    data['selected_color'] = selectedColor;
    data['query'] = query;
    data['category_id'] = categoryId;
    data['seller_id'] = sellerId;
    data['brand_id'] = brandId;
    data['sort_by'] = sortBy;
    data['min_price'] = minPrice;
    data['max_price'] = maxPrice;
    data['original_max_price'] = originalMaxPrice;
    data['original_min_price'] = originalMinPrice;
    if (attributes != null) {
      data['attributes'] = attributes.map((v) => v.toJson()).toList();
    }
    if (selectedAttributes != null) {
      data['selected_attributes'] =
          selectedAttributes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  List<Details> details;
  Pagination pagination;

  Products({this.details, this.pagination});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      details = <Details>[];
      json['data'].forEach((v) {
        details.add(Details.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (details != null) {
      data['data'] = details.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination.toJson();
    }
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

class Pagination {
  int perPage;
  int count;
  int total;
  dynamic prev;
  dynamic next;

  Pagination({this.perPage, this.count, this.total, this.prev, this.next});

  Pagination.fromJson(Map<String, dynamic> json) {
    perPage = json['per_page'];
    count = json['count'];
    total = json['total'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['per_page'] = perPage;
    data['count'] = count;
    data['total'] = total;
    data['prev'] = prev;
    data['next'] = next;
    return data;
  }
}

class Attributes {
  String id;
  String name;
  List<String> options;

  Attributes({this.id, this.name, this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['options'] = options;
    return data;
  }
}
