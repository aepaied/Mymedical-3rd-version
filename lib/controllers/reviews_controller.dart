import 'package:get/get.dart';
import 'package:my_medical_app/data/remote/models/ReviewsModel.dart';
import 'package:my_medical_app/services/api_services.dart';

class ReviewController extends GetxController {
  List<ReviewsModel> reviews = List<ReviewsModel>().obs;

  init() {
    reviews.clear();
  }

  getCurrentReviews(String theURL) {
    reviews.clear();
    ApiServices().getProductReviews(theURL).then((value) {
      for (var item in value) {
        print(item);
        ReviewsModel review = ReviewsModel.fromJson(item);
        reviews.add(review);
      }
    });
  }
}
