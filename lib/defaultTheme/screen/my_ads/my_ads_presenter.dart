import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/app_localizations.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/AddAdvsProductModel.dart';
import 'package:my_medical_app/data/remote/models/DeleteAdvsProductModel.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/data/remote/models/myPackageModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/data/remote/models/viewAdvsProductModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:my_medical_app/utils/long_string_print.dart';
import 'package:my_medical_app/widgets/advsProductPhotoWidget.dart';

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
  }

  getMyAdvs() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'ads';

      Map<String, String> headers = {
        // 'Authorization': user.tokenType + " " + user.accessToken,
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
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
              callBack
                  .onDeleteSuccess("${translator.translate("delete_success")}");
            } else {
              callBack.onDataError("${translator.translate("error")}");
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
                AppLocalizations.of(context).translate('error'),
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

  addNewProduct(
      String name_en,
      String name_ar,
      String category_id,
      String subcategory_id,
      String subsubcategory_id,
      String brand_id,
      String conditon,
      String location_ar,
      String location_en,
      List<AdvsProductPhotoWidget> photos,
      File thumbnail_img,
      String unit,
      List<String> tags_en,
      List<String> tags_ar,
      String description_ar,
      String description_en,
      String video_provider,
      String video_link,
      String unit_price,
      String meta_title_ar,
      String meta_title_en,
      String meta_description_ar,
      String meta_description_en,
      File meta_img,
      File pdfFile,
      String unitDiscount) {
    Helpers.getMyToken().then((_result) async {
      Map<String, dynamic> body = {
        "name_en": name_en,
        "name_ar": name_ar,
        "category_id": category_id,
        "subcategory_id": subcategory_id,
        "subsubcategory_id": subsubcategory_id,
        "conditon": conditon,
        "location_ar": location_ar,
        "location_en": location_en,
        "unit": unit,
        "description_ar": description_ar,
        "description_en": description_en,
        "video_provider": video_provider,
        "video_link": video_link,
        "unit_price": unit_price,
        "meta_title_ar": meta_title_ar,
        "meta_title_en": meta_title_en,
        "meta_description_ar": meta_description_ar,
        "meta_description_en": meta_description_en,
        "unit_discount": unitDiscount,
      };
      var url = Constants.BASE_URL + 'add_ad';
      /*

          ?name_en=' +
          name_en +
          '&name_ar=' +
          name_ar +
          '&category_id=' +
          category_id +
          '&subcategory_id=' +
          subcategory_id +
          '&subsubcategory_id=' +
          subsubcategory_id +
          '&brand_id=' +
          brand_id +
          '&conditon=' +
          conditon +
          '&location_ar=' +
          location_ar +
          '&location_en=' +
          location_en +
          '&unit=' +
          unit +
          '&description_ar=' +
          description_ar +
          '&description_en=' +
          description_en +
          '&video_provider=' +
          video_provider +
          '&video_link=' +
          video_link +
          '&unit_price=' +
          unit_price +
          '&meta_title_ar=' +
          meta_title_ar +
          '&meta_title_en=' +
          meta_title_en +
          '&meta_description_ar=' +
          meta_description_ar +
          '&meta_description_en=' +
          meta_description_en +
          "&unit_discount=" +
          unitDiscount;
*/

      String tagsEn = "";
      if (tags_en != null) {
        for (String tag in tags_en) {
          tagsEn += tag + "|";
        }

        if (tagsEn.length > 0) {
          removeLastChars(tagsEn, 1);
        }
      }
      body['tags_en'] = tagsEn;

      String tagsAr = "";
      if (tags_ar != null) {
        for (String tag in tags_ar) {
          tagsAr += tag + "|";
        }

        if (tagsAr.length > 0) {
          removeLastChars(tagsAr, 1);
        }
      }
      body['tags_ar'] = tagsAr;

      Map<String, String> headers = {
        'Authorization': _result,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      var req = http.MultipartRequest("POST", Uri.parse(url));
      req.headers.addAll(headers);

      if (thumbnail_img != null) {
        final mimeTypeData =
            lookupMimeType(thumbnail_img.path, headerBytes: [0xFF, 0xD8])
                .split('/');

        req.files.add(await http.MultipartFile.fromPath(
            'thumbnail_img', thumbnail_img.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }

      if (meta_img != null) {
        final mimeTypeData =
            lookupMimeType(meta_img.path, headerBytes: [0xFF, 0xD8]).split('/');

        req.files.add(await http.MultipartFile.fromPath(
            'meta_img', meta_img.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }

      if (photos != null) {
        for (int i = 0; i < photos.length; i++) {
          if (photos[i].photoFile != null) {
            final mimeTypeData = lookupMimeType(photos[i].photoFile.path,
                headerBytes: [0xFF, 0xD8]).split('/');

            req.files.add(await http.MultipartFile.fromPath(
                'photos[' + i.toString() + ']', photos[i].photoFile.path,
                contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
          }
        }
      }

      if (pdfFile != null) {
        final mimeTypeData =
            lookupMimeType(pdfFile.path, headerBytes: [0xFF, 0xD8]).split('/');

        req.files.add(await http.MultipartFile.fromPath('pdf', pdfFile.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }

      ApiCallBack(
          context: context,
          call: req,
          onResponse: (response) {
            LongStringPrint().printWrapped(response.toString());
            AddAdvsProductModel data = AddAdvsProductModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              addProductCallBack.onAddProductSuccess(
                  AppLocalizations.of(context)
                      .translate('product_added_successfully'),
                  data.data);
            } else {
              addProductCallBack
                  .onDataError(AppLocalizations.of(context).translate('error'));
            }
          },
          onFailure: (error) {
            addProductCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            addProductCallBack.onDataLoading(show);
          }).makeMultiPartRequest();
    });
  }

  updateProduct(
      int id,
      String name_en,
      String name_ar,
      String category_id,
      String subcategory_id,
      String subsubcategory_id,
      String brand_id,
      String conditon,
      String location_ar,
      String location_en,
      List<AdvsProductPhotoWidget> photos,
      File thumbnail_img,
      String unit,
      List<String> tags_en,
      List<String> tags_ar,
      String description_ar,
      String description_en,
      String video_provider,
      String video_link,
      String unit_price,
      String meta_title_ar,
      String meta_title_en,
      String meta_description_ar,
      String meta_description_en,
      File meta_img,
      File pdfFile,
      String unitDiscount) {
    Helpers.getMyToken().then((_result) async {
      var url = Constants.BASE_URL +
          'edit_ad?name_en=' +
          name_en +
          '&id=' +
          id.toString() +
          '&name_ar=' +
          name_ar +
          '&category_id=' +
          category_id +
          '&subcategory_id=' +
          subcategory_id +
          '&subsubcategory_id=' +
          subsubcategory_id +
          // '&brand_id=' +
          // brand_id +
          '&conditon=' +
          conditon +
          '&location_ar=' +
          location_ar +
          '&location_en=' +
          location_en +
          '&unit=' +
          unit +
          '&description_ar=' +
          description_ar +
          '&description_en=' +
          description_en +
          '&video_provider=' +
          video_provider +
          '&video_link=' +
          video_link +
          '&unit_price=' +
          unit_price +
          '&meta_title_ar=' +
          meta_title_ar +
          '&meta_title_en=' +
          meta_title_en +
          '&meta_description_ar=' +
          meta_description_ar +
          '&meta_description_en=' +
          meta_description_en +
          "&unit_discount=" +
          unitDiscount;

      String tagsEn = "";
      if (tags_en != null) {
        for (String tag in tags_en) {
          tagsEn += tag + "|";
        }

        if (tagsEn.length > 0) {
          removeLastChars(tagsEn, 1);
        }
      }
      url += '&tags_en=' + tagsEn;

      String tagsAr = "";
      if (tags_ar != null) {
        for (String tag in tags_ar) {
          tagsAr += tag + "|";
        }

        if (tagsAr.length > 0) {
          removeLastChars(tagsAr, 1);
        }
      }
      url += '&tags_ar=' + tagsAr;

      Map<String, String> headers = {
        'Authorization': _result,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      var req = http.MultipartRequest("POST", Uri.parse(url));
      req.headers.addAll(headers);

      if (thumbnail_img != null) {
        final mimeTypeData =
            lookupMimeType(thumbnail_img.path, headerBytes: [0xFF, 0xD8])
                .split('/');

        req.files.add(await http.MultipartFile.fromPath(
            'thumbnail_img', thumbnail_img.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }

      if (meta_img != null) {
        final mimeTypeData =
            lookupMimeType(meta_img.path, headerBytes: [0xFF, 0xD8]).split('/');

        req.files.add(await http.MultipartFile.fromPath(
            'meta_img', meta_img.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }

      if (photos != null) {
        for (int i = 0; i < photos.length; i++) {
          if (photos[i].photoFile != null) {
            final mimeTypeData = lookupMimeType(photos[i].photoFile.path,
                headerBytes: [0xFF, 0xD8]).split('/');

            req.files.add(await http.MultipartFile.fromPath(
                'photos[' + i.toString() + ']', photos[i].photoFile.path,
                contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
          }
        }
      }

      if (pdfFile != null) {
        final mimeTypeData =
            lookupMimeType(pdfFile.path, headerBytes: [0xFF, 0xD8]).split('/');

        req.files.add(await http.MultipartFile.fromPath('pdf', pdfFile.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }

      ApiCallBack(
          context: context,
          call: req,
          onResponse: (response) {
            AddAdvsProductModel data = AddAdvsProductModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              addProductCallBack.onUpdateProductSuccess(
                  AppLocalizations.of(context)
                      .translate('product_updated_successfully'),
                  data.data);
            } else {
              addProductCallBack
                  .onDataError(AppLocalizations.of(context).translate('error'));
            }
          },
          onFailure: (error) {
            addProductCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            addProductCallBack.onDataLoading(show);
          }).makeMultiPartRequest();
    });
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
