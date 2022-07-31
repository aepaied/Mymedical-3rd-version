import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/my_addresses.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http/http.dart' as http;

class EditDeleteAddressController extends GetxController {
  confirmDeleteAddress(int addressID) {
    Get.defaultDialog(
        title: "${translator.translate("confirm")}",
        middleText: "${translator.translate("delete_address")}",
        actions: [
          MaterialButton(
            color: primaryColor,
            onPressed: () => deleteAddress(addressID),
            splashColor: Colors.blueGrey,
            child: Text(
              '${translator.translate("delete")}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.white,
            onPressed: () => Get.back(),
            splashColor: Colors.blueGrey,
            child: Text(
              '${translator.translate("cancel")}',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ]);
  }

  deleteAddress(int addressID) {
    print(addressID);
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'delete_user_adress/$addressID';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
              context: Get.context,
              call: http.get(Uri.parse(url), headers: headers),
              onResponse: (response) {
                print(response);
                if (response['success']) {
                  Get.off(MyAddresses(isWidget: false));
                } else {}
              },
              onFailure: (error) {},
              onLoading: (show) {})
          .makeRequest();
    });
  }
}
