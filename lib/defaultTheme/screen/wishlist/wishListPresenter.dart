import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/logoutModel.dart';

import 'package:my_medical_app/data/remote/models/wishlistModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:nb_utils/nb_utils.dart';

class WishListPresenter {
  final BuildContext context;
  WishListCallBack callBack;
  AddWishListCallBack addWishListCallBack;

  WishListPresenter({this.context, this.callBack, this.addWishListCallBack});


  addToWishList(String product_id,bool isRemove) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(Constants.id);
    Helpers.getUserData().then((user) {
      // var url = Constants.BASE_URL + 'wishlists?lang='+Constants.API_LANG;
      var url = Constants.BASE_URL + 'wishlists/storeFav';
      print(url);
      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url),
              body: {
                'product_id': product_id,
                'user_id':user.id
              },
              headers: headers),
          onResponse: (response) {
            print(response);
            LogoutModel data = LogoutModel.fromJson(response);
            if (response['success']) {
              addWishListCallBack.onAddWishListDataSuccess(data.message,int.parse(product_id),isRemove);
            } else {
              addWishListCallBack.onAddWishListDataError(data.message);
            }
          },
          onFailure: (error) {
            addWishListCallBack.onAddWishListDataError(error.toString());
          },
          onLoading: (show) {
            addWishListCallBack.onAddWishListDataLoading(show);
          }).makeRequest();
    });
  }

  removeToWishList(String productID,bool isRemove) {
    print(productID);
    Helpers.getUserData().then((user) {
      // var url = Constants.BASE_URL + 'wishlists/'+wishList_id/*+'?lang='+Constants.API_LANG*/;
      var url =  '${Constants.BASE_URL}wishlists/destroyfromFav/$productID/';
      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      print(headers);
      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url),
              headers: headers),
          onResponse: (response) {
            print("rrr $response");
            LogoutModel data = LogoutModel.fromJson(response);
            print(data.toString());
            if (data.status) {
              addWishListCallBack.onAddWishListDataSuccess(data.message,int.parse(productID),isRemove);
            } else {
              addWishListCallBack.onAddWishListDataError(data.message);
            }
          },
          onFailure: (error) {
            addWishListCallBack.onAddWishListDataError(error.toString());
          },
          onLoading: (show) {
            addWishListCallBack.onAddWishListDataLoading(show);
          }).makeRequest();
    });
  }


  getWishListData() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'wishlists/'+user.id/*+'?lang='+Constants.API_LANG*/;

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
            WishlistModel data = WishlistModel.fromJson(response);
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
}

abstract class WishListCallBack {
  void onDataSuccess(List<WishlistData> data);

  void onDataLoading(bool show);

  void onDataError(String message);
}


abstract class AddWishListCallBack {
  void onAddWishListDataSuccess(String message,int id,bool isRemove);

  void onAddWishListDataLoading(bool show);

  void onAddWishListDataError(String message);
}
