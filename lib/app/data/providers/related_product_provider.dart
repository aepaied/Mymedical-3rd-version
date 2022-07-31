import 'package:get/get.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';

import '../models/related_product_model.dart';

class RelatedProductProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return RelatedProduct.fromJson(map);
      if (map is List)
        return map.map((item) => RelatedProduct.fromJson(item)).toList();
    };
    httpClient.addRequestModifier((request) {
      Helpers.getUserData().then((user) {
        request.headers['Authorization'] =
            user.tokenType + " " + user.accessToken;
        request.headers['Content-Type'] = 'application/x-www-form-urlencoded';
        request.headers['X-Requested-With'] = 'XMLHttpRequest';
        request.headers['lang'] = Constants.LANG;
      });
      return request;
    });
  }

  Future<RelatedProduct> getRelatedProduct(String url) async {
    final response = await get('$url');
    print(response.body);
    return response.body;
  }
}
