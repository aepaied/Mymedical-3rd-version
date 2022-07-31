import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/AddAdvsProductModel.dart';
import 'package:my_medical_app/data/remote/models/DeleteAdvsProductModel.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/data/remote/models/myPackageModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/data/remote/models/viewAdvsProductModel.dart';
import 'package:my_medical_app/defaultTheme/screen/adds_products/addAddsProductScreen.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class AddsProductsPresenter {
  final BuildContext context;
  AddsProductsCallBack callBack;
  AddProductCallBack addProductCallBack;
  ViewProductCallBack viewProductCallBack;

  AddsProductsPresenter(
      {this.context,
      this.callBack,
      this.addProductCallBack,
      this.viewProductCallBack});

  getAllAdvs() {
    var url = Constants.BASE_URL + 'allAds';

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
          AddsProductsModel data = AddsProductsModel.fromJson(response);
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

  getMyAdvs() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'ads';
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
            AddsProductsModel data = AddsProductsModel.fromJson(response);
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
    });
  }

  deleteAdvs(int id) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'deleteAd/' + id.toString();

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
            DeleteAdvsProductModel data =
                DeleteAdvsProductModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onDeleteSuccess(translator.translate('delete_success'));
            } else {
              callBack.onDataError(
                translator.translate('error'),
              );
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

  viewProduct(int id) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'viewAd/' + id.toString();

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
            ViewAdvsProductModel data = ViewAdvsProductModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              viewProductCallBack.onViewProductDataSuccess(data.data);
            } else {
              callBack.onDataError(
                translator.translate('error'),
              );
            }
          },
          onFailure: (error) {
            viewProductCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            viewProductCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  getMyPackages() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'getClientPackage';

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
            MyPackageModel data = MyPackageModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onMyPackagesDataSuccess(data.data);
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

  getAllCategoriesData() {
    // homeCallBack.onDataLoading(true);
    // var url = Constants.BASE_URL + 'categories?lang='+Constants.API_LANG;
    var url = Constants.BASE_URL + 'categories';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          AllCategoriesModel data = AllCategoriesModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            addProductCallBack.onCategoriesDataSuccess(data.data);
          } else {
            addProductCallBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          addProductCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          addProductCallBack.onDataLoading(show);
        }).makeRequest();
  }

  removeLastChars(String str, int chars) {
    return str.substring(0, str.length - chars);
  }
}

abstract class AddsProductsCallBack {
  void onMyPackagesDataSuccess(MyPackageData data);

  void onDataSuccess(List<AddsProductsData> data);

  void onDeleteSuccess(String message);

  void onDataLoading(bool show);

  void onMoreDataLoading(bool show);

  void onDataError(String message);
}

abstract class AddProductCallBack {
  void onCategoriesDataSuccess(List<CategoriesData> data);

  void onAddProductSuccess(String message, AddAdvsProductData data);

  void onUpdateProductSuccess(String message, AddAdvsProductData data);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class ViewProductCallBack {
  void onViewProductDataSuccess(ViewAdvsProductData data);

  void onDataLoading(bool show);

  void onDataError(String message);
}
