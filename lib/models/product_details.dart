import 'package:my_medical_app/data/remote/models/productDetailsModel.dart';

class ProductDetails {
  int id;
  String name;
  bool variant;
  String addedBy;
  String country;
  String description;
  String image;
  int price;
  bool isFavorite;
  int currentStock;
  List<dynamic> photos;
  String reviewsURL;
  String relatedURL;
  String videoLink;
  String pdf;
  List<ChoiceOptions> options;
  List<dynamic> colors;
  ProductDetails(
      {this.id,
      this.name,
      this.variant,
      this.addedBy,
      this.country,
      this.image,
      this.description,
      this.price,
      this.isFavorite,
      this.reviewsURL,
      this.relatedURL,
      this.photos,
      this.videoLink,
      this.pdf,
      this.colors,
      this.options,
      this.currentStock});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    variant = json['variant_product'] != null
        ? json['variant_product'] == 1
            ? true
            : false
        : false;
    addedBy = json['added_by'];
    country = json['country'];
    photos = json['photos'];
    description = json['description'];
    image = json['thumbnail_image'];
    price = json['price_lower'];
    isFavorite = json['is_favorite'];
    videoLink = json['video_link'];
    pdf = json['pdf'];
    currentStock = json['current_stock'];
    reviewsURL = json['links']['reviews'];
    relatedURL = json['links']['related'];
    colors = json['variant_product'] == 1 ? json['colors'] : null;
    options = [];
    for (var item in json['choice_options']) {
      options.add(ChoiceOptions.fromJson(item));
    }
  }
}
