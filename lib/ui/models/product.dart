import 'package:flutter/material.dart';

class Product {
  int id;
  String name;
  List<String> photos;
  String thumbnail_image;
  double base_price;
  double base_discounted_price;
  double todays_deal;
  int featured;
  String current_stock;
  String tags;
  String hashtag_ids;
  int discount;
  String discount_type;
  String rating;
  String conditon;
  int sales;
  String linksdetails;
  String linksreviews;
  String linksrelated;
  String linkstop_from_seller;
  String country;
  bool isFavorite;

  Product(
      this.id,
      this.name,
      this.photos,
      this.thumbnail_image,
      this.base_price,
      this.base_discounted_price,
      this.todays_deal,
      this.featured,
      this.current_stock,
      this.tags,
      this.hashtag_ids,
      this.discount,
      this.discount_type,
      this.rating,
      this.conditon,
      this.sales,
      this.linksdetails,
      this.linksreviews,
      this.linksrelated,
      this.linkstop_from_seller,
  this.country,
      this.isFavorite
  );

/*String getPrice({double myPrice}) {
    if (myPrice != null) {
      return '\$${myPrice.toStringAsFixed(2)}';
    }
    return '\$${this.price.toStringAsFixed(2)}';
  }*/
}
