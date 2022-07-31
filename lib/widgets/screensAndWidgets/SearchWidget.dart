import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/app/modules/products_search/controllers/products_search_controller.dart';
import 'package:my_medical_app/app/modules/products_search/views/products_search_view.dart';
import 'package:my_medical_app/data/local/dbActions.dart';
import 'package:my_medical_app/data/local/models/recentSearch.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/data/remote/models/searchModel.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsScreen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/services/search_controller.dart';
import 'package:my_medical_app/services/search_history_helper.dart';
import 'package:my_medical_app/size_config.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/cart/ShoppingCartButtonWidget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/search/searchPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:supercharged/supercharged.dart';

class SearchWidget extends StatefulWidget {
  final LocalSearchCallBack localSearchCallBack;
  final User user;
  final bool viewSearchResult;
  final Function onOpenDrawer;
  final bool hasSearch;
  final bool isHidden;
  final String searchText;
  SearchFilter widgetSelectedSearchFilter;
  SearchFilter widgetSelectedSortFilter;

  SearchWidget(
      {this.localSearchCallBack,
      this.viewSearchResult,
      this.searchText,
      this.widgetSelectedSearchFilter,
      this.widgetSelectedSortFilter,
      this.user,
      this.onOpenDrawer,
      @required this.hasSearch,
      @required this.isHidden});

  @override
  State<StatefulWidget> createState() {
    return SearchWidgetState();
  }
/*  SearchBarWidget(
    this._onSearch,
  );

  Function _onSearch;*/

}

class SearchWidgetState extends State<SearchWidget> implements SearchBack {
  int SEARCH_DELAY = 800;
  Timer timer;

  bool showClear = false;
  bool isLoadingData = false;

  // bool viewSearchResult = false;
  List<RecentSearch> searchData = List();
  bool noProducts = false;
  SearchPresenter presenter;

  int current_page = 1;
  int last_page = 1;
  String nextURL;
  ScrollController _scrollController = ScrollController();

  bool showSuggestions = false;

  String searchText = "";

  bool hasSearch = false;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double wUnit;
  static double vUnit;

  SearchFilter selectedSortBy;
  List<dynamic> suggestionList = [];

  ProductsSearchController productsSearchController =
      Get.isRegistered<ProductsSearchController>()
          ? Get.find()
          : Get.put(ProductsSearchController());

