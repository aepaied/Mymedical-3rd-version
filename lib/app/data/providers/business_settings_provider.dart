import 'package:get/get.dart';

import '../models/business_settings_model.dart';

class BusinessSettingsProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return BusinessSettings.fromJson(map);
      if (map is List)
        return map.map((item) => BusinessSettings.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'https://mymedicalshope.com/api/v1/';
  }

  Future<BusinessSettings> getBusinessSettings() async {
    final response = await get('business-settings');
    print(response.body);
    return response.body;
  }
}
