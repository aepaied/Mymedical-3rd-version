import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/myPackageModel.dart';
import 'package:my_medical_app/defaultTheme/screen/my_ads/add_new_my_ad.dart';
import 'package:my_medical_app/defaultTheme/screen/my_ads/my_ads_presenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

class MyAdsScreen extends StatefulWidget {
  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    implements AddsProductsCallBack {
  AddsProductsPresenter presenter;
  bool isLoading = false;

  List<AddsProductsData> myAdvsList = [];

  @override
  void initState() {
    if (presenter == null) {
      presenter = AddsProductsPresenter(context: context, callBack: this);
      presenter.getMyAdvs();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "${translator.translate("my_ads")}", isHome: false),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddNewMyAd(isEdit: false);
          }));
        },
      ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : myAdvsList.isEmpty
              ? Center(
                  child: Text('${translator.translate('no_ads_found')}'),
                )
              : ListView(
                  children: myAdvsList.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.17,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return ShProductDetail(
                                        is_ad: true,
                                        productID: e.id,
                                      );
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      e.thumbnailImg == "" ||
                                              e.thumbnailImg == null
                                          ? Image.asset(
                                              "assets/images/default_image_product.png",
                                              width: 100,
                                              height: 100,
                                            )
                                          : Image.network(
                                              "${Constants.IMAGE_BASE_URL}${e.thumbnailImg}",
                                              width: 100,
                                              height: 100)
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      translator.currentLanguage == "en"
                                          ? "${e.name}"
                                          : "${e.name}",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    e.published == 1
                                        ? Text(
                                            "${translator.translate("published")}",
                                            style:
                                                TextStyle(color: Colors.green),
                                          )
                                        : Text(
                                            "${translator.translate("not_published")}",
                                            style:
                                                TextStyle(color: Colors.orange),
                                          ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: primaryColor,
                                        ),
                                        Text("${e.location}"),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${translator.currentLanguage == "en" ? e.descriptionEn : e.descriptionAr}",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return AddNewMyAd(
                                            isEdit: true,
                                            productsData: e,
                                          );
                                        }));
                                      },
                                      //Done
                                      child: Icon(
                                        Icons.edit,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: Text(
                                                        "${translator.translate("confirm_delete")} ?"),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          presenter
                                                              .deleteAdvs(e.id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                            "${translator.translate("delete")}"),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        primaryColor)),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                            "${translator.translate("cancel")}"),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        primaryColor)),
                                                      )
                                                    ],
                                                  ));
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onDataSuccess(List<AddsProductsData> data) {
    myAdvsList.clear();
    myAdvsList = data;
    setState(() {});
  }

  @override
  void onDeleteSuccess(String message) {
    presenter.getMyAdvs();
    setState(() {});
  }

  @override
  void onMoreDataLoading(bool show) {
    // TODO: implement onMoreDataLoading
  }

  @override
  void onMyPackagesDataSuccess(MyPackageData data) {
    // TODO: implement onMyPackagesDataSuccess
  }
}
