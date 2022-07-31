import 'package:flutter/cupertino.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http/http.dart' as http;

class ProductDetailsPresenter {
  BuildContext context;
  ShowProductCallBack  showProductCallBack;
  ProductDetailsPresenter({@required this.context,this.showProductCallBack});

/*
  showProduct(String productID) {
    var url = "${Constants.BASE_URL}products/$productID";
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
            Product data = Product.fromJson(response);
            if (response['success']) {
              showProductCallBack.onDataSuccess(data);
            } else {
              showProductCallBack.onDataError(response['message']);
            }
          },
          onFailure: (error) {
            showProductCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            showProductCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }
*/



}


abstract class ShowProductCallBack{
  void onDataSuccess(Product product);
  void onDataError(String errorMessage);
  void onDataLoading(bool show);
}