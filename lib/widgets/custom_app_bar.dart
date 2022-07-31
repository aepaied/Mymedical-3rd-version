import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/app/modules/products_search/controllers/products_search_controller.dart';
import 'package:my_medical_app/app/modules/products_search/views/products_search_view.dart';
import 'package:my_medical_app/controllers/showcase_controller.dart';
import 'package:my_medical_app/main/utils/AppConstant.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/cart/ShoppingCartButtonWidget.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isHome;

  const CustomAppBar({Key key, @required this.title, this.isHome})
      : super(key: key);

  final String title;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool itIsHome = false;

  Size get preferredSize => const Size.fromHeight(50);
  ShowcaseController _showcaseController = Get.put(ShowcaseController());
  final ProductsSearchController productsSearchController =
      Get.isRegistered<ProductsSearchController>()
          ? Get.find()
          : Get.put(ProductsSearchController());
  @override
  void initState() {
    if (widget.isHome != null) {
      if (widget.isHome) {
        itIsHome = true;
      } else {
        itIsHome = false;
      }
    } else {
      itIsHome = true;
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(onFinish: () {
    }, builder: Builder(
      builder: (context) {
        // _showcaseController.appbarCartContext = context;
            return AppBar(
          backgroundColor: sh_white,
          iconTheme: IconThemeData(color: sh_textColorPrimary),
          leading: Row(
            children: [
              !itIsHome
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(Icons.list)),
              itIsHome
                  ? Container()
                  : new IconButton(
                      icon: new Icon(Icons.keyboard_backspace),
                      onPressed: () => Navigator.of(context).pop()),
            ],
          ),
          actions: <Widget>[
                GestureDetector(
                    onTap: () {
                      productsSearchController.changeSearchVisibility(true);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ProductsSearchView();
                      }));
                    },
                    child: Icon(Icons.search)),
                Showcase(
                    key: _showcaseController.appbarCartShowcaseKey,
                    description: "${translator.translate("add_items_to_cart")}",
                    child: ShoppingCartButtonWidget()),
                // ShoppingCartButtonWidget()
              ],
          title: text(widget.title,
              textColor: sh_textColorPrimary,
              fontFamily: fontBold,
              fontSize: textSizeNormal),
        );
      },
    ));
  }
}
