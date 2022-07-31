class AllCategoriesModel {
  List<CategoriesData> data;
  bool success;
  int status;

  AllCategoriesModel({this.data, this.success, this.status});

  AllCategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CategoriesData>();
      json['data'].forEach((v) {
        data.add(new CategoriesData.fromJson(v));
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

class CategoriesData {
  int id;
  String name;
  String banner;
  String icon;
  String tagIds;
  List<SubCategories> subCategories;
  Links links;

  CategoriesData(
      {this.id,
        this.name,
        this.banner,
        this.icon,
        this.tagIds,
        this.subCategories,
        this.links});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    banner = json['banner'];
    icon = json['icon'];
    tagIds = json['tag_ids'];
    if (json['sub_categories'] != null) {
      subCategories = new List<SubCategories>();
      json['sub_categories'].forEach((v) {
        subCategories.add(new SubCategories.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['banner'] = this.banner;
    data['icon'] = this.icon;
    data['tag_ids'] = this.tagIds;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class SubCategories {
  int id;
  String name;
  int categoryId;
  String slug;
  List<SubSubCategories> subSubCategories;

  SubCategories(
      {this.id, this.name, this.categoryId, this.slug, this.subSubCategories});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    slug = json['slug'];
    if (json['sub_sub_categories'] != null) {
      subSubCategories = new List<SubSubCategories>();
      json['sub_sub_categories'].forEach((v) {
        subSubCategories.add(new SubSubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['slug'] = this.slug;
    if (this.subSubCategories != null) {
      data['sub_sub_categories'] =
          this.subSubCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSubCategories {
  int id;
  String name;
  int subCategoryId;
  String slug;
  String icon;


  SubSubCategories({this.id, this.name, this.subCategoryId, this.slug,this.icon});

  SubSubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subCategoryId = json['sub_category_id'];
    slug = json['slug'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sub_category_id'] = this.subCategoryId;
    data['slug'] = this.slug;
    data['icon'] = this.icon;
    return data;
  }
}

class Links {
  String products;

  Links({this.products});

  Links.fromJson(Map<String, dynamic> json) {
    products = json['products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    return data;
  }
}