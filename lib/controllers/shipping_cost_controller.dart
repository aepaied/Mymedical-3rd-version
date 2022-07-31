import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/long_string_print.dart';

class ShippingCostController extends GetxController {
  var shippingCost = 0.0.obs;
  var shippingDate = "".obs;

  getShippingCoast(BuildContext context, int shippingID) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'getShippingCostDuration';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      LongStringPrint().printWrapped(user.accessToken);
      Map<String, dynamic> body = {};
      body["shipping_adress_region"] =
          shippingID != null ? shippingID.toString() : "";
      print(url);
      print(body);
      ApiCallBack(
              context: context,
              call: http.post(Uri.parse(url), headers: headers, body: body),
              onResponse: (response) {
                print(response);
                if (response['success']) {
                  shippingCost.value =
                      double.parse(response['shipping_cost'].toString());
                  shippingDate.value = response['shipping_date'];
                } else {
                  // Get.defaultDialog(title: response['message']);
                }
              },
              onFailure: (error) {
                // Get.defaultDialog(title: error.toString());
              },
              onLoading: (show) {})
          .makeRequest();
    });
  }
}
