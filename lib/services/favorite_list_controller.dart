import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/data/remote/models/wishlistModel.dart';
import 'package:my_medical_app/defaultTheme/screen/wishlist/wishListPresenter.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

class FavoriteListController extends GetxController implements WishListCallBack ,AddWishListCallBack{

  List<WishlistData> productsList = List<WishlistData>().obs;
  WishListPresenter presenter;
  var isLogged = false.obs;
  var noProducts = false.obs;
  var isLoadingData = false.obs;

  @override
  void onInit() {
    if (presenter == null) {
      presenter = WishListPresenter(context: Get.context, callBack: this,addWishListCallBack: this);
    }
    super.onInit();
  }

  checkLogin(){
    Helpers.isLoggedIn().then((_result) {
      if (_result) {
        isLogged.value = true;
        presenter.getWishListData();
      } else {
        isLogged.value = false;
      }
    });
  }
  void removeFromWishList(String id){
    isLoadingData.value = true;
    presenter.removeToWishList(id.toString(),true);
  }
  @override
  void onAddWishListDataError(String message) {
    showDialog(context: Get.context, builder: (BuildContext context)=> CustomAlertDialog(errorText: message));
  }

  @override
  void onAddWishListDataLoading(bool show) {
  }

  @override
  void onAddWishListDataSuccess(String message, int id, bool isRemove) {
    presenter.getWishListData();
    isLoadingData.value = false;
  }

  @override
  void onDataError(String message) {
    showDialog(context: Get.context, builder: (BuildContext context)=> CustomAlertDialog(errorText: message));
  }

  @override
  void onDataLoading(bool show) {
  }

  @override
  void onDataSuccess(List<WishlistData> data) {
    productsList.clear();
    productsList.addAll(data);
    if (data.length == 0) {
      noProducts.value = true;
    } else {
      noProducts.value = false;
    }
  }
}