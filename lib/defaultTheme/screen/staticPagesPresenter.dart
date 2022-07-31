import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/StaticPagesListModel.dart';
import 'package:my_medical_app/data/remote/models/staticPagesModel.dart';
import 'package:my_medical_app/utils/constants.dart';

class StaticPagesPresenter {
  final BuildContext context;
  final StaticPagesCallBack callBack;
  final AllStaticPagesCallBack allStaticPagesCallBack;

  StaticPagesPresenter({this.context, this.callBack, this.allStaticPagesCallBack});

  getAllPages() {

    var url = Constants.BASE_URL + 'getStaticPagesList';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          StaticPagesListModel data = StaticPagesListModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            allStaticPagesCallBack.onAllPagesDataSuccess(data.data);
          } else {
            allStaticPagesCallBack.onAllDataError("Error");
          }
        },
        onFailure: (error) {
          allStaticPagesCallBack.onAllDataError(error.toString());
        },
        onLoading: (show) {
          allStaticPagesCallBack.onDataLoading(show);
        }).makeRequest();
  }


  getPageData(int pageId) {
  print(pageId);
    var url = Constants.BASE_URL + 'getStaticPage/' + pageId.toString();

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          debugPrint(response.toString());
          StaticPagesModel data = StaticPagesModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onDataSuccess(data.data);
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



abstract class StaticPagesCallBack {
  void onDataSuccess(Data data);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class AllStaticPagesCallBack {
  void onAllPagesDataSuccess(List<PageData> data);

  void onDataLoading(bool show);

  void onAllDataError(String message);
}