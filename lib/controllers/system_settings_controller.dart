import 'package:get/get.dart';
import 'package:my_medical_app/app/data/models/business_settings_model.dart';
import 'package:my_medical_app/app/data/providers/business_settings_provider.dart';

class BusinessSettingController extends GetxController {
  BusinessSettingsProvider businessSettingsProvider =
      Get.put(BusinessSettingsProvider());
  var currentBusinessSettings = BusinessSettings().obs;
  @override
  void onInit() {
    getSettings();
    super.onInit();
  }

  getSettings() {
    businessSettingsProvider.getBusinessSettings().then((resp) {
      print(resp.success);
      currentBusinessSettings.value = resp;
    });
  }
}
