import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/controllers/otp_controller.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import 'AuthPresenter.dart';

class ActivateAccountPresenter {
  final BuildContext context;
  ActivateAccountCallBack activateAccountCallBack;

  ActivateAccountPresenter({this.context, this.activateAccountCallBack});

  activateAccount(String email, String phone, String code) {
    print("email : $email");
    print("phone : $phone");
    print("code : $code");
    Helpers.getFcmToken().then((token) {
      // var url = Constants.BASE_URL + 'auth/signup?lang=' + Constants.API_LANG;

      var url = Constants.BASE_URL + 'auth/activeAccount';

      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, String> body = email != ""
          ? {
              'email': email,
              'verification_code': code,
            }
          : {'phone': phone, 'verification_code': code};
      print(body);
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers, body: body),
          onResponse: (response) {
            if (response['success']) {
              LoginModel data = LoginModel.fromJson(response);
              activateAccountCallBack.onActivateDataSuccess(data);
            } else {
              activateAccountCallBack.onActivateDataError(response['message']);
            }
          },
          onFailure: (error) {
            activateAccountCallBack.onActivateDataError(error.toString());
          },
          onLoading: (show) {
            activateAccountCallBack.onActivateDataLoading(show);
          }).makeRequest();
    });
  }
}

abstract class ActivateAccountCallBack {
  void onActivateDataSuccess(LoginModel data);

  void onActivateDataLoading(bool show);

  void onActivateDataError(String message);
}
