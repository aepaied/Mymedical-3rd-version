import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/AddOrderModel.dart';
import 'package:my_medical_app/data/remote/models/CouponModel.dart';
import 'package:my_medical_app/data/remote/models/cartModel.dart';
import 'package:my_medical_app/data/remote/models/myAddressesModel.dart';
import 'package:my_medical_app/data/remote/models/payWithWalletModel.dart';
import 'package:my_medical_app/data/remote/models/shippingCostModel.dart';
import 'package:my_medical_app/data/remote/models/userBalanceModel.dart';
import 'package:my_medical_app/integrations/app_localizations.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';

class CheckoutPresenter {
  final BuildContext context;
  final CheckoutCallBack callBack;

  CheckoutPresenter({this.context, this.callBack});

  payWithWallet(int id) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'payOrderWithWallet/' + id.toString();

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
            PayWithWalletModel data = PayWithWalletModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onPayWithWalletSuccess();
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

  makeOrder(
      MyAddressesData address,
      String payment_type,
      String grand_total,
      String coupon_discount,
      String coupon_code,
      String shipping_cost,
      String wallet_discount) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'order/store';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      var preBody = {
        'shipping_adress_name': user.name,
        'shipping_adress_email': user.email,
        'shipping_adress_address': address.address,
        'shipping_adress_country': address.country.toString(),
        'shipping_adress_city': address.city.toString(),
        'shipping_adress_region': address.region.toString(),
        'shipping_adress_phone': address.phone,
        'shipping_adress_checkout_type': 'logged',
        'shipping_cost': shipping_cost.toString(),
        'user_id': user.id,
        'payment_type': payment_type,
        'payment_status': "unpaid",
        'grand_total': grand_total,
        'coupon_discount': coupon_discount,
        'coupon_code': coupon_code,
        'wallet_discount':
            payment_type == "wallet" ? grand_total : wallet_discount
      };
      var body = json.encode(preBody);
      print(body);
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), body: preBody, headers: headers),
          onResponse: (response) {
            debugPrint(response.toString());
            AddOrderModel data = AddOrderModel.fromJson(response);
            if (data.success) {
              callBack.onDataSuccess(data.message, data.orderId);
            } else {
              callBack.onDataError(data.message);
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

  getMyAdresses() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'getMyAdresses';

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
            MyAddressesModel data = MyAddressesModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onGetAddressesSuccess(data.data);
            } else {
              callBack.onDataError("No Address Found");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onAddressesDataLoading(show);
          }).makeRequest();
    });
  }

  getShippingCost(int regionId) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL +
          'getShippingCostDuration?shipping_adress_region=' +
          regionId.toString();

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers),
          onResponse: (response) {
            ShippingCostModel data = ShippingCostModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onShippingCostSuccess(
                  data.shippingDate, data.shippingCost);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onAddressesDataLoading(show);
          }).makeRequest();
    });
  }

  getCartData() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'getUserOrders/'
          // user.id +
          // '?lang=' +
          // Constants.API_LANG*/
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

  getCouponDiscount(String code) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'getCouponDiscount';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, String> body = {
        'code': code,
      };
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers, body: body),
          onResponse: (response) {
            print(response);
            CouponModel data = CouponModel.fromJson(response);
            if (data.success) {
              callBack.onCouponSuccess(data.message, data.data);
            } else {
              callBack.onCouponError(data.message);
            }
          },
          onFailure: (error) {
            callBack.onCouponError(error.toString());
          },
          onLoading: (show) {
            callBack.onCouponLoading(show);
          }).makeRequest();
    });
  }

  getWalletBalance() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'UserBalance';

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
            UserBalanceModel data = UserBalanceModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onWalletBalanceSuccess(data.balance);
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

abstract class CheckoutCallBack {
  void onPayWithWalletSuccess();

  void onWalletBalanceSuccess(double balance);

  void onGetAddressesSuccess(List<MyAddressesData> data);

  void onShippingCostSuccess(String shippingDate, double shippingCost);

  void onAddressesDataLoading(bool show);

  void onDataLoading(bool show);

  void onCouponLoading(bool show);

  void onDataError(String message);

  void onCouponError(String message);

  void onDataSuccess(String message, int orderId);

  void onCouponSuccess(String message, CouponData data);

  void onCartDataSuccess(List<CartData> data);

  void onCartDataLoading(bool show);

  void onCartDataError(String message);
}
