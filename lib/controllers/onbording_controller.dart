import 'package:get/get.dart';
import 'package:my_medical_app/services/api_services.dart';
import 'package:my_medical_app/utils/constants.dart';

class OnBoardingController extends GetxController {
  var onBoardingLoading = false.obs;
  var position = 0.obs;
  var mSliderList = <String>[].obs;
  var mHeadingList =
      <String>["Hi, Welcome", "Most Unique Styles!", "Shop Till You Drop!"].obs;
  var mSubtitle1ingList = <String>[
    "We make around your city Affordable,easy and efficient.",
    "Shop the most trending fashion on the biggest shopping website",
    "Grab the best seller pieces at bargain prices."
  ];

  gettingWalkThroughData() {
    onBoardingLoading.value = true;
    ApiServices().getWalkTrough().then((resp) {
      onBoardingLoading.value = false;
      mSliderList.clear();
      mHeadingList.clear();
      mSubtitle1ingList.clear();
      for (var item in resp['data']) {
        mSliderList.add("${Constants.IMAGE_BASE_URL}${item['image']}/");
        mHeadingList.add(item['title']);
        mSubtitle1ingList.add(item['sub_title']);
      }
    });
  }

  changeIndex(int index) {
    position.value = index;
  }
}
