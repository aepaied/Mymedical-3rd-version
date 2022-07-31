import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/ActivePhoneModel.dart';
import 'package:my_medical_app/data/remote/models/OtpModel.dart';
import 'package:my_medical_app/data/remote/models/VerifiedPhonesModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/data/remote/models/ActivePhoneModel.dart';
import 'package:my_medical_app/data/remote/models/OtpModel.dart';
import 'package:my_medical_app/data/remote/models/VerifiedPhonesModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';

class PhonePresenter {
  final BuildContext context;
  PhoneCallBack callBack;

  PhonePresenter({this.context, this.callBack});

  getMyVerifiedPhones() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'getMyVerifiedPhones';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
            VerifiedPhonesModel data = VerifiedPhonesModel.fromJson(response);
            print(response);
            print(data.toString());
            if (data.success) {
              callBack.onLoadVerifiedPhonesSuccess(data.data);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  sendOtpCode(String phone) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'sendOtpCode?phone=' + phone;

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers),
          onResponse: (response) {
            OtpModel data = OtpModel.fromJson(response);
            print(response);
            print(data.toString());
            if (data.success) {
              callBack.onOtpSuccess(data.message);
            } else {
              callBack.onOtpError(data.message);
            }
          },
          onFailure: (error) {
            callBack.onOtpError(error.toString());
          },
          onLoading: (show) {
            callBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  activePhone(String phone, String code) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'activePhone?phone=' + phone+'&code='+code;

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers),
          onResponse: (response) {
            ActivePhoneModel data = ActivePhoneModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onActivePhoneSuccess(data.message);
            } else {
              callBack.onDataError(data.message);
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onDataLoading(show);
          }).makeRequest();
    });
  }
}

abstract class PhoneCallBack {
  void onDataLoading(bool show);

  void onDataError(String message);

  void onLoadVerifiedPhonesSuccess(List<PhonesData> data);

  void onOtpSuccess(String message);

  void onActivePhoneSuccess(String message);

  void onOtpError(String message);
}
