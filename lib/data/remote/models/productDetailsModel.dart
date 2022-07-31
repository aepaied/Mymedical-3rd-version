class ProductDetailsModel {
  List<ProductDetailsData> data;
  bool success;
  int status;

  ProductDetailsModel({this.data, this.success, this.status});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductDetailsData>();
      json['data'].forEach((v) {
        data.add(new ProductDetailsData.fromJson(v));
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

class ProductDetailsData {
  int id;
  String name;
  String addedBy;
  String country;
  User user;
  Category category;
  SubCategory subCategory;
  Brand brand;
  List<String> photos;
  String thumbnailImage;
  List<String> tags;
  int priceLower;
  int priceHigher;
  List<ChoiceOptions> choiceOptions;
  List<String> colors;
  int todaysDeal;
  int featured;
  int currentStock;
  String unit;
  int discount;
  String discountType;
  int tax;
  String taxType;
  String shippingType;
  int shippingCost;
  int numberOfSales;
  String rating;
  int ratingCount;
  String description;
  ProductLinks links;

  ProductDetailsData(
      {this.id,
        this.name,
        this.addedBy,
        this.country,
        this.user,
        this.category,
        this.subCategory,
        this.brand,
        this.photos,
        this.thumbnailImage,
        this.tags,
        this.priceLower,
        this.priceHigher,
        this.choiceOptions,
        this.colors,
        this.todaysDeal,
        this.featured,
        this.currentStock,
        this.unit,
        this.discount,
        this.discountType,
        this.tax,
        this.taxType,
        this.shippingType,
        this.shippingCost,
        this.numberOfSales,
        this.rating,
        this.ratingCount,
        this.description,
        this.links});

  ProductDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addedBy = json['added_by'];
    country = json['country'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new SubCategory.fromJson(json['sub_category'])
        : null;
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    photos = json['photos'].cast<String>();
    thumbnailImage = json['thumbnail_image'];
    tags = json['tags'].cast<String>();
    priceLower = json['price_lower'];
    priceHigher = json['price_higher'];
    if (json['choice_options'] != null) {
      choiceOptions = new List<ChoiceOptions>();
      json['choice_options'].forEach((v) {
        choiceOptions.add(new ChoiceOptions.fromJson(v));
      });
    }
    colors = json['colors'].cast<String>();
    todaysDeal = json['todays_deal'];
    featured = json['featured'];
    currentStock = json['current_stock'];
    unit = json['unit'];
    discount = json['discount'];
    discountType = json['discount_type'];
    tax = json['tax'];
    taxType = json['tax_type'];
    shippingType = json['shipping_type'];
    shippingCost = json['shipping_cost'];
    numberOfSales = json['number_of_sales'];
    rating = json['rating'].toString();
    ratingCount = json['rating_count'];
    description = json['description'];
    links = json['links'] != null ? new ProductLinks.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['added_by'] = this.addedBy;
    data['country'] = this.country;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory.toJson();
    }
    if (this.brand != null) {
      data['brand'] = this.brand.toJson();
    }
    data['photos'] = this.photos;
    data['thumbnail_image'] = this.thumbnailImage;
    data['tags'] = this.tags;
    data['price_lower'] = this.priceLower;
    data['price_higher'] = this.priceHigher;
    if (this.choiceOptions != null) {
      data['choice_options'] =
          this.choiceOptions.map((v) => v.toJson()).toList();
    }
    data['colors'] = this.colors;
    data['todays_deal'] = this.todaysDeal;
    data['featured'] = this.featured;
    data['current_stock'] = this.currentStock;
    data['unit'] = this.unit;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['tax'] = this.tax;
    data['tax_type'] = this.taxType;
    data['shipping_type'] = this.shippingType;
    data['shipping_cost'] = this.shippingCost;
    data['number_of_sales'] = this.numberOfSales;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['description'] = this.description;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class ChoiceOptions {
  String name;
  String title;
  List<String> options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['options'] = this.options;
    return data;
  }
}

class User {
  String name;
  String email;
  String avatar;
  String avatarOriginal;
  String shopName;
  String shopLogo;
  String shopLink;

  User(
      {this.name,
        this.email,
        this.avatar,
        this.avatarOriginal,
        this.shopName,
        this.shopLogo,
        this.shopLink});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    avatarOriginal = json['avatar_original'];
    shopName = json['shop_name'];
    shopLogo = json['shop_logo'];
    shopLink = json['shop_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['avatar_original'] = this.avatarOriginal;
    data['shop_name'] = this.shopName;
    data['shop_logo'] = this.shopLogo;
    data['shop_link'] = this.shopLink;
    return data;
  }
}

class Category {
  String name;
  String banner;
  String icon;
  CategoryLinks links;

  Category({this.name, this.banner, this.icon, this.links});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    banner = json['banner'];
    icon = json['icon'];
    links = json['links'] != null ? new CategoryLinks.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['banner'] = this.banner;
    data['icon'] = this.icon;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class CategoryLinks {
  String products;
  String subCategories;

  CategoryLinks({this.products, this.subCategories});

  CategoryLinks.fromJson(Map<String, dynamic> json) {
    products = json['products'];
    subCategories = json['sub_categories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    data['sub_categories'] = this.subCategories;
    return data;
  }
}

class SubCategory {
  String name;
  BrandLinks links;

  SubCategory({this.name, this.links});

  SubCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    links = json['links'] != null ? new BrandLinks.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class BrandLinks {
  String products;

  BrandLinks({this.products});

  BrandLinks.fromJson(Map<String, dynamic> json) {
    products = json['products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    return data;
  }
}

class Brand {
  String name;
  String logo;
  BrandLinks links;

  Brand({this.name, this.logo, this.links});

  Brand.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
    links = json['links'] != null ? new BrandLinks.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['logo'] = this.logo;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class ProductLinks {
  String reviews;
  String related;

  ProductLinks({this.reviews, this.related});

  ProductLinks.fromJson(Map<String, dynamic> json) {
    reviews = json['reviews'];
    related = json['related'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviews'] = this.reviews;
    data['related'] = this.related;
    return data;
  }
}