import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/MainCategoriesModel.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/main_category_model.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/sub_category_model.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/sub_sub_category_model.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CategoriesPresenter {
  final BuildContext context;
  final MainCategoriesCallBack mainCategoriesCallBack;

  // final SubCategoriesCallBack subCategoriesCallBack;

  CategoriesPresenter({this.context, this.mainCategoriesCallBack});

  getMainCategoriesData() {
    // homeCallBack.onDataLoading(true);
    // var url = Constants.BASE_URL + 'categories?lang='+Constants.API_LANG;
    var url = Constants.BASE_URL + 'categories/getMainCategories';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) async {
          print(response);
          if (response['success']) {
            List<MainCategoryModel> dataList = [];
            for (var item in response['data']['data']){
              print(item);
              MainCategoryModel mainCategoryModel= MainCategoryModel.fromJson(item);
              var secondUrl = Constants.BASE_URL + 'categories/SubWithSubSub/${mainCategoryModel.id}';
              ApiCallBack(
                  context: context,
                  call: http.get(Uri.parse(secondUrl), headers: headers),
                  onResponse: (secondResponse) async {
                    print(secondResponse);
                    for (var subItem in secondResponse['data']){
                      SubSubCategoryModel subCategoryModel = SubSubCategoryModel.fromJson(subItem);
                      for(var subSubItem in subItem['subSub']['data'] ){
                        SubSubCategoryModel subSubCategoryModel = SubSubCategoryModel.fromJson(subSubItem);
                        mainCategoryModel.subCats.add(subSubCategoryModel);
                      }
                      mainCategoryModel.subCats.add(subCategoryModel);
                    }
                  },
                  onFailure: (error){
                    mainCategoriesCallBack.onDataError("Error");
                  }, onLoading: (show){
                mainCategoriesCallBack.onDataLoading(show);
              }
              ).makeRequest();
dataList.add(mainCategoryModel);
            }
            mainCategoriesCallBack.onDataSuccess(dataList);
          } else {
            mainCategoriesCallBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          mainCategoriesCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          mainCategoriesCallBack.onDataLoading(show);
        }).makeRequest();
  }

/*
  getSubCategoriesData(String mainCatID) {
    var url = '${Constants.BASE_URL}categories/SubWithSubSub/$mainCatID';

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
          List<SubSubCategoryData> subSubList = [];
          for (var item in response['data'][0]['subSub']['data']) {
            subSubList.add(SubSubCategoryData(
                name: item['name'], id: item['id'], icon: item['icon']));
          }
          SubCategoryModel data = SubCategoryModel.fromJson(response);
          if (data.success) {
            subCategoriesCallBack.onSubCatDataSuccess(data.data,subSubList);
          } else {
            subCategoriesCallBack.onSubDataError("Error");
          }
        },
        onFailure: (error) {
          subCategoriesCallBack.onSubDataError(error.toString());
        },
        onLoading: (show) {
          subCategoriesCallBack.onSubDataLoading(show);
        }).makeRequest();
  }
*/
}

abstract class MainCategoriesCallBack {
  void onDataSuccess(List<MainCategoryModel> data);

  void onDataLoading(bool show);

  void onDataError(String message);
}

/*abstract class SubCategoriesCallBack {
  void onSubCatDataSuccess(List<SubCategoryModel> data,List<SubSubCategoryData> subList);

  void onSubDataLoading(bool show);

  void onSubDataError(String message);
}*/
