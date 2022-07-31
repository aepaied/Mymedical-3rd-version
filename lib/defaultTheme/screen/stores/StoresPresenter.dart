import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/AllShopsModel.dart';
import 'package:my_medical_app/data/remote/models/ShopProductsModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class StoresPresenter {
  final BuildContext context;
  StoresCallBack callBack;
  StoreDetailsCallBack storeDetailsCallBack;
  StoreHomeCallBack storeHomeCallBack;
  TopSellingCallBack topSellingCallBack;
  AllProductsCallBack allProductsCallBack;

  StoresPresenter(
      {this.context,
      this.callBack,
      this.storeDetailsCallBack,
      this.storeHomeCallBack,
      this.topSellingCallBack,
      this.allProductsCallBack});

  loadAllStoresData() {
    var url = Constants.BASE_URL + 'shops';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          AllShopsModel data = AllShopsModel.fromJson(response);
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

  loadStoreProductsData(String url) {
    // var url = Constants.BASE_URL + 'shops/products/all/' + shopId.toString();

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          ShopProductsModel data = ShopProductsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            allProductsCallBack.onLoadAllProductsSuccess(data.data, data.meta);
          } else {
            allProductsCallBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          allProductsCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          allProductsCallBack.onDataLoading(show);
        }).makeRequest();
  }

  loadFeaturedProducts(int shopId) {
    var url = Constants.BASE_URL + 'shops/products/featured/' + shopId.toString();

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          ShopProductsModel data = ShopProductsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            storeHomeCallBack.onLoadFeaturedProductsSuccess(data.data);
          } else {
            storeHomeCallBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          storeHomeCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          storeHomeCallBack.onDataLoading(show);
        }).makeRequest();
  }

  loadNewProducts(int shopId) {
    var url = Constants.BASE_URL + 'shops/products/new/' + shopId.toString();

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          ShopProductsModel data = ShopProductsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            storeHomeCallBack.onLoadNewProductsSuccess(data.data);
          } else {
            storeHomeCallBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          storeHomeCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          storeHomeCallBack.onDataLoading(show);
        }).makeRequest();
  }

  loadTopSelling(int shopId) {
    var url = Constants.BASE_URL + 'shops/products/top/' + shopId.toString();

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          ShopProductsModel data = ShopProductsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            topSellingCallBack.onLoadTopSellingSuccess(data.data);
          } else {
            topSellingCallBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          topSellingCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          topSellingCallBack.onDataLoading(show);
        }).makeRequest();
  }

}

abstract class StoresCallBack {
  void onDataSuccess(List<ShopData> data);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class StoreDetailsCallBack {
  void onLoadProductsDataSuccess(List<ShopProductData> data, Meta meta);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class StoreHomeCallBack {
  void onLoadFeaturedProductsSuccess(List<ShopProductData> data);

  void onLoadNewProductsSuccess(List<ShopProductData> data);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class TopSellingCallBack {
  void onLoadTopSellingSuccess(List<ShopProductData> data);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class AllProductsCallBack {
  void onLoadAllProductsSuccess(List<ShopProductData> data, Meta meta);

  void onDataLoading(bool show);

  void onDataError(String message);
}
