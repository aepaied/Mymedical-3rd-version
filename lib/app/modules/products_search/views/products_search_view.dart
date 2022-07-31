import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/defaultTheme/utils/DTWidgets.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/funcs.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/main/utils/rating_bar.dart';
import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/size_config.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/SearchWidget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/products_search_controller.dart';

class ProductsSearchView extends GetView<ProductsSearchController>
    implements LocalSearchCallBack {
  final String searchText;
  ProductsSearchView({this.searchText});
  final ProductsSearchController productsSearchController =
      Get.isRegistered<ProductsSearchController>()
          ? Get.find()
          : Get.put(ProductsSearchController());
  @override
  Widget build(BuildContext context) {
    controller.init(searchText);
    return Obx(() => Scaffold(
        drawer: DrawerWidget(categoriesList: categoriesList),
        appBar: CustomAppBar(
          title: productsSearchController.searchIsVisible.value
              ? "${translator.translate("search")}"
              : "${translator.translate("products")}",
          isHome: false,
        ),
        body: GestureDetector(
          onTap: () {
            controller.toggleSearchResult(false);
          },
          child: Container(
            // padding: EdgeInsets.all(wUnit * 3),
            child: Column(
              children: [
                Container(
                  // padding: EdgeInsets.all(wUnit),
                  child: GetBuilder<ProductsSearchController>(
                    init: ProductsSearchController(),
                    initState: (_) {},
                    builder: (_) {
                      return SearchWidget(
                        searchText: controller.widgetSearchText.value,
                        isHidden:
                            productsSearchController.searchIsVisible.value,
                        widgetSelectedSearchFilter:
                            controller.widgetSelectedSearchFilter.value,
                        widgetSelectedSortFilter:
                            controller.widgetSortByFilter.value,
                        hasSearch: controller.search.value,
                        localSearchCallBack: this,
                        viewSearchResult: controller.viewSearchResult.value,
                        user: controller.user.value,
                        onOpenDrawer: () {
                          controller.openDrawer();
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: SizeConfig.hUnit * 1,
                ),
                Expanded(
                  child: Obx(
                    () => controller.productsList.isEmpty
                        ? Center(
                            child:
                                Text("${translator.translate("no_products")}"),
                          )
                        : LiquidPullToRefresh(
                            backgroundColor: Colors.white,
                            color: primaryColor,
                            onRefresh:
                                controller.handleRefresh, // refresh callback
                            child: GridView.count(
                              controller: controller.scrollController,
                              childAspectRatio: 0.75,
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              children: controller.productsList.map((data) {
                                return Container(
                                  decoration: boxDecorationRoundedWithShadow(8,
                                      backgroundColor: Colors.white),
                                  margin: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        children: [
                                          data.thumbnail_image == null ||
                                                  data.thumbnail_image == ""
                                              ? Image.asset(
                                                  "assets/images/default_image_product.png",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                )
                                              : Image.network(
                                                  "${Constants.IMAGE_BASE_URL}${data.thumbnail_image}",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  fit: BoxFit.cover,
                                                  // height: isMobile ? 110 : 180,
                                                ),
                                          Positioned(
                                            right: 2,
                                            top: 5,
                                            child: GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .addToFavorite(data);
                                                },
                                                child: Container(
                                                  // margin: EdgeInsets.only(top: vUnit * 16.5),
                                                  // padding: EdgeInsets.only(),
                                                  // color: OColors.colorGray,
                                                  child: data.isFavorite == null
                                                      ? Container()
                                                      : Icon(
                                                          Icons.favorite,
                                                          color: data.isFavorite
                                                              ? Colors.red
                                                              : Colors.grey,
                                                          size: 28,
                                                        ),
                                                )),
                                          ),
                                          int.parse(data.current_stock) > 0
                                              ? Positioned(
                                                  right: 1,
                                                  bottom: 1,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        controller
                                                            .addToCart(data);
                                                      },
                                                      child: Container(
                                                        // margin: EdgeInsets.only(top: vUnit * 16.5),
                                                        // padding: EdgeInsets.only(),
                                                        // color: OColors.colorGray,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            controller
                                                                .addToCart(
                                                                    data);
                                                          },
                                                          child: CircleAvatar(
                                                            radius: 17,
                                                            backgroundColor:
                                                                primaryColor,
                                                            child: Icon(
                                                              Icons
                                                                  .add_shopping_cart,
                                                              color:
                                                                  Colors.white,
                                                              size: 25,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              : Positioned(
                                                  bottom: 5,
                                                  child: Container(
                                                    color: Colors.red,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Text(
                                                        "${translator.translate("out_of_stock")}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(data.name,
                                              style: primaryTextStyle(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          4.height,
                                          Row(
                                            children: [
                                              RatingBar(
                                                onRatingChanged: (r) {},
                                                filledIcon: Icons.star,
                                                emptyIcon: Icons.star_border,
                                                initialRating:
                                                    double.parse(data.rating),
                                                maxRating: 5,
                                                filledColor: Colors.yellow,
                                                size: 14,
                                              ),
                                              5.width,
                                              Text('${data.rating}',
                                                  style: secondaryTextStyle(
                                                      size: 12)),
                                            ],
                                          ),
                                          4.height,
                                          data.base_discounted_price ==
                                                  data.base_price
                                              ? Row(
                                                  children: [
                                                    priceWidget(
                                                        data.base_price),
                                                    8.width,
                                                    // priceWidget(data.base_price, applyStrike: true),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      "${Funcs().removeTrailingZero(data.base_price)} ${translator.translate("egp")}",
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "${Funcs().removeTrailingZero(data.base_discounted_price)} LE",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),

                                                    // priceWidget(data.base_price, applyStrike: true),
                                                  ],
                                                ),
                                        ],
                                      ).paddingAll(8),
                                    ],
                                  ),
                                ).onTap(() async {
                                  int index = await ShProductDetail(
                                    is_ad: false,
                                    product: data,
                                    productID: data.id,
                                  ).launch(context);
                                  if (index != null)
                                    appStore.setDrawerItemIndex(index);
                                });
                              }).toList(),
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(SizeConfig.wUnit * 3),
                  alignment: Alignment.center,
                  child: Obx(
                    () => Visibility(
                      child: CircularProgressIndicator(),
                      visible: controller.isLoadingMore.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  @override
  void onLoadCurrentProducts(bool load) {
    // TODO: implement onLoadCurrentProducts
  }

  @override
  void onSearchDataSuccess(List<Product> data, Meta meta) {
    // TODO: implement onSearchDataSuccess
  }
}
