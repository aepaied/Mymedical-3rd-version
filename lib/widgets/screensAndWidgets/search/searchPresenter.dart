import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/models/searchModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/long_string_print.dart';

class SearchPresenter {
  final BuildContext context;
  final SearchBack callBack;

  SearchPresenter({this.context, this.callBack});

  // loadSearch(String key, String value, String sort_by, String nextURL,
  //     bool scrollSearch) {
  //   var url = !scrollSearch
  //       ? Constants.BASE_URL +
  //           'products/search?key=' +
  //           key +
  //           '&value=' +
  //           value +
  //           '&sort_by=' +
  //           sort_by
  //       : nextURL;
  //   print(url);
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //     'X-Requested-With': 'XMLHttpRequest',
  //     'lang': Constants.LANG
  //   };
  //   ApiCallBack(
  //       context: context,
  //       call: http.get(Uri.parse(url), headers: headers),
  //       onResponse: (response) {
  //         LongStringPrint().printWrapped(response.toString());
  //         SearchModel data = SearchModel.fromJson(response);
  //         if (data.success) {
  //           callBack.onSearchDataSuccess(data, scrollSearch);
  //         } else {
  //           callBack.onDataError("Error");
  //         }
  //       },
  //       onFailure: (error) {
  //         callBack.onDataError(error.toString());
  //       },
  //       onLoading: (show) {
  //         callBack.onDataLoading(show);
  //       }).makeRequest();
  // }

//   doInitialSearch(String initSearchText) {
//     var url = "${Constants.BASE_URL}products/advancedSearch?page=1";
//     print(url);
//     Map<String, String> headers = {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'X-Requested-With': 'XMLHttpRequest',
//       'lang': Constants.LANG
//     };
//     Map<String, dynamic> body = {};
//     if (initSearchText != "") {
//       body['search_query'] = initSearchText;
//     }
//     ApiCallBack(
//         context: context,
//         call: http.post(Uri.parse(url), headers: headers, body: body),
//         onResponse: (response) {
//           LongStringPrint().printWrapped(response.toString());
//           SearchModel data = SearchModel.fromJson(response);
//           callBack.onSearchDataSuccess(data);
//         },
//         onFailure: (error) {
//           callBack.onDataError(error.toString());
//         },
//         onLoading: (show) {
//           callBack.onDataLoading(show);
//         }).makeRequest();
//   }
}

abstract class SearchBack {
  void onSearchDataSuccess(SearchModel data);

  void onDataLoading(bool show);

  void onDataError(String message);
}
