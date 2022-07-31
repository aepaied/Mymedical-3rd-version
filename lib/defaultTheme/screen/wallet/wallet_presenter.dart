import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/userBalanceModel.dart';
import 'package:my_medical_app/data/remote/models/walletHistoryModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';

class WalletPresenter {
  final BuildContext context;
  WalletCallBack callBack;

  WalletPresenter({this.context, this.callBack});

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
            print(response);
            UserBalanceModel data = UserBalanceModel.fromJson(response);
            if (data.success) {
              callBack.onDataSuccess(data.balance);
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

  getWalletHistory() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'walletHistory';

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
            WalletHistoryModel data = WalletHistoryModel.fromJson(response);
            if (data.success) {
              callBack.onWalletHistoryDataSuccess(data.data);
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

abstract class WalletCallBack {
  void onDataSuccess(double balance);

  void onWalletHistoryDataSuccess(List<WalletHistoryData> data);

  void onDataLoading(bool show);

  void onDataError(String message);
}
