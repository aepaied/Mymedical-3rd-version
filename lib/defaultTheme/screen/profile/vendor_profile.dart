import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/theme5/utils/T5Colors.dart';
import 'package:my_medical_app/theme5/utils/T5Constant.dart';
import 'package:my_medical_app/theme5/utils/T5Images.dart';
import 'package:my_medical_app/theme5/utils/T5Strings.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class VendorProfile extends StatefulWidget {
  final User currentUser;

  VendorProfile({Key key, @required this.currentUser}) : super(key: key);
  static var tag = "/T5Profile";

  @override
  VendorProfileState createState() => VendorProfileState();
}

class VendorProfileState extends State<VendorProfile> {
  double width;

  @override
  void initState() {
    super.initState();
  }

  var currentIndex = 0;
  var iconList = <String>[t5_analysis, t5_wallet_2, t5_customer_service, t5_img_settings];
  var nameList = <String>[t5_statistics, t5_manage_wallet, t5_support, t5_settings];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget gridItem(int pos) {
    return Container(
        width: (width - (16 * 3)) / 2,
        height: (width - (16 * 3)) / 2,
        decoration: boxDecoration(radius: 24, showShadow: true, bgColor: t5White),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              iconList[pos],
              width: width / 7,
              height: width / 7,
              color: black,
            ),
            text(nameList[pos], fontSize: textSizeNormal, textColor: t5TextColorPrimary, fontFamily: fontSemibold)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(t5DarkNavy);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: t5LayoutBackgroundWhite,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              height: width,
              color: sh_colorPrimary,
              child: Container(
                alignment: Alignment.center,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Container(),
                    ),
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
                    decoration: BoxDecoration(color: t5LayoutBackgroundWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        text("${widget.currentUser.name}",
                            textColor: t5TextColorPrimary,
                            fontFamily: fontMedium,
                            fontSize: textSizeNormal),
                        text("${widget.currentUser.email}",
                            fontSize: textSizeLargeMedium),
                        text("${widget.currentUser.phone}",
                            fontSize: textSizeLargeMedium),
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
                      ],
                    ),
                  ),
                  CircleAvatar(
                      backgroundImage: widget.currentUser.avatar == "" ||
                              widget.currentUser.avatar == null
                          ? widget.currentUser.avatarOriginal == "" ||
                                  widget.currentUser.avatarOriginal == null
                              ? Image.asset("assets/images/user.jpg",
                                  height: 70, width: 70, fit: BoxFit.cover)
                              : NetworkImage(
                                  '${Constants.IMAGE_BASE_URL}${widget.currentUser.avatarOriginal}',
                                )
                          : NetworkImage(
                              '${Constants.IMAGE_BASE_URL}${widget.currentUser.avatar}',
                            ),
                      radius: 50)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
