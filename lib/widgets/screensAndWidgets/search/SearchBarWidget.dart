import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/models/searchModel.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/defaultTheme/screen/products/navigationModel.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/search/searchPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';

class SearchBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchBarWidgetState();
  }
/*  SearchBarWidget(
    this._onSearch,
  );

  Function _onSearch;*/

}

class SearchBarWidgetState extends State<SearchBarWidget>
    implements SearchBack {
  TextEditingController searchController = new TextEditingController();
  int SEARCH_DELAY = 800;
  Timer timer;

  bool showClear = false;
  bool isLoadingData = false;
  bool viewSearchResult = false;
  List<SearchData> searchData = List();
  bool noProducts = false;
  SearchPresenter presenter;

  int current_page = 1;
  int last_page = 1;
  String nextURL;
  ScrollController _scrollController = ScrollController();

  String searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (current_page < last_page) {
          current_page++;
          noProducts = false;
          // presenter.getAllProductssData(url, current_page.toString());
          // presenter.loadSearch("", searchText, current_page.toString(), "");
        }
      }
    });

    if (presenter == null) {
      presenter = SearchPresenter(context: context, callBack: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Column(
          children: [
            Stack(
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
                      Navigator.of(context).pushNamed('/Products',
                          arguments:
                              NavigationModel(action: "search", url: value));
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: Theme.of(context).focusColor.withOpacity(0.8)),
                    /*prefixIcon: Icon(UiIcons.loupe,
                        size: 20, color: Theme.of(context).hintColor),*/

                    prefixIcon: GestureDetector(
                      onTap: () {
                        if (searchController.text.length > 0) {
                          Navigator.of(context).pushNamed('/Products',
                              arguments: NavigationModel(
                                  action: "search",
                                  url: searchController.text));
                        }
                      },
                      child: Icon(Icons.loupe,
                          size: 20, color: Theme.of(context).hintColor),
                    ),

                    /*prefixIcon: IconButton(
                      icon: new Icon(Icons.loupe,
                          size: 20,
                          color: Theme.of(context).hintColor),
                      onPressed: () {

                        // Navigator.of(context).pushNamed('/Products');

                      */ /*  Navigator.of(context).pushNamed('/Products',
                            arguments: NavigationModel(action: "search", url: Constants.BASE_URL +
                                "categories/getProductsBySubSub/" +
                                sc.id.toString()));*/ /*

                      },
                    ),*/
                    /* suffixIcon: Visibility(
                visible: showClear,
                child: clearSearch,
              ),*/
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onChanged: (text) {
                    setState(() {
                      if (text.length == 0) {
                        showClear = false;
                      } else {
                        showClear = true;
                      }
                    });

                    if (text.length > 0) {
                      /*Future.delayed(Duration(milliseconds: SEARCH_DELAY), () {
                      setState(() {
                          presenter.loadAllSearch("search", text);
                      });
                    });*/

                      if (timer != null) {
                        timer.cancel();
                        print("timer --> cancel");
                      }

                      timer = Timer(Duration(milliseconds: SEARCH_DELAY), () {
                        setState(() {
                          print("timer --> run");
                          // presenter.loadAllSearch("search", text);
                          viewSearchResult = true;
                          searchText = text;
/*
                          presenter.loadSearch(
                              "", text, current_page.toString(), "");
*/
                        });
                      });
                    } else {
                      setState(() {
                        searchData.clear();
                        searchText = "";
                        current_page = 1;
                        last_page = 1;
                        viewSearchResult = false;
                      });
                    }
                  },
                ),
                /*IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(UiIcons.settings_2,
                size: 20, color: Theme.of(context).hintColor.withOpacity(0.5)),
          ),*/
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
                          viewSearchResult = false;
                        });
                      }),
                )
              ],
            ),
            Visibility(
                visible: viewSearchResult,
                child: Stack(
                  children: [
                    Container(
                      height: SizeConfig.vUnit * 30,
                      margin: EdgeInsets.all(SizeConfig.wUnit * 5),
                      child: ListView.builder(
                        itemCount: searchData.length,
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // double _marginLeft = 0;
                          // (index == 0) ? _marginLeft = 12 : _marginLeft = 0;
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/ProductDetails',
                                  arguments: Product(
                                      searchData[index].id,
                                      searchData[index].name,
                                      [],
                                      searchData[index].thumbnailImage,
                                      double.parse(searchData[index]
                                          .basePrice
                                          .toString()),
                                      double.parse(searchData[index]
                                          .baseDiscountedPrice
                                          .toString()),
                                      0,
                                      0,
                                      "0",
                                      "",
                                      "",
                                      0,
                                      "",
                                      searchData[index].rating,
                                      null,
                                      0,
                                      searchData[index].links.details,
                                      searchData[index].links.reviews,
                                      searchData[index].links.related,
                                      searchData[index].links.topFromSeller,
                                      searchData[index].country,
                                      searchData[index].isFavorite));
                            },
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                    width: SizeConfig.wUnit * 20,
                                    height: SizeConfig.vUnit * 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            searchData[index].thumbnailImage ==
                                                    null
                                                ? AssetImage(
                                                    'assets/images/logo.png')
                                                : NetworkImage(
                                                    Constants.IMAGE_BASE_URL +
                                                        searchData[index]
                                                            .thumbnailImage),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.wUnit * 2,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        searchData[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        maxLines: 1,
                                        // softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            searchData[index]
                                                .basePrice
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            maxLines: 1,
                                            // softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.wUnit * 2,
                                          ),
                                          Visibility(
                                            visible:
                                                searchData[index].basePrice >
                                                        searchData[index]
                                                            .baseDiscountedPrice
                                                    ? true
                                                    : false,
                                            child: Text(
                                              searchData[index]
                                                  .basePrice
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ))
                                ],
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
                            "There are now" + " " + "Products",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .merge(TextStyle(fontWeight: FontWeight.w300)),
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
        ));
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
    current_page = data.meta.currentPage;
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

      searchData.addAll(data.data);
    });
  }
}
