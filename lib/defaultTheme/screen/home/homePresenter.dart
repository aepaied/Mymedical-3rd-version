import 'package:flutter/material.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/bannerModel.dart';
import 'package:my_medical_app/data/remote/models/flashDealsModel.dart';
import 'package:my_medical_app/data/remote/models/homeCategoriesModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/data/remote/models/searchModel.dart';
import 'package:my_medical_app/data/remote/models/sliderModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/helpers.dart';

class HomePresenter {
  final BuildContext context;
  final HomeCallBack callBack;

  HomePresenter({this.context, this.callBack});

  getSliderData() {
    // var url = Constants.BASE_URL + 'sliders?lang=' + Constants.API_LANG;
    var url = Constants.BASE_URL + 'sliders';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          SliderModel data = SliderModel.fromJson(response);
          if (data.success) {
            callBack.onSliderDataSuccess(data.data);
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

  getCategoriesData() {
    // var url = Constants.BASE_URL + 'home-categories?lang=' + Constants.API_LANG;
    var url = Constants.BASE_URL + 'home-categories';

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
          HomeCategoriesModel data = HomeCategoriesModel.fromJson(response);
          if (data.success) {
            callBack.onCategoriesSuccess(data.data);
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

  getCategoryProductsData(String link) {
    var url = link /*+ '?lang=' + Constants.API_LANG*/;

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          ProductsModel data = ProductsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onCategoryProductsSuccess(data.data, data.meta);
          } else {
            callBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          callBack.onDataError(error.toString());
        },
        onLoading: (show) {
          callBack.onCategoryProductsDataLoading(show);
        }).makeRequest();
  }

  getFlashDealsData() {
    // var url = Constants.BASE_URL + 'products/flash-deal?lang=' + Constants.API_LANG;
    var url = Constants.BASE_URL + 'products/flash-deal';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
  ApiCallBack(
      context: context,
      call: http.get(Uri.parse(url), headers: headers),
      onResponse: (response) {
        if (response['data'].length ==  0){
          callBack.noFlashDeal();
        } else {
          FlashDealsModel data = FlashDealsModel.fromJson(response);
          if (data.success) {
            callBack.onFlashDealsSuccess(data.data);
          } else {
            callBack.onDataError("Error");
          }
        }
      },
      onFailure: (error) {
        callBack.onDataError(error.toString());
      },
      onLoading: (show) {
        callBack.onDataLoading(show);
      }).makeRequest();

  }

  getBannerData() {
    // var url = Constants.BASE_URL + 'banners?lang=' + Constants.API_LANG;
    var url = Constants.BASE_URL + 'banners';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          BannerModel data = BannerModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onBannerDataSuccess(data.data);
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

  getAllProductssData(String link, String page) {
    var url = link + '?page=' + page /*+ '&lang=' + Constants.API_LANG*/;
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
            ProductsModel data = ProductsModel.fromJson(response);
            if (data.success) {
              callBack.onProductsDataSuccess(data.data, data.meta);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onProductsDataLoading(show);
          }).makeRequest();
    });
  }

/*
  getTopBrandsData() {
    // homeCallBack.onDataLoading(true);
    // var url = Constants.BASE_URL + 'brands/top?lang=' + Constants.API_LANG;
    var url = Constants.BASE_URL + 'brands/top';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          AllBrandsModel data = AllBrandsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onBrandsSuccess(data.data);
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


  getBrandProductsData(String link) {
    var url = link */ /*+ '?lang=' + Constants.API_LANG*/ /*;

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          ProductsModel data = ProductsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onBrandProductsSuccess(data.data, data.meta);
          } else {
            callBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          callBack.onDataError(error.toString());
        },
        onLoading: (show) {
          callBack.onBrandProductsDataLoading(show);
        }).makeRequest();
  }


  makesearch(String key, String value) {
    var url = Constants.BASE_URL +
        'products/search?key=' +
        key +
        '&value=' +
        value */ /*+
        '&lang=' +
        Constants.API_LANG*/ /*;

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

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
          callBack.onSearchDataLoading(show);
        }).makeRequest();
  }*/
}

abstract class HomeCallBack {
  void onSliderDataSuccess(List<SliderData> data);

  void onBannerDataSuccess(List<BannerData> data);

  void onFlashDealsSuccess(FlashDealsData data);

  void onCategoriesSuccess(List<HomeCategoriesData> data);

  // void onBrandsSuccess(List<BrandsData> data);

  void onCategoryProductsSuccess(List<ProductsData> data, Meta meta);

  // void onBrandProductsSuccess(List<ProductsData> data, Meta meta);

  void onProductsDataSuccess(List<ProductsData> data, Meta meta);

  // void onSearchDataSuccess(SearchModel data);

  void onProductsDataLoading(bool show);

  // void onSearchDataLoading(bool show);

  void onDataLoading(bool show);

  void onCategoryProductsDataLoading(bool show);

  // void onBrandProductsDataLoading(bool show);

  void onDataError(String message);
  void noFlashDeal();
}
