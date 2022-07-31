/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/local/dbActions.dart';
import 'package:my_medical_app/data/local/models/recentSearch.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/data/remote/models/searchModel.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/cart/ShoppingCartButtonWidget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/search/searchPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';

class SearchWidget extends StatefulWidget {
  LocalSearchCallBack localSearchCallBack;
  final User user;
  bool viewSearchResult;
  Function onOpenDrawer;
  String hasSearch;

  SearchWidget(
      {this.localSearchCallBack,
      this.viewSearchResult,
      this.user,
      this.onOpenDrawer,
      this.hasSearch});

  @override
  State<StatefulWidget> createState() {
    return SearchWidgetState();
  }
*/
/*  SearchBarWidget(
    this._onSearch,
  );

  Function _onSearch;*//*


}

class SearchWidgetState extends State<SearchWidget> implements SearchBack {
  TextEditingController searchController = new TextEditingController();
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

  // ScrollController _scrollController = ScrollController();

  String searchText = "";

  bool hasSearch = false;

  loadHasSearch() {
    if (!hasSearch) {
      if (widget.hasSearch != null) {

        searchController.text = widget.hasSearch;
        DbActions.addRecentSearch(
            RecentSearch(searchText: widget.hasSearch));
        presenter.loadSearch(
            selectedSearchFilter == null
                ? ""
                : selectedSearchFilter.key,
            widget.hasSearch,
            selectedSortBy == null
                ? ""
                : selectedSortBy.key,null);
      }

      hasSearch = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadHasSearch();
    super.initState();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     if (current_page < last_page) {
    //       current_page++;
    //       noProducts = false;
    //       // presenter.getAllProductssData(url, current_page.toString());
    //       presenter.loadSearch("", searchText, current_page.toString());
    //     }
    //   }
    // });

    if (presenter == null) {
      presenter = SearchPresenter(context: context, callBack: this);
    }
  }

  List<SearchFilter> searchFilterList = List();
  SearchFilter selectedSearchFilter;

  List<SearchFilter> sortByList = List();
  SearchFilter selectedSortBy;

  loadFilterBy() {
    if (searchFilterList.length == 0) {
      setState(() {
        searchFilterList.add(SearchFilter(
            key: "category",
            value: "Categories"));
        searchFilterList.add(SearchFilter(
            key: "brand",
            value: "Brand"));
        searchFilterList.add(SearchFilter(
            key: "shop",
            value: "Shop"));
        searchFilterList.add(SearchFilter(
            key: "product",
            value: "Product"));
      });
    }
  }

  loadSortBy() {
    if (sortByList.length == 0) {
      setState(() {
        sortByList.add(SearchFilter(
            key: "price_low_to_high",
            value:
                translator.translate('price_low_to_high')));
        sortByList.add(SearchFilter(
            key: "price_high_to_low",
            value:
                translator.translate('price_high_to_low')));
        sortByList.add(SearchFilter(
            key: "new_arrival",
            value: translator.translate('newest_products')));
        sortByList.add(SearchFilter(
            key: "popularity",
            value: translator.translate('popularity')));
        sortByList.add(SearchFilter(
            key: "top_rated",
            value: translator.translate('top_rated')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadFilterBy();
    loadSortBy();

    return Container(
        child: Column(
      children: [
        Container(
          child: Row(
            children: [
*/
/*
              IconButton(
                icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
                onPressed: widget.onOpenDrawer,
              ),
*//*

              Expanded(
                  child: Stack(
                alignment: Constants.LANG == "en"
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                children: <Widget>[
                  TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      //value is entered text after ENTER press
                      //you can also call any function here or make setState() to assign value to other variable
                      if (value.length > 0) {
                        presenter.loadSearch(
                            selectedSearchFilter == null
                                ? ""
                                : selectedSearchFilter.key,
                            value,
                            selectedSortBy == null
                                ? ""
                                : selectedSortBy.key,null);
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText:
                          translator.translate('search'),
                      hintStyle: TextStyle(
                          color: Theme.of(context).focusColor.withOpacity(0.8)),
                      */
/*prefixIcon: Icon(UiIcons.loupe,
                          size: 20, color: Theme.of(context).hintColor),*//*




                      prefixIcon: GestureDetector(
                        onTap: () {
                          if(searchController.text.length >0){
                            presenter.loadSearch(
                                selectedSearchFilter == null
                                    ? ""
                                    : selectedSearchFilter.key,
                                searchController.text,
                                selectedSortBy == null
                                    ? ""
                                    : selectedSortBy.key,null);
                          }

                        },
                        child: Icon(Icons.loupe,
                            size: 20, color: Theme.of(context).hintColor),
                      ),






                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onTap: () {
                      loadRecentSearch();
                    },
                    onChanged: (text) {
                      setState(() {
                        if (text.length == 0) {
                          showClear = false;
                          widget.localSearchCallBack
                              .onLoadCurrentProducts(true);
                        } else {
                          showClear = true;
                        }
                      });

                      if (text.length > 0) {
                        if (timer != null) {
                          timer.cancel();
                          print("timer --> cancel");
                        }

                        timer = Timer(Duration(milliseconds: SEARCH_DELAY), () {
                          setState(() {
                            print("timer --> run");
                            // presenter.loadAllSearch("search", text);
                            // viewSearchResult = true;
                            searchText = text;
                            DbActions.addRecentSearch(
                                RecentSearch(searchText: text));
                            presenter.loadSearch(
                                selectedSearchFilter == null
                                    ? ""
                                    : selectedSearchFilter.key,
                                searchText,
                                selectedSortBy == null
                                    ? ""
                                    : selectedSortBy.key,null);
                          });
                        });
                      } else {
                        setState(() {
                          searchData.clear();
                          searchText = "";
                          current_page = 1;
                          last_page = 1;
                          widget.viewSearchResult = false;
                        });
                      }
                    },
                  ),
                  Visibility(
                    visible: showClear,
                    child: IconButton(
                        icon: Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            searchText = "";
                            current_page = 1;
                            last_page = 1;
                            showClear = false;
                            searchController.clear();
                            searchData.clear();
                            widget.viewSearchResult = false;
                          });
                        }),
                  )
                ],
              )),
*/
/*
              ShoppingCartButtonWidget(),
*//*

*/
/*
              Container(
                  width: 30,
                  height: 30,
                  margin: Constants.LANG == "en"
                      ? EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20)
                      : EdgeInsets.only(top: 12.5, bottom: 12.5, left: 20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () {
                      Navigator.of(context).pushNamed('/Pages', arguments: 1);
                    },
                    child: CircleAvatar(
                      backgroundImage: widget.user == null
                          ? Container() :widget.user.avatar == null ? AssetImage('assets/images/user.jpg')
                          : NetworkImage(widget.user.avatar),
                      onBackgroundImageError: (e, ex) {
                        print('Error ==> user.avatar load faild');
                      },
                    ),
                  )),
*//*

            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.width* 3),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.10),
                  offset: Offset(0, 4),
                  blurRadius: 10)
            ],
          ),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 6,
                padding: EdgeInsets.only(
                    left: 20, right: 20),
                // padding: EdgeInsets.all(SizeConfig.wUnit * 3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20),
                      */
/*            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context).hintColor.withOpacity(0.10),
                                    offset: Offset(0, 4),
                                    blurRadius: 10)
                              ],
                            ),*//*

                      child: DropdownButtonFormField(
                        isExpanded: true,
                        hint: Text(translator
                            .translate('filter_by')),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        value: selectedSearchFilter,
                        items: searchFilterList.map((SearchFilter filter) {
                          return new DropdownMenuItem<SearchFilter>(
                            value: filter,
                            child: new Text(
                              filter.value,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedSearchFilter = newValue;

                            if (searchController.text.toString().trim().length >
                                0) {
                              presenter.loadSearch(
                                  selectedSearchFilter == null
                                      ? ""
                                      : selectedSearchFilter.key,
                                  searchText,
                                  selectedSortBy == null
                                      ? ""
                                      : selectedSortBy.key,null);
                            }
                          });
                        },
                      ),
                    )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width* 2,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left:20,
                            right: 20),
                        */
/*     decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).hintColor.withOpacity(0.10),
                                  offset: Offset(0, 4),
                                  blurRadius: 10)
                            ],
                          ),*//*

                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text(translator
                              .translate('sort_by')),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                          value: selectedSortBy,
                          items: sortByList.map((SearchFilter filter) {
                            return new DropdownMenuItem<SearchFilter>(
                              value: filter,
                              child: new Text(
                                filter.value,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedSortBy = newValue;

                              if (searchController.text
                                      .toString()
                                      .trim()
                                      .length >
                                  0) {
                                presenter.loadSearch(
                                    selectedSearchFilter == null
                                        ? ""
                                        : selectedSearchFilter.key,
                                    searchText,
                                    selectedSortBy == null
                                        ? ""
                                        : selectedSortBy.key,null);
                              }
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                  visible: widget.viewSearchResult,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(20),
                        child: ListView.builder(
                          itemCount: searchData.length,
                          // controller: _scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // double _marginLeft = 0;
                            // (index == 0) ? _marginLeft = 12 : _marginLeft = 0;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  showClear = true;
                                  searchController.text =
                                      searchData[index].searchText;
                                  searchText = searchData[index].searchText;
                                });

                                presenter.loadSearch(
                                    selectedSearchFilter == null
                                        ? ""
                                        : selectedSearchFilter.key,
                                    searchData[index].searchText,
                                    selectedSortBy == null
                                        ? ""
                                        : selectedSortBy.key,null);
                              },
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  searchData[index].searchText,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  maxLines: 1,
                                  // softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.vertical,
                        ),
                      ),
                      Visibility(
                        visible: noProducts,
                        child: Center(
                          child: Opacity(
                            opacity: 0.4,
                            child: Text(
                              translator
                                      .translate('there_are_no') +
                                  " " +
                                  translator
                                      .translate('products'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline3.merge(
                                  TextStyle(fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Visibility(
                          child: CircularProgressIndicator(),
                          visible: isLoadingData,
                        ),
                      )
                    ],
                  ))
            ],
          ),
        )
      ],
    ));
  }

  loadRecentSearch() async {
    var futurerecentSearch = await DbActions.getRecentSearch();

    List<RecentSearch> recentSearch = List();

    for (final node in futurerecentSearch) {
      final r = RecentSearch(id: node.id, searchText: node.searchText);

      recentSearch.add(r);
    }

    print("recentSearch count: " + recentSearch.length.toString());

    if (recentSearch.length > 0) {
      setState(() {
        searchData.clear();
        searchData.addAll(recentSearch);
        widget.viewSearchResult = true;
      });
    }
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(errorText: message,
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
      widget.viewSearchResult = false;
    });
    Meta meta = Meta(
        currentPage: data.meta.currentPage,
        from: data.meta.from,
        lastPage: data.meta.lastPage,
        path: data.meta.path,
        perPage: data.meta.perPage,
        to: data.meta.to,
        total: data.meta.total);
    print(data.links.next);
    List<Product> productList = List();

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
          null,
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
      p.isFavorite));
    }

    widget.localSearchCallBack.onSearchDataSuccess(productList, meta);

    */
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
    });*//*

  }
}

abstract class LocalSearchCallBack {
  void onSearchDataSuccess(List<Product> data, Meta meta);

  void onLoadCurrentProducts(bool load);
}
*/
