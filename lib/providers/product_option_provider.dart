import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_medical_app/controllers/product_options_controller.dart';
import 'package:my_medical_app/models/var_price_model_model.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http/http.dart' as http;

class ProductOptionProvider {
  String theURL = "https://mymedicalshope.com/api/v1/products/variant/price";
  Map<String, String> headers = {
    'lang': Constants.LANG,
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  ProductOptionsController _productOptionsController =
      Get.put(ProductOptionsController());
  getNewPrice(int id, List options, String color) {
    Helpers.getUserData().then((user) async {
      headers['Authorization'] = user.tokenType + " " + user.accessToken;
      Map<String, dynamic> preBody = color != null
          ? {"id": id, "choice": options, "color": "$color"}
          : {
              "id": id,
              "choice": options,
            };
      final body = jsonEncode(preBody);
      print(body);
      await http
          .post(Uri.parse(theURL), headers: headers, body: body)
          .then((value) {
        Map valueMap = jsonDecode(value.body);
        print(value.body);
        VarPriceModel _varPriceModel = VarPriceModel.fromJson(valueMap);
        print(_varPriceModel.price);
        _productOptionsController.changeVarPriceModel(_varPriceModel);
        _productOptionsController.addFinalVarAndColor(
            _varPriceModel.variant, color);
      });
    });
  }
}
