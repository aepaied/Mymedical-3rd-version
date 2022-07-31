import 'package:get/get.dart';
import 'package:my_medical_app/app/data/models/related_product_model.dart';
import 'package:my_medical_app/app/data/providers/related_product_provider.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/models/product_details.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/long_string_print.dart';

class RelatedProductsController extends GetxController {
  var relatedProduct = RelatedProduct().obs;

  RelatedProductProvider relatedProductProvider =
      Get.put(RelatedProductProvider());
  gettingRelatedProducts(String url) {
    relatedProductProvider.getRelatedProduct(url).then((resp) {
      relatedProduct.value = resp;
      update();
    });
  }
}
