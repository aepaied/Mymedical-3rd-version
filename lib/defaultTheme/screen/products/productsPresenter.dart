import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/models/product_details.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/long_string_print.dart';

class ProductsPresenter {
  final BuildContext context;
  final ProductsCallBack callBack;
  final ProductDetailsCallBack detailsCallBack;

  ProductsPresenter({this.context, this.callBack, this.detailsCallBack});

  getAllProductssData(String link, String page) {
    var url = link + '?page=' + page /*+'&lang='+Constants.API_LANG*/;
    Helpers.getUserData().then((user) {
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
            ProductsModel data = ProductsModel.fromJson(response);
            if (data.success) {
              callBack.onDataSuccess(data.data, data.meta);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            if (page == "1") {
              callBack.onDataLoading(show);
            } else {
              callBack.onMoreDataLoading(show);
            }
          }).makeRequest();
    });
  }

  getProductDetails(String productID) {
    var url = "${Constants.BASE_URL}products/$productID";
    Helpers.getUserData().then((user) {
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
            LongStringPrint().printWrapped(response.toString());
            if (response['success']) {
              ProductDetails data =
                  ProductDetails.fromJson(response['data'][0]);
              detailsCallBack.onDataSuccess(data);
            } else {
              detailsCallBack.onDataError(response['message']);
            }
          },
          onFailure: (error) {
            detailsCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            detailsCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  getAdsProductDetails(String productID) {
    var url = "${Constants.BASE_URL}viewAd/$productID";
    Helpers.getUserData().then((user) {
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
            print(response);
            if (response['success']) {
              print(response['data']);
              AddsProductsData data =
                  AddsProductsData.fromJson(response['data']);
              detailsCallBack.onAdsDataSuccess(data);
            } else {
              detailsCallBack.onDataError(response['message']);
            }
          },
          onFailure: (error) {
            detailsCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            detailsCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }
}

abstract class ProductDetailsCallBack {
  void onDataSuccess(ProductDetails data);
  void onDataLoading(bool show);
  void onDataError(String message);
  void onAdsDataSuccess(AddsProductsData data);
}

abstract class ProductsCallBack {
  void onDataSuccess(List<ProductsData> data, Meta meta);

  void onDataLoading(bool show);

  void onMoreDataLoading(bool show);

  void onDataError(String message);
}
