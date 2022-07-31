import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/dashboardModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/helpers.dart';

class DashboardPresenter {
  final BuildContext context;
  final DashboardCallBack callBack;

  DashboardPresenter({this.context, this.callBack});

  getDashboardData() {
    Helpers.getUserData().then((user) {
      // var url = Constants.BASE_URL + 'vendors/dashboard?lang=' + Constants.API_LANG;
      var url = Constants.BASE_URL + 'vendors/dashboard';

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
            DashboardModel data = DashboardModel.fromJson(response);
            print(data.toString());
            /* if (data.success) {
            callBack.onDataSuccess(data.data);
          } else {
            callBack.onDataError("Error");
          }*/
            callBack.onDataSuccess(data);
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

abstract class DashboardCallBack {
  void onDataSuccess(DashboardModel data);

  void onDataLoading(bool show);

  void onDataError(String message);
}
