import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/cartModel.dart';
import 'package:my_medical_app/data/remote/models/logoutModel.dart';

import 'package:my_medical_app/data/remote/models/wishlistModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:my_medical_app/utils/helpers.dart';

class CartPresenter {
  final BuildContext context;
  CartCallBack callBack;
  AddCartCallBack addCartCallBack;
  QuantityCartCallBack quantityCartCallBack;
  DeleteCartCallBack deleteCartCallBack;

  CartPresenter(
      {this.context,
      this.callBack,
      this.addCartCallBack,
      this.quantityCartCallBack,
      this.deleteCartCallBack});

  addToCart(String productID, bool gotoShop, String variant, String color) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'carts/add';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, dynamic> body = {
        "id": productID,
        "user_id": user.id,
      };
      if (variant != null) body['variant'] = variant;
      if (color != null) body['color'] = color;
      print(url);
      print(body);
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers, body: body),
          onResponse: (response) {
            LogoutModel data = LogoutModel.fromJson(response);
            print(data.toString());
            if (data.status) {
              addCartCallBack.onAddCartDataSuccess(data.message, gotoShop);
              Constants.CART_COUNT += 1;
            } else {
              addCartCallBack.onAddCartDataError(data.message);
            }
          },
          onFailure: (error) {
            addCartCallBack.onAddCartDataError(error.toString());
          },
          onLoading: (show) {
            addCartCallBack.onAddCartDataLoading(show);
          }).makeRequest();
    });
  }

  changeQuantityCart(String id, String quantity, bool incrementQuantity) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'carts/change-quantity?id=';
      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, String> body = {'id': id, "quantity": quantity};
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers, body: body),
          onResponse: (response) {
            print(response);
            LogoutModel data = LogoutModel.fromJson(response);
            print(data.toString());
            if (data.message == "Cart updated") {
              quantityCartCallBack.onChangeQuantitySuccess(
                  id, double.parse(quantity), incrementQuantity);
            } else {
              quantityCartCallBack.onChangeQuantityError(data.message);
            }
          },
          onFailure: (error) {
            quantityCartCallBack.onChangeQuantityError(error.toString());
          },
          onLoading: (show) {
            quantityCartCallBack.onChangeQuantityLoading(show);
          }).makeRequest();
    });
  }

  removeFromCart(String id) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL +
          'carts/' +
          id /*+ '?lang=' + Constants.API_LANG*/;

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.delete(Uri.parse(url), headers: headers),
          onResponse: (response) {
            LogoutModel data = LogoutModel.fromJson(response);
            print(data.toString());
            if (data.status) {
              Constants.CART_COUNT -= 1;
              deleteCartCallBack.onDeleteCartSuccess(data.message);
            } else {
              deleteCartCallBack.onDeleteCartError(data.message);
            }
          },
          onFailure: (error) {
            deleteCartCallBack.onDeleteCartError(error.toString());
          },
          onLoading: (show) {
            deleteCartCallBack.onDeleteCartLoading(show);
          }).makeRequest();
    });
  }

  getCartData() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL +
              'carts/' +
              user.id /*+
          '?lang=' +
          Constants.API_LANG*/
          ;

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
            CartModel data = CartModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onCartDataSuccess(data.data);
            } else {
              callBack.onCartDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onCartDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onCartDataLoading(show);
          }).makeRequest();
    });
  }
}

abstract class CartCallBack {
  void onCartDataSuccess(List<CartData> data);

  void onCartDataLoading(bool show);

  void onCartDataError(String message);
}

abstract class AddCartCallBack {
  void onAddCartDataSuccess(String message, bool gotoShop);

  void onAddCartDataLoading(bool show);

  void onAddCartDataError(String message);
}

abstract class QuantityCartCallBack {
  void onChangeQuantitySuccess(String theID, double quantity, bool increment);

  void onChangeQuantityLoading(bool show);

  void onChangeQuantityError(String message);
}

abstract class DeleteCartCallBack {
  void onDeleteCartSuccess(String message);

  void onDeleteCartLoading(bool show);

  void onDeleteCartError(String message);
}
