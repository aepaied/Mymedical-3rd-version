import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_medical_app/data/remote/models/dashboardModel.dart';
import 'package:my_medical_app/screens/vendor/products/addVendorProductScreen.dart';
import 'package:my_medical_app/screens/vendor/dashboardPresenter.dart';
import 'package:my_medical_app/screens/vendor/products/addVendorProductScreen.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/theme5/utils/T5BubbleBotoomBar.dart';
import 'package:my_medical_app/theme5/utils/T5Colors.dart';
import 'package:my_medical_app/theme5/utils/T5Constant.dart';
import 'package:my_medical_app/theme5/utils/T5Images.dart';
import 'package:my_medical_app/theme5/utils/T5Strings.dart';

class SellerDashboard extends StatefulWidget {
  @override
  SellerDashboardState createState() => SellerDashboardState();
}

class SellerDashboardState extends State<SellerDashboard>
    implements DashboardCallBack {
  double width;
  bool isLoadingData = false;
  String product_count = "0";
  String total_sale = "0";
  String total_earning = "0";
  String successful_orders = "0";
  String total_orders = "0";
  String pending_orders = "0";
  String cancelled_orders = "0";

  DashboardPresenter presenter;

  List<String> iconList;
  List<String> nameList;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (presenter == null) {
      _isLoading = true;
      setState(() {});
      presenter = DashboardPresenter(context: context, callBack: this);
      presenter.getDashboardData();
      Future.delayed(Duration(seconds: 2), (){
        iconList = [
          "$product_count",
          "$total_sale",
          "$total_earning",
          "$successful_orders"
        ];
        nameList = ["Products", "Total Sale", "Total Profits", "Successful Orders"];
        _isLoading = false;
        setState(() {});
      });
    }
  }

  var currentIndex = 0;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget gridItem(int pos) {
    return Container(
        width: (width - (16 * 3)) / 2,
        height: (width - (16 * 3)) / 2,
        decoration:
            boxDecoration(radius: 24, showShadow: true, bgColor: t5White),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              iconList[pos],
            ),
            text(nameList[pos],
                fontSize: textSizeNormal,
                textColor: t5TextColorPrimary,
                fontFamily: fontSemibold)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(t5DarkNavy);
    width = MediaQuery.of(context).size.width;
    return _isLoading? SpinKitChasingDots(color:Colors.blue):Scaffold(
      backgroundColor: t5LayoutBackgroundWhite,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              height: width,
              color: t5DarkNavy,
              child: Container(
                alignment: Alignment.center,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left,
                          size: 40, color: t5White),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: text("Dashboard",
                            textColor: t5White,
                            fontSize: textSizeNormal,
                            fontFamily: fontMedium)),
Spacer()
/*
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: SvgPicture.asset(t5_options, width: 25, height: 25, color: t5White),
                    ),
*/
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 80),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(top: 60),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color: t5LayoutBackgroundWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    child: Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[gridItem(0), gridItem(1)],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[gridItem(2), gridItem(3)],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Requests",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total requests: $total_orders",
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                "Pending requests: $pending_orders",
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                "Cancelled requests: $cancelled_orders",
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                "Successful requests: $successful_orders",
                                style: TextStyle(fontSize: 17),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return AddVendorProductScreen();
                              }));
                            },
                            child: Row(
                              children: [Icon(Icons.add), Text("Add Product")],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  CircleAvatar(radius: 50)
                ],
              ),
            ),
          ],
        ),
      ),
/*
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        elevation: 8,
        onTap: changePage,
        //new
        hasNotch: false,
        //new
        hasInk: true,
        //new, gives a cute ink effect
        inkColor: t5ColorPrimaryLight,
        //optional, uses theme color if not specified
*/
/*
        items: <BubbleBottomBarItem>[
          tab(t5_img_home, t5_home),
          tab(t5_list_check, t5_lbl_listing),
          tab(t5_notification_2, t5_notification),
          tab(t5_user, t5_lbl_profile),
        ],
*/ /*

      ),
*/
    );
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
  void onDataSuccess(DashboardModel data) {
    setState(() {
      product_count = data.productCount.toString();
      total_sale = data.totalSale.toString();
      total_earning = data.totalEarning.toString();
      successful_orders = data.successfulOrders.toString();
      total_orders = data.totalOrders.toString();
      pending_orders = data.pendingOrders.toString();
      cancelled_orders = data.cancelledOrders.toString();
    });
  }
}
