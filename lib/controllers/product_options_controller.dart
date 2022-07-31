import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/controllers/related_products_controller.dart';
import 'package:my_medical_app/controllers/reviews_controller.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/productDetailsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsPresenter.dart';
import 'package:my_medical_app/models/product_details.dart';
import 'package:my_medical_app/models/var_price_model_model.dart';
import 'package:my_medical_app/providers/product_option_provider.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

class ProductOptionsController extends GetxController
    implements ProductDetailsCallBack {
  final chosenSizeIndex = 0.obs;
  final chosenWeightIndex = 0.obs;
  final chosenColorIndex = 0.obs;
  final pickedColor = "".obs;
  final pickedOptions = {};
  final varPriceModel = VarPriceModel().obs;
  final isLoading = false.obs;
  final currentProduct = ProductDetails().obs;
  String finalColor;
  String finalVariant;

  ProductsPresenter presenter;
  List<ChoiceOptions> options;
  List colors;
  ReviewController _reviewController = Get.put(ReviewController());

  init(bool isVar) {
    chosenSizeIndex.value = 0;
    chosenWeightIndex.value = 0;
    pickedColor.value = colors != null && colors.isNotEmpty ? colors[0] : "";
    finalVariant = null;
    finalColor = null;
    for (ChoiceOptions item in options) {
      print(item.title);
      if (item.title == "Size") {
        pickedOptions['size'] = item.options[0];
      } else if (item.title == "weight") {
        pickedOptions['weight'] = item.options[0];
      }
    }
    if (colors != null && colors.isNotEmpty) {
      pickedColor.value = colors[0];
    } else {
      pickedColor.value = null;
    }
    if (isVar) {
      getNewPrice(currentProduct.value.id,
          colors != null && colors.isNotEmpty ? colors[0] : null);
    }
  }

  getNormalProductData(String productID) {
    if (presenter == null) {
      presenter =
          ProductsPresenter(context: Get.context, detailsCallBack: this);
    }
    presenter.getProductDetails(productID);
  }

  changeSize(int index, String value, int itemID) {
    chosenSizeIndex.value = index;
    pickedOptions['size'] = value;
    getNewPrice(itemID, pickedColor.value);
  }

  changeWeight(int index, String value, int itemID) {
    chosenWeightIndex.value = index;
    pickedOptions['weight'] = value;
    getNewPrice(itemID, pickedColor.value);
  }

  changeColor(int index, String value, int itemID) {
    chosenColorIndex.value = index;
    pickedColor.value = value;
    getNewPrice(itemID, value);
  }

  getNewPrice(int id, String color) {
    List toSendOptions = [];
    for (var item in pickedOptions.values) {
      toSendOptions.add({"name": item.toString()});
    }
    ProductOptionProvider().getNewPrice(id, toSendOptions, color);
  }

  changeVarPriceModel(VarPriceModel newVarPriceModel) {
    varPriceModel.value = newVarPriceModel;
    print(varPriceModel.value.price);
    currentProduct.value.price = varPriceModel.value.price;
  }

  addFinalVarAndColor(String variant, String color) {
    finalVariant = variant;
    finalColor = color;
    print(finalColor);
    print(finalVariant);
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: Get.context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onDataLoading(bool show) {
    isLoading.value = show;
  }

  @override
  void onDataSuccess(ProductDetails data) {
    currentProduct.value = data;
    _reviewController.getCurrentReviews(currentProduct.value.reviewsURL);

    options = currentProduct.value.options;
    colors = currentProduct.value.colors;
    Future.delayed(Duration(seconds: 1), () {
      isLoading.value = false;
    });
    init(currentProduct.value.variant ?? false);
    bool test = Get.isRegistered<RelatedProductsController>();
    if (test) {
      RelatedProductsController relatedProductsController = Get.find();
      relatedProductsController.gettingRelatedProducts(data.relatedURL);
      update();
    } else {
      RelatedProductsController relatedProductsController =
          Get.put(RelatedProductsController());
      relatedProductsController.gettingRelatedProducts(data.relatedURL);
      update();
    }
  }

  @override
  void onAdsDataSuccess(AddsProductsData data) {}
}
