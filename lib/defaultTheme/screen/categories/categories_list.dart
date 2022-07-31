import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/categoriesPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/main_category_model.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/sub_sub_category_model.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsScreen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

class CategoriesList extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  CategoriesList({this.scaffoldKey});

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList>
    implements MainCategoriesCallBack {
  bool isLogged = false;
  bool isLoadingData = false;
  CategoriesPresenter presenter;
  List<MainCategoryModel> mainCategoriesList = List();
  MainCategoryModel selectedMainCategory;
  List<SubSubCategoryModel> finalSubList = [];

  @override
  void initState() {
    if (presenter == null) {
      presenter =
          CategoriesPresenter(context: context, mainCategoriesCallBack: this);
      presenter.getMainCategoriesData();
    }
    super.initState();
  }

  //MM-48 Added exit popup to the categories screen
  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('${translator.translate("exit_app")}'),
            content: Text("${translator.translate('do_you_want_to_exit')}"),
            actions: [
              MaterialButton(
                  onPressed: () => Get.back(),
                  //MM-47 Change button color
                  child: Text(
                    '${translator.translate("no")}',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor),
              MaterialButton(
                  onPressed: () => SystemNavigator.pop(),
                  //return true when click on "Yes"
                  //MM-47 Change button color
                  child: Text(
                    '${translator.translate("yes")}',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //MM-48 Calls exit popup when user press back button
      onWillPop: showExitPopup, //call function on back button press
      child: Scaffold(
        body: isLoadingData
            ? SpinKitChasingDots(
                color: primaryColor,
              )
            : Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListView.builder(
                        itemCount: mainCategoriesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  selectedMainCategory =
                                      mainCategoriesList[index];
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      "${mainCategoriesList[index].name}",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: selectedMainCategory.id ==
                                                  mainCategoriesList[index].id
                                              ? Colors.black
                                              : primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(children: [
                              Card(
                                child: Column(
                                  children: [
                                    Wrap(
                                      spacing: 7,
                                      children:
                                          selectedMainCategory.subCats.map((e) {
                                        return GestureDetector(
                                          onTap: () {
                                            SearchFilter sortBy = SearchFilter(
                                                key: "new_arrival",
                                                value: translator
                                                    .translate('new_arrival'));
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return ProductsScreen(
                                                widgetSearchText: "${e.name}",
                                                search: true,
                                                widgetSelectedSearchFilter:
                                                    SearchFilter(
                                                        key: "category",
                                                        value: "Categories"),
                                                widgetSortByFilter: sortBy,
                                              );
                                            }));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                e.icon == ""
                                                    ? Image.asset(
                                                        "assets/images/default_image_product.png")
                                                    : Image.network(
                                                        "${Constants.IMAGE_BASE_URL}${e.icon}",
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                      "${e.name}",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: widget.scaffoldKey.currentContext,
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
  void onDataSuccess(List<MainCategoryModel> data) {
    setState(() {
      mainCategoriesList.clear();
      mainCategoriesList.addAll(data);
      selectedMainCategory = mainCategoriesList[0];
      for (MainCategoryModel item in mainCategoriesList){
        print(item.name);
      }
    });
  }

/*  @override
  void onSubCatDataSuccess(
      List<SubCategoryData> data, List<SubSubCategoryData> subData) {
    setState(() {
      subCategoriesList.clear();
      subCategoriesList.addAll(data);
      subSubCategoriesList.clear();
      subSubCategoriesList.addAll(subData);
    });
  }

  @override
  void onSubDataError(String message) {
    showDialog(
        context: widget.scaffoldKey.currentContext,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onSubDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }*/
}
