import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/app/modules/products_search/providers/search_product_provider.dart';
import 'package:my_medical_app/app/modules/products_search/search_product_model.dart';
import 'package:my_medical_app/data/remote/models/searchModel.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/wishlist/wishListPresenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/search/searchPresenter.dart';

import '../../../../ui/models/user.dart';

class ProductsSearchController extends GetxController
    implements AddCartCallBack, AddWishListCallBack, SearchBack {
  var viewSearchResult = false.obs;
  var widgetSearchText = "".obs;
  var widgetSelectedSearchFilter = SearchFilter().obs;
  var widgetSortByFilter = SearchFilter().obs;
  var searchText = "".obs;
  var search = false.obs;
  var user = User().obs;
  var isLogged = false.obs;
  var isLoadingData = false.obs;
  var isLoadingMore = false.obs;
  var productsList = <Product>[].obs;
  var nextURL = "".obs;
  var searchIsVisible = false.obs;
  var searchFilterList = <SearchFilter>[].obs;
  var selectedSearchFilter = SearchFilter().obs;
  var selectedSortBy = SearchFilter().obs;
  var sortByList = <SearchFilter>[].obs;
  var allColorsHash = <String>[].obs;
  var allAttributes = <Attributes>[].obs;
  var isShowingFilter = false.obs;
  var chosenColorHex = "".obs;
  var chosenSizes = <String>[].obs;
  var filtersPreBody = <String, List>{}.obs;
  var selectedRange = RangeValues(0, 1).obs;
  var minPrice = 0.0.obs;
  var maxPrice = 0.0.obs;
  TextEditingController searchController = new TextEditingController();

  ScrollController colorsHashScrollController = ScrollController();
  ScrollController scrollController = ScrollController();
  CartPresenter cartPresenter;
  WishListPresenter wishPresenter;
  SearchPresenter searchPresenter;

  SearchProductProvider searchProductProvider =
      Get.isRegistered<SearchProductProvider>()
          ? Get.find()
          : Get.put(SearchProductProvider());

  @override
  void onInit() {
    loadFilterBy();
    loadSortBy();
    super.onInit();
  }

  init(String searchFromParent) {
    searchText.value = searchFromParent;
    if (searchPresenter == null) {
      searchPresenter = SearchPresenter(context: Get.context, callBack: this);
    }

    if (cartPresenter == null) {
      cartPresenter =
          CartPresenter(context: Get.context, addCartCallBack: this);
    }
    if (wishPresenter == null) {
      wishPresenter =
          WishListPresenter(context: Get.context, addWishListCallBack: this);
    }

    if (searchText != null) {
      widgetSearchText.value = searchText.value;
    }
    if (!search.value) {
      //TODO: do intial search
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        isLoadingMore.value = true;
        searchProductProvider
            .doPaginationSearch(searchController.text, selectedSortBy.value.key,
                int.parse(nextURL.value.split("page=").last))
            .then((resp) {
          print(resp.minPrice);
          print(resp.originalMinPrice);
          isLoadingData.value = true;
          allColorsHash.value = resp.allColors;
          allAttributes.value = resp.attributes;
          for (Attributes singleAttribute in allAttributes) {
            filtersPreBody[singleAttribute.id] = [];
          }
          selectedRange.value =
              RangeValues(resp.originalMinPrice, resp.originalMaxPrice);
          minPrice.value = double.parse(resp.originalMinPrice.toString());
          maxPrice.value = double.parse(resp.originalMaxPrice.toString());
          for (var item in resp.products.details) {
            Product _product = Product(
                item.id,
                item.name,
                item.photos,
                item.thumbnailImage,
                item.basePrice,
                item.baseDiscountedPrice,
                item.todaysDeal,
                item.featured,
                item.currentStock.toString(),
                item.tags,
                item.hashtagIds,
                item.discount,
                item.discountType,
                item.rating.toString(),
                null,
                item.sales,
                item.links.details,
                item.links.reviews,
                item.links.related,
                item.links.topFromSeller,
                item.country,
                item.isFavorite);
            productsList.add(_product);
          }
          nextURL.value = resp.products.pagination.next;
          print(nextURL);
          update();
          isLoadingMore.value = false;
        });
      }
    });
    if (search != null) {
      searchIsVisible.value = true;
    }
    Helpers.getUserData().then((_user) {
      isLogged.value = _user.isLoggedIn;
      user.value = _user;
    });
    if (nextURL.value == "") {
      doInitialSearch();
    }
  }

  loadFilterBy() {
    if (searchFilterList.length == 0) {
      searchFilterList.add(SearchFilter(
          key: "category", value: translator.translate('categories')));
      searchFilterList.add(SearchFilter(
          key: "brand", value: translator.translate('filter_brands')));
      searchFilterList.add(SearchFilter(
          key: "shop", value: translator.translate('filter_shops')));
      searchFilterList.add(SearchFilter(
          key: "product", value: translator.translate('products')));
    }
    selectedSearchFilter.value = searchFilterList[0];
    update();
  }

  loadSortBy() {
    if (sortByList.length == 0) {
      sortByList.add(SearchFilter(
          key: "price_low_to_high",
          value: translator.translate('price_low_to_high')));
      sortByList.add(SearchFilter(
          key: "price_high_to_low",
          value: translator.translate('price_high_to_low')));
      sortByList.add(SearchFilter(
          key: "new_arrival", value: translator.translate('newest_products')));
      sortByList.add(SearchFilter(
          key: "popularity", value: translator.translate('popularity')));
      sortByList.add(SearchFilter(
          key: "top_rated", value: translator.translate('top_rated')));
    }
    selectedSortBy.value = sortByList[2];
    update();
  }

  doNormalSearch(String text) {
    //TODO do normal search
  }
  toggleSearchResult(bool newState) {
    viewSearchResult.value = newState;
  }

  openDrawer() {
    Scaffold.of(Get.context).openDrawer();
  }

  Future<void> handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 1), () {
      completer.complete();
    });
    if (!search.value) {
      //TODO: do intial search
    } else {
      //TODO check for refresh reaction
    }
    return completer.future.then<void>((_) {
      Get.snackbar('${translator.translate("refresh_complete")}',
          'i am a modern snackbar');
    });
  }

  addToFavorite(Product e) {
    Helpers.isLoggedIn().then((_result) {
      if (_result) {
        e.isFavorite
            ? wishPresenter.removeToWishList(e.id.toString(), true)
            : wishPresenter.addToWishList(e.id.toString(), false);
      } else {
        showDialog(
            context: Get.context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("${translator.translate("must_sign_in")}"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return T3SignIn();
                          }));
                        },
                        child: Text("${translator.translate("sign_in")}"))
                  ],
                ));
      }
    });
  }

  addToCart(Product data) {
    Helpers.isLoggedIn().then((_result) {
      if (_result) {
        cartPresenter.addToCart(data.id.toString(), false, null, null);
      } else {
        showDialog(
            context: Get.context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("${translator.translate("must_sign_in")}"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return T3SignIn();
                          }));
                        },
                        child: Text("${translator.translate("sign_in")}"))
                  ],
                ));
      }
    });
  }

  doInitialSearch() {
    isLoadingData.value = true;
    productsList.clear();

    searchProductProvider.doInitialSearch(widgetSearchText.value).then((resp) {
      allColorsHash.value = resp.allColors;
      allAttributes.value = resp.attributes;
      for (Attributes singleAttribute in allAttributes) {
        filtersPreBody[singleAttribute.id] = [];
      }
      selectedRange.value =
          RangeValues(resp.originalMinPrice, resp.originalMaxPrice);
      minPrice.value = double.parse(resp.originalMinPrice.toString());
      maxPrice.value = double.parse(resp.originalMaxPrice.toString());
      for (var item in resp.products.details) {
        Product _product = Product(
            item.id,
            item.name,
            item.photos,
            item.thumbnailImage,
            item.basePrice,
            item.baseDiscountedPrice,
            item.todaysDeal,
            item.featured,
            item.currentStock.toString(),
            item.tags,
            item.hashtagIds,
            item.discount,
            item.discountType,
            item.rating.toString(),
            null,
            item.sales,
            item.links.details,
            item.links.reviews,
            item.links.related,
            item.links.topFromSeller,
            item.country,
            item.isFavorite);
        productsList.add(_product);
      }
      nextURL.value = resp.products.pagination.next;
      update();
      isLoadingData.value = false;
    });
  }

  changeSortBy() {
    isLoadingData.value = true;
    productsList.clear();
    searchProductProvider
        .changeSortBy(widgetSearchText.value, selectedSortBy.value.key)
        .then((resp) {
      for (var item in resp.products.details) {
        print(item);
        Product _product = Product(
            item.id,
            item.name,
            item.photos,
            item.thumbnailImage,
            item.basePrice,
            item.baseDiscountedPrice,
            item.todaysDeal,
            item.featured,
            item.currentStock.toString(),
            item.tags,
            item.hashtagIds,
            item.discount,
            item.discountType,
            item.rating.toString(),
            null,
            item.sales,
            item.links.details,
            item.links.reviews,
            item.links.related,
            item.links.topFromSeller,
            item.country,
            item.isFavorite);
        productsList.add(_product);
      }
      nextURL.value = resp.products.pagination.next;
      isLoadingData.value = false;
    });
    update();
  }

  changeSearchVisibility(bool newState) {
    searchIsVisible.value = newState;
  }

  changeFilter(SearchFilter selectedValue) {}

  @override
  void onAddCartDataError(String message) {
    // TODO: implement onAddCartDataError
  }

  @override
  void onAddCartDataLoading(bool show) {
    // TODO: implement onAddCartDataLoading
  }

  @override
  void onAddCartDataSuccess(String message, bool gotoShop) {
    // TODO: implement onAddCartDataSuccess
  }

  @override
  void onAddWishListDataError(String message) {
    // TODO: implement onAddWishListDataError
  }

  @override
  void onAddWishListDataLoading(bool show) {
    // TODO: implement onAddWishListDataLoading
  }

  @override
  void onAddWishListDataSuccess(String message, int id, bool isRemove) {
    // TODO: implement onAddWishListDataSuccess
  }

  @override
  void onDataError(String message) {
    // TODO: implement onDataError
  }

  @override
  void onDataLoading(bool show) {
    // TODO: implement onDataLoading
  }

  @override
  void onSearchDataSuccess(SearchModel data) {
    for (SearchData p in data.data) {
      productsList.add(Product(
        p.id,
        p.name,
        null,
        p.thumbnailImage,
        double.parse(p.basePrice.toString()),
        double.parse(p.baseDiscountedPrice.toString()),
        0,
        0,
        p.current_stock.toString(),
        null,
        null,
        0,
        null,
        p.rating,
        null,
        0,
        p.links.details,
        p.links.reviews,
        p.links.related,
        p.links.topFromSeller,
        p.country,
        p.isFavorite,
      ));
    }
  }

  void toggleShowingFilters() {
    isShowingFilter.value = !isShowingFilter.value;
  }

  void changeColor(String element) {
    chosenColorHex.value = element;
  }

  void addOrRemoveFilters(String id, String e) {
    if (filtersPreBody[id].contains(e)) {
      filtersPreBody[id].remove(e);
    } else {
      filtersPreBody[id].add(e);
    }
    update();
  }

  void changePrices(RangeValues newRange) {
    selectedRange.value = newRange;
  }

  void applyFilters() {
    Map<String, dynamic> body = {};
    for (var item in filtersPreBody.entries) {
      String attr = "attribute_${item.key}";
      String allValues =
          item.value.toString().substring(1, item.value.toString().length - 1);

      body[attr] = allValues;
    }
    body['search_query'] = searchController.text;
    body['min_price'] = selectedRange.value.start;
    body['max_price'] = selectedRange.value.end;
  }
}
