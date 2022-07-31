import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_medical_app/defaultTheme/screen/DTDashboardScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/services/api_services.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/main/utils/dots_indicator/dots_indicator.dart';
// import 'package:my_medical_app/shopHop/screens/ShHomeScreen.dart';
// import 'package:my_medical_app/shopHop/screens/ShSignIn.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/shopHop/utils/ShImages.dart';
import 'package:my_medical_app/shopHop/utils/ShStrings.dart';
import 'package:my_medical_app/shopHop/utils/widgets/ShSliderWidget.dart';

class ShWalkThroughScreen extends StatefulWidget {
  static var tag = "/ShWalkThroughScreen";

  @override
  _ShWalkThroughScreenState createState() => _ShWalkThroughScreenState();
}

class _ShWalkThroughScreenState extends State<ShWalkThroughScreen> {
  var mSliderList = <String>[ic_walk_1, ic_walk_2, ic_walk_3];
  var mHeadingList = <String>["Hi, Welcome", "Most Unique Styles!", "Shop Till You Drop!"];
  var msubtitle1ingList = <String>[
    "We make around your city Affordable,easy and efficient.",
    "Shop the most trending fashion on the biggest shopping website",
    "Grab the best seller pieces at bargain prices."
  ];
  var position = 0;
  bool isLoading = false;
  gettingWalkThroughData() {
    isLoading = true;
    setState(() {});
    ApiServices().getWalkTrough().then((resp) {
      isLoading = false;
      setState(() {});
      print(resp);
      mSliderList.clear();
      mHeadingList.clear();
      msubtitle1ingList.clear();
      for (var item in resp['data']){
        mSliderList.add("${Constants.IMAGE_BASE_URL}${item['image']}/");
        mHeadingList.add(item['title']);
        msubtitle1ingList.add(item['sub_title']);
      }
    });
  }
  @override
  void initState() {
    gettingWalkThroughData();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    changeStatusColor(Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.white);
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    final Size cardSize = Size(width, width / 1.8);
    return Scaffold(
      body: isLoading ? SpinKitChasingDots(color: primaryColor,):SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(spacing_large, spacing_large, spacing_large, spacing_standard_new),
                child: Column(
                  children: <Widget>[
                    text(mHeadingList[position], textColor: sh_textColorPrimary, fontSize: textSizeLarge, fontFamily: fontBold),
                    SizedBox(height: 10.0),
                    text(msubtitle1ingList[position], fontSize: textSizeLargeMedium, maxLine: 3, isCentered: true),
                  ],
                ),
              ),
              ShCarouselSlider(
                viewportFraction: 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                items: mSliderList.map((slider) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: width * 0.9,
                        //height: 400,
                        //height: width + width * 0.1,
                        decoration: BoxDecoration(
                          color: sh_white,
                          borderRadius: BorderRadius.all(Radius.circular(spacing_standard)),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: spacing_control_half, blurRadius: 10, offset: Offset(1, 3))],
                        ),
                        margin: EdgeInsets.all(spacing_standard_new),
                        // child: Center(child: CachedNetworkImage(placeholder: placeholderWidgetFn(),imageUrl: slider, width: MediaQuery.of(context).size.width, fit: BoxFit.cover)),
                        child: Center(child: Image.network('$slider', width: MediaQuery.of(context).size.width, fit: BoxFit.cover)),
                      );
                    },
                  );
                }).toList(),
                onPageChanged: (index) {
                  position = index;
                  setState(() {});
                },
              ),
              Padding(
                padding: const EdgeInsets.all(spacing_large),
                child: Column(
                  children: <Widget>[
                    DotsIndicator(
                      dotsCount: 3,
                      position: position,
                      decorator: DotsDecorator(color: sh_view_color, activeColor: sh_colorPrimary, activeSize: const Size.square(14.0), spacing: EdgeInsets.all(spacing_control)),
                    ),
                    SizedBox(height: spacing_standard),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: MaterialButton(
                        padding: EdgeInsets.all(spacing_standard),
                        child: Text(sh_text_start_to_shopping, style: TextStyle(fontSize: 18)),
                        textColor: sh_white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                        color: sh_colorPrimary,
                        onPressed: () {
                          finish(context);

                          ShHomeScreen().launch(context);
                        },
                      ),
                    ),
                    SizedBox(height: spacing_standard),
                    // InkWell(
                    //   onTap: () {
                    //     ShHomeScreen().launch(context);
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       text(sh_lbl_already_have_a_account),
                    //       text(sh_lbl_sign_in, textColor: sh_textColorPrimary, fontFamily: fontBold),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShSliderWidget extends StatelessWidget {
  var mSliderList = <String>[ic_walk_1, ic_walk_2, ic_walk_3];

  ShSliderWidget(this.mSliderList);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    final Size cardSize = Size(width, width / 1.8);

    return ShCarouselSlider(
      viewportFraction: 0.9,
      height: cardSize.height,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
      items: mSliderList.map((slider) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: cardSize.height,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: CachedNetworkImage(placeholder: placeholderWidgetFn(),imageUrl: slider, fit: BoxFit.fill, width: MediaQuery.of(context).size.width, height: cardSize.height),
              ),
            );
          },
        );
      }).toList(),
      onPageChanged: (index) {},
    );
  }
}
