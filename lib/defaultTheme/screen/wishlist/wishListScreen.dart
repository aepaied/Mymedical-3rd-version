// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:my_medical_app/utils/ui_icons.dart';
// import 'package:my_medical_app/data/remote/models/wishlistModel.dart';
// import 'package:my_medical_app/ui/models/product.dart';
// import 'package:my_medical_app/defaultTheme/screen/wishlist/wishListPresenter.dart';
// import 'package:my_medical_app/ui/models/widgets/FavoriteListItemWidget.dart';
// import 'package:my_medical_app/ui/models/widgets/ProductGridItemWidget.dart';
// import 'package:my_medical_app/ui/models/widgets/mustLogin.dart';
// import 'package:my_medical_app/utils/helpers.dart';
// import 'package:my_medical_app/utils/sizeConfig.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class WishListScreen extends StatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   WishListScreen({this.scaffoldKey});

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return WishListScreenState();
//   }
// }

// class WishListScreenState extends State<WishListScreen>
//     implements WishListCallBack {
//   bool isLogged = false;
//   String layout = 'grid';
//   List<WishlistData> productsList = List();
//   bool isLoadingData = false;

//   bool noProducts = true;

//   WishListPresenter presenter;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLogged
//         ? isLoadingData
//             ? SpinKitChasingDots(
//                 color: Colors.blue,
//               )
//             : SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.max,
//                   children: <Widget>[
//                     // SizedBox(height: 10),
//                     /* Offstage(
//                       offstage: productsList.isEmpty,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 10),
//                         child: ListTile(
//                           contentPadding: EdgeInsets.symmetric(vertical: 0),
//                           */ /* leading: Icon(
//                   UiIcons.heart,
//                   color: Theme
//                       .of(widget.scaffoldKey.currentContext)
//                       .hintColor,
//                 ),*/ /*
//                           title: Text(
//                             '',
//                             overflow: TextOverflow.fade,
//                             softWrap: false,
//                             style: Theme.of(widget.scaffoldKey.currentContext).textTheme.headline4,
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     this.layout = 'list';
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.format_list_bulleted,
//                                   color: this.layout == 'list'
//                                       ? Theme.of(widget.scaffoldKey.currentContext).accentColor
//                                       : Theme.of(widget.scaffoldKey.currentContext).focusColor,
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     this.layout = 'grid';
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.apps,
//                                   color: this.layout == 'grid'
//                                       ? Theme.of(widget.scaffoldKey.currentContext).accentColor
//                                       : Theme.of(widget.scaffoldKey.currentContext).focusColor,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),*/
//                     /*    Offstage(
//                       offstage: this.layout != 'list' || productsList.isEmpty,
//                       child: ListView.separated(
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         primary: false,
//                         itemCount: productsList.length,
//                         separatorBuilder: (context, index) {
//                           return SizedBox(height: 10);
//                         },
//                         itemBuilder: (context, index) {
//                           return FavoriteListItemWidget(
//                             // heroTag: 'favorites_list',
//                             product: productsList.elementAt(index),
//                             onDismissed: () {
//                               setState(() {
//                                 productsList.removeAt(index);
//                               });
//                             },
//                           );
//                         },
//                       ),
//                     ),*/
//                     Offstage(
//                       offstage: this.layout != 'grid' || productsList.isEmpty,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         child: GridView.countBuilder(
//                           primary: false,
//                           shrinkWrap: true,
//                           crossAxisCount: 4,
//                           itemCount: productsList.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             WishlistData wd = productsList.elementAt(index);
//                             Product product = Product(
//                                 wd.product.id,
//                                 wd.product.name,
//                                 null,
//                                 wd.product.thumbnailImage,
//                                 double.parse(wd.product.basePrice.toString()),
//                                 double.parse(
//                                     wd.product.baseDiscountedPrice.toString()),
//                                 0,
//                                 0,
//                                 wd.product.unit,
//                                 null,
//                                 null,
//                                 0,
//                                 null,
//                                 null,
//                                 null,
//                                 0,
//                                 wd.product.links.details,
//                                 wd.product.links.reviews,
//                                 wd.product.links.related,
//                                 wd.product.links.topFromSeller,
//                                 wd.product.country,
//                                 wd.product.isFavorite);
//                             return ProductGridItemWidget(
//                               product: product,
//                               wishListId: wd.id,
//                               reloadWishList: () {
//                                 presenter.getWishListData();
//                               },
//                               // heroTag: 'favorites_grid',
//                             );
//                           },
// //                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
//                           staggeredTileBuilder: (int index) =>
//                               StaggeredTile.fit(2),
//                           mainAxisSpacing: 15.0,
//                           crossAxisSpacing: 15.0,
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: noProducts,
//                       child: Center(
//                         child: Opacity(
//                           opacity: 0.4,
//                           child: Text(
//                             'there are no' + " " + 'products',
//                             textAlign: TextAlign.center,
//                             style: Theme.of(widget.scaffoldKey.currentContext)
//                                 .textTheme
//                                 .headline3
//                                 .merge(TextStyle(fontWeight: FontWeight.w300)),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//         : MustLogin();
//   }

//   @override
//   void onDataError(String message) {
//     Fluttertoast.showToast(msg: message);
// /*
//     showDialog(
//         context: widget.scaffoldKey.currentContext,
//         builder: (BuildContext context) => ErrorDialog(
//               context: widget.scaffoldKey.currentContext,
//               content: message,
//             ));
// */
//   }

//   @override
//   void onDataLoading(bool show) {
//     setState(() {
//       isLoadingData = show;
//     });
//   }

//   @override
//   void onDataSuccess(List<WishlistData> data) {
//     setState(() {
//       if (data.length == 0) {
//         noProducts = true;
//       } else {
//         noProducts = false;
//       }

//       productsList.clear();
//       productsList.addAll(data);
//       /* for (WishlistData p in data) {
//         productsList.add(Product(
//             p.product.id,
//             p.product.name,
//             null,
//             p.product.thumbnailImage,
//             p.product.basePrice,
//             p.product.baseDiscountedPrice,
//             0,
//             0,
//             p.product.unit,
//             null,
//             null,
//             0,
//             null,
//             null,
//             0,
//             p.product.links.details,
//             p.product.links.reviews,
//             p.product.links.related,
//             p.product.links.topFromSeller));
//       }*/
//     });
//   }
// }
