

import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class BrandsPresenter {
  final BuildContext context;
  final BrandsCallBack brandsCallBack;

  BrandsPresenter({this.context, this.brandsCallBack});

  getAllBrandsData() {
    // homeCallBack.onDataLoading(true);
    // var url = Constants.BASE_URL + 'brands?lang='+Constants.API_LANG;
    var url = Constants.BASE_URL + 'brands';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          print(response);
          AllBrandsModel data = AllBrandsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            brandsCallBack.onBrandDataSuccess(data.data);
          } else {
            brandsCallBack.onBrandDataError("Error");
          }
        },
        onFailure: (error) {
          brandsCallBack.onBrandDataError(error.toString());
        },
        onLoading: (show) {
          brandsCallBack.onBrandDataLoading(show);
        }).makeRequest();
  }
}


abstract class BrandsCallBack {
  void onBrandDataSuccess(List<BrandsData> data);

  void onBrandDataLoading(bool show);

  void onBrandDataError(String message);
}