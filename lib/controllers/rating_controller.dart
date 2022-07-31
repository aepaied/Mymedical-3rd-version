import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RatingController extends GetxController {
  final box = GetStorage();

  recordNewRating() {
    DateTime newRatingDate = DateTime.now();
    box.write("last_rating_date", newRatingDate);
  }

  bool checkForLastRating() {
    DateTime lastDate = box.read('last_rating_date' ?? null);
    if (lastDate != null) {
      final date2 = DateTime.now();
      final difference = date2.difference(lastDate).inDays;
      return difference >= 10 ? true : false;
    } else {
      return true;
    }
  }
}
