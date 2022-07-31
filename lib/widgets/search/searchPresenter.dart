import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/searchModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SearchPresenter {
  final BuildContext context;
  final SearchBack callBack;

  SearchPresenter({this.context, this.callBack});

  loadSearch(String key, String value, String page, String sort_by) {
    var url = Constants.BASE_URL +
        'products/search?key=' +
        key +
        '&value=' +
        value +
        '&page='+
        page+
        '&sort_by=' +
        sort_by;

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
print(url);
    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          SearchModel data = SearchModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onSearchDataSuccess(data);
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
  }
}

abstract class SearchBack {
  void onSearchDataSuccess(SearchModel data);

  void onDataLoading(bool show);

  void onDataError(String message);
}