  @override
  Widget build(BuildContext context) {
    // loadHasSearch();
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    vUnit = screenHeight / 100;
    return Obx(() => Container(
            child: Column(
          children: [
            !productsSearchController.searchIsVisible.value
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 1),
                    child: Row(
                      children: [
                        Expanded(
                            child: Stack(
                          alignment: Constants.LANG == "en"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller:
                                    productsSearchController.searchController,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  //value is entered text after ENTER press
                                  //you can also call any function here or make setState() to assign value to other variable
                                  productsSearchController
                                      .doNormalSearch(value);
                                  // if (value.length > 0) {
                                  //   c.doSearch(
                                  //       selectedSearchFilter == null
                                  //           ? ""
                                  //           : selectedSearchFilter.key,
                                  //       value,
                                  //       selectedSortBy == null
                                  //           ? ""
                                  //           : selectedSortBy.key,
                                  //       false);
                                  // }
                                  SearchHistoryHelpers()
                                      .saveSearchHistory(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    /*
                                          borderSide: BorderSide(
                                            width: 2,
                                            style: BorderStyle.none,
                                          ),
    */
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: translator.translate('search'),
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.8)),
                                  /*prefixIcon: Icon(UiIcons.loupe,
                                      size: 20, color: Theme.of(context).hintColor),*/
                                ),
                                onTap: () {
                                  if (productsSearchController
                                          .searchController.text ==
                                      "") {
                                    SearchHistoryHelpers()
                                        .getInitialSearchHistory()
                                        .then((value) {
                                      if (value.length > 0) {
                                        showSuggestions = true;
                                        suggestionList = value;
                                        setState(() {});
                                      }
                                    });
                                  }
                                },
                                onChanged: (text) async {
                                  if (productsSearchController
                                          .searchController.text.length >
                                      0) {
                                    showClear = true;
                                  } else {
                                    showClear = false;
                                  }
                                  setState(() {});
                                  if (text == "") {
                                    SearchHistoryHelpers()
                                        .getInitialSearchHistory()
                                        .then((value) {
                                      print(value);
                                      if (value.length > 0) {
                                        showSuggestions = true;
                                        suggestionList = value;
                                        setState(() {});
                                      }
                                    });
                                  } else {
                                    await SearchHistoryHelpers()
                                        .getSearchHistory(text)
                                        .then((value) {
                                      if (value.length > 0) {
                                        showSuggestions = true;
                                        suggestionList = value;
                                        setState(() {});
                                      }
                                    });

                                    await SearchHistoryHelpers()
                                        .getSearchHistory(text)
                                        .then((value) {
                                      if (value.length > 0) {
                                        showSuggestions = true;
                                        suggestionList = value;
                                        setState(() {});
                                      } else {
                                        showSuggestions = false;
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                  icon: Icon(Icons.search, size: 30),
                                  onPressed: () {
                                    setState(() {
                                      if (productsSearchController
                                              .searchController.text.length >
                                          0) {
                                        productsSearchController.doNormalSearch(
                                            productsSearchController
                                                .searchController.text);
                                        SearchHistoryHelpers()
                                            .saveSearchHistory(
                                                productsSearchController
                                                    .searchController.text);
                                      }
                                    });
                                  }),
                            )
                          ],
                        )),
                        GestureDetector(
                            onTap: () {
                              SearchFilter sortBy = SearchFilter(
                                  key: "new_arrival",
                                  value: translator.translate('new_arrival'));
                              productsSearchController
                                  .changeSearchVisibility(false);
                              setState(() {});
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return ProductsSearchView();
                              }));
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
            showSuggestions
                ? Card(
                    elevation: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: suggestionList.map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    productsSearchController
                                        .doNormalSearch(e.toString());
                                    productsSearchController
                                        .searchController.text = e;
                                    // c.doSearch(
                                    //     selectedSearchFilter == null
                                    //         ? ""
                                    //         : selectedSearchFilter.key,
                                    //     e,
                                    //     selectedSortBy == null
                                    //         ? ""
                                    //         : selectedSortBy.key,
                                    //     false);
                                    showSuggestions = false;
                                    suggestionList.clear();
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          radius: 13,
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        e,
                                        style: TextStyle(fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                SearchHistoryHelpers()
                                    .clearSearchHistory()
                                    .then((value) {
                                  showSuggestions = false;
                                  setState(() {});
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                      "${translator.translate("clear_history")}"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.all(wUnit * 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.10),
                      offset: Offset(0, 4),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text("${translator.translate('sort_by')} "),
                          Container(
                              height: vUnit * 6,
                              padding: EdgeInsets.only(
                                  left: wUnit * 2, right: wUnit * 2),
                              // padding: EdgeInsets.all(wUnit * 3),
                              child: Row(
                                children: [
                                  GetBuilder<ProductsSearchController>(
                                    init: ProductsSearchController(),
                                    initState: (_) {},
                                    builder: (_) {
                                      return DropdownButton<SearchFilter>(
                                        value: productsSearchController
                                            .selectedSortBy.value,
                                        icon: Icon(
                                          Icons.arrow_drop_down_circle,
                                          color: primaryColor,
                                        ),
                                        elevation: 16,
                                        style: TextStyle(color: primaryColor),
                                        underline: Container(
                                          height: 2,
                                          color: primaryColor,
                                        ),
                                        onChanged: (SearchFilter newValue) {
                                          setState(() {
                                            productsSearchController
                                                .selectedSortBy
                                                .value = newValue;
                                            productsSearchController
                                                .changeSortBy();
                                          });
                                        },
                                        items: productsSearchController
                                            .sortByList
                                            .map<
                                                    DropdownMenuItem<
                                                        SearchFilter>>(
                                                (SearchFilter value) {
                                          return DropdownMenuItem<SearchFilter>(
                                            value: value,
                                            child: Text(value.value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  )
                                ],
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text("${translator.translate('filters')} "),
                          productsSearchController.isShowingFilter.value
                              ? GestureDetector(
                                  onTap: () {
                                    productsSearchController
                                        .toggleShowingFilters();
                                  },
                                  child: Icon(Icons.clear))
                              : GestureDetector(
                                  onTap: () {
                                    productsSearchController
                                        .toggleShowingFilters();
                                  },
                                  child: Icon(Icons.arrow_drop_down))
                        ],
                      ),
                    ],
                  ),
                  productsSearchController.isShowingFilter.value
                      ? Obx(
                          () => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${translator.translate("price")}",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ],
                                ),
                                RangeSlider(
                                    values: productsSearchController
                                        .selectedRange.value,
                                    onChanged: (RangeValues newRange) {
                                      productsSearchController
                                          .changePrices(newRange);
                                    },
                                    labels: RangeLabels(
                                        '${productsSearchController.selectedRange.value.start.toStringAsFixed(2)}',
                                        '${productsSearchController.selectedRange.value.end.toStringAsFixed(2)}'),
                                    min:
                                        productsSearchController.minPrice.value,
                                    max:
                                        productsSearchController.maxPrice.value,
                                    activeColor: primaryColor,
                                    divisions: int.parse(
                                        productsSearchController.maxPrice.value
                                            .toString()
                                            .split(".")[0]),
                                    semanticFormatterCallback: (number) {
                                      return number.toString().split(".")[0];
                                    }),
                                GetBuilder<ProductsSearchController>(
                                  init: ProductsSearchController(),
                                  initState: (_) {},
                                  builder: (_) {
                                    return SizedBox(
                                      height: context.height * 0.4,
                                      child: Scrollbar(
                                        controller: productsSearchController
                                            .colorsHashScrollController,
                                        isAlwaysShown: true,
                                        child: ListView(
                                          controller: productsSearchController
                                              .colorsHashScrollController,
                                          scrollDirection: Axis.vertical,
                                          children: productsSearchController
                                              .allAttributes
                                              .map((element) {
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      element.name,
                                                      style: TextStyle(
                                                          color: primaryColor),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: context.height * 0.06,
                                                  child: ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: element.options
                                                          .map((e) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              productsSearchController
                                                                  .addOrRemoveFilters(
                                                                      element
                                                                          .id,
                                                                      e);
                                                            },
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: productsSearchController
                                                                            .filtersPreBody[element
                                                                                .id]
                                                                            .contains(
                                                                                e)
                                                                        ? primaryColor
                                                                        : Colors
                                                                            .white),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    e,
                                                                    style: TextStyle(
                                                                        color: productsSearchController.filtersPreBody[element.id].contains(e)
                                                                            ? Colors.white
                                                                            : Colors.black),
                                                                  ),
                                                                )),
                                                          ),
                                                        );
                                                      }).toList()),
                                                )
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                MaterialButton(
                                  color: primaryColor,
                                  onPressed: () =>
                                      productsSearchController.applyFilters(),
                                  splashColor: Colors.blueGrey,
                                  child: Text(
                                    '${translator.translate("apply")}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        )));
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onSearchDataSuccess(SearchModel data) {
    setState(() {
      // widget.viewSearchResult = false;
    });
    Meta meta = Meta(
        currentPage: data.meta.currentPage,
        from: data.meta.from,
        lastPage: data.meta.lastPage,
        path: data.meta.path,
        perPage: data.meta.perPage,
        to: data.meta.to,
        total: data.meta.total);

    List<Product> productList = List();
    nextURL = data.links.next;
    for (SearchData p in data.data) {
      productList.add(Product(
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

    widget.localSearchCallBack.onSearchDataSuccess(productList, meta);

    /*  current_page = data.meta.currentPage;
    last_page = data.meta.lastPage;
    setState(() {
      if (data.data.length == 0) {
        noProducts = true;
      } else {
        noProducts = false;
      }

      if (last_page == 1) {
        searchData.clear();
      }

      // searchData.addAll(data.data);
    });*/
  }
}

abstract class LocalSearchCallBack {
  void onSearchDataSuccess(List<Product> data, Meta meta);

  void onLoadCurrentProducts(bool load);
}
