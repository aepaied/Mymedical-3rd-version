import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/models/AddVendorProductModel.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/app_localizations.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/AddVendorProductModel.dart';
import 'package:my_medical_app/data/remote/models/DeleteAdvsProductModel.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/widgets/advsProductPhotoWidget.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class VendorProductsPresenter {
  final BuildContext context;
  VendorProductsCallBack callBack;
  VendorAddProductCallBack vendorAddProductCallBack;

  VendorProductsPresenter(
      {this.context, this.callBack, this.vendorAddProductCallBack});

  getAllProductssData(String link, String page) {
    Helpers.getUserData().then((user) {
      var url = link + '?page=' + page /*+'&lang='+Constants.API_LANG*/;

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
            print(data.toString());
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

  deleteProduct(int id) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'vendors/product/destroy/' + id.toString();

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
              callBack.onDeleteSuccess(
                  AppLocalizations.of(context).translate('delete_success'));
            } else {
              callBack.onDataError(
                AppLocalizations.of(context).translate('error'),
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
            vendorAddProductCallBack.onCategoriesDataSuccess(data.data);
          } else {
            vendorAddProductCallBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          vendorAddProductCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          vendorAddProductCallBack.onDataLoading(show);
        }).makeRequest();
  }

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
          AllBrandsModel data = AllBrandsModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            vendorAddProductCallBack.onBrandsDataSuccess(data.data);
          } else {
            vendorAddProductCallBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          vendorAddProductCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          vendorAddProductCallBack.onDataLoading(show);
        }).makeRequest();
  }

  removeLastChars(String str, int chars) {
    return str.substring(0, str.length - chars);
  }

  getProductData(int id) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL +
          'vendors/product/getProductForEdit/' +
          id.toString();

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
            AddVendorProductModel data =
                AddVendorProductModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              vendorAddProductCallBack.onProductDataSuccess(data.product);
            } else {
              vendorAddProductCallBack.onDataError(
                AppLocalizations.of(context).translate('error'),
              );
            }
          },
          onFailure: (error) {
            vendorAddProductCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            vendorAddProductCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  addNewProduct(
      String name_en,
      String name_ar,
      String country_en,
      String country_ar,
      String category_id,
      String subcategory_id,
      String subsubcategory_id,
      String brand_id,
      List<AdvsProductPhotoWidget> photos,
      File thumbnail_img,
      String unit,
      String min_qty,
      List<String> tags_en,
      List<String> tags_ar,
      String refundable,
      String video_provider,
      String video_link,
      String unit_price,
      String meta_title_ar,
      String meta_title_en,
      String meta_description_ar,
      String meta_description_en,
      File meta_img,
      String purchase_price,
      File pdfFile,
      String discount,
      String current_stock,
      String description_en,
      String description_ar) {
    Helpers.getMyToken().then((_result) async {
      var url = Constants.BASE_URL +
          'vendors/product/store?name_en=' +
          name_en +
          '&name_ar=' +
          name_ar +
          '&country_en=' +
          country_en +
          '&country_ar=' +
          country_ar +
          '&category_id=' +
          category_id +
          '&subcategory_id=' +
          subcategory_id +
/*          '&subsubcategory_id=' +
          subsubcategory_id == null ? "" :subsubcategory_id +*/
          '&brand_id=' +
          brand_id +
          '&unit=' +
          unit +
          '&purchase_price=' +
          purchase_price +
          '&min_qty=' +
          min_qty +
          '&refundable=' +
          refundable +
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
          "&discount=" +
          discount +
          "&discount_type=amount&current_stock=" +
          current_stock +
          '&description_ar=' +
          description_ar +
          '&description_en=' +
          description_en;

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
            AddVendorProductModel data =
                AddVendorProductModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              vendorAddProductCallBack.onAddProductSuccess(
                  AppLocalizations.of(context)
                      .translate('product_added_successfully'),
                  data.product);
            } else {
              vendorAddProductCallBack
                  .onDataError(AppLocalizations.of(context).translate('error'));
            }
          },
          onFailure: (error) {
            vendorAddProductCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            vendorAddProductCallBack.onDataLoading(show);
          }).makeMultiPartRequest();
    });
  }

  String getPreviousPhotos(List<AdvsProductPhotoWidget> photos) {
    String previousPhotos = "";
    String allPhotos = "";

    for (AdvsProductPhotoWidget photo in photos) {
      if(photo.photoUrl != null){
        allPhotos = "\"" + photo.photoUrl + "\",";
      }
    }

    if (allPhotos.length > 0) {
      previousPhotos =
          "&previous_photos=[" + removeLastChars(allPhotos, 1) + "]";
    }

    return previousPhotos;
  }

  updateProduct(
      int id,
      String name_en,
      String name_ar,
      String country_en,
      String country_ar,
      String category_id,
      String subcategory_id,
      String subsubcategory_id,
      String brand_id,
      List<AdvsProductPhotoWidget> photos,
      File thumbnail_img,
      String unit,
      String min_qty,
      List<String> tags_en,
      List<String> tags_ar,
      String refundable,
      String video_provider,
      String video_link,
      String unit_price,
      String meta_title_ar,
      String meta_title_en,
      String meta_description_ar,
      String meta_description_en,
      File meta_img,
      String purchase_price,
      File pdfFile,
      String discount,
      String current_stock,
      String description_en,
      String description_ar) {
    Helpers.getMyToken().then((_result) async {
      var url = Constants.BASE_URL +
          'vendors/product/update?id=' +
          id.toString() +
          '&name_en=' +
          name_en +
          '&name_ar=' +
          name_ar +
          '&country_en=' +
          country_en +
          '&country_ar=' +
          country_ar +
          '&category_id=' +
          category_id +
          '&subcategory_id=' +
          subcategory_id +
          '&subsubcategory_id=' +
          subsubcategory_id +
          '&brand_id=' +
          brand_id +
          '&unit=' +
          unit +
          '&purchase_price=' +
          purchase_price +
          '&min_qty=' +
          min_qty +
          '&refundable=' +
          refundable +
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
          "&discount=" +
          discount +
          "&discount_type=amount&current_stock=" +
          current_stock +
          '&description_ar=' +
          description_ar +
          '&description_en=' +
          description_en +
          getPreviousPhotos(photos);

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
            AddVendorProductModel data =
                AddVendorProductModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              vendorAddProductCallBack.onAddProductSuccess(
                  AppLocalizations.of(context)
                      .translate('product_updated_successfully'),
                  data.product);
            } else {
              vendorAddProductCallBack
                  .onDataError(AppLocalizations.of(context).translate('error'));
            }
          },
          onFailure: (error) {
            vendorAddProductCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            vendorAddProductCallBack.onDataLoading(show);
          }).makeMultiPartRequest();
    });
  }
}

abstract class VendorProductsCallBack {
  void onDataSuccess(List<ProductsData> data, Meta meta);

  void onDeleteSuccess(String message);

  void onDataLoading(bool show);

  void onMoreDataLoading(bool show);

  void onDataError(String message);
}

abstract class VendorAddProductCallBack {
  void onCategoriesDataSuccess(List<CategoriesData> data);

  void onProductDataSuccess(VendorProductProduct data);

  void onAddProductSuccess(String message, VendorProductProduct data);

  // void onUpdateProductSuccess(String message, AddAdvsProductData data);

  void onDataLoading(bool show);

  void onDataError(String message);

  void onBrandsDataSuccess(List<BrandsData> data);
}
