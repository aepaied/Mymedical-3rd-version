/*
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/services/api_services.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/shopHop/utils/ShStrings.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class OnBoarding extends StatefulWidget {

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<PageViewModel> pageList = [];
  bool isLoading = false;

  gettingOnBoardingData() {
    isLoading = true;
    setState(() {});
    ApiServices().getWalkTrough().then((resp) {
      isLoading = false;
      setState(() {});
      print(resp);
      for (var item in resp['data']){
        PageViewModel pageViewModel = PageViewModel(
          title: item['title'],
          body: item['sub_title'],
          image: Image.network("${Constants.IMAGE_BASE_URL}${item['image']}/"),
          footer: Container(width: MediaQuery.of(context).size.width * 0.8,
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
        );
        pageList.add(pageViewModel);
        // mSliderList.add("${Constants.IMAGE_BASE_URL}${item['image']}/");
        // mHeadingList.add(item['title']);
        // msubtitle1ingList.add(item['sub_title']);
      }
    });
  }

  @override
  void initState() {
    gettingOnBoardingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: pageList,
        onDone: () {
          // When done button is press
        },
        showSkipButton: true,
        skip: const Text("Skip"),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        next:  Icon(Icons.navigate_next_outlined),

      ),
    );
  }
}
*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/onbording_controller.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/main/utils/dots_indicator/dots_indicator.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/shopHop/utils/ShImages.dart';
import 'package:my_medical_app/shopHop/utils/ShStrings.dart';
import 'package:my_medical_app/shopHop/utils/widgets/ShSliderWidget.dart';
import 'package:nb_utils/nb_utils.dart';

class OnBoarding extends StatefulWidget {
  static var tag = "/ShWalkThroughScreen";

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {

  OnBoardingController _onBoardingController = Get.put(OnBoardingController());

  @override
  void dispose() {
    super.dispose();
    changeStatusColor(Colors.white);
  }

  bool isLoading = false;

  @override
  void initState() {
    _onBoardingController.gettingWalkThroughData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.white);
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(spacing_large, spacing_large,
                      spacing_large, spacing_standard_new),
                  child: Column(
                    children: <Widget>[
                      text(
                          _onBoardingController.mHeadingList[
                              _onBoardingController.position.value],
                          textColor: sh_textColorPrimary,
                          fontSize: textSizeLarge,
                          fontFamily: fontBold),
                      SizedBox(height: 10.0),
                      text(
                          _onBoardingController.mSubtitle1ingList[
                              _onBoardingController.position.value],
                          fontSize: textSizeLargeMedium,
                          maxLine: 3,
                          isCentered: true),
                    ],
                  ),
                ),
                Obx(
                  () => ShCarouselSlider(
                    viewportFraction: 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    items: _onBoardingController.mSliderList.map((slider) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: width * 0.9,
                            //height: 400,
                            //height: width + width * 0.1,
                            decoration: BoxDecoration(
                              color: sh_white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(spacing_standard)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: spacing_control_half,
                                    blurRadius: 10,
                                    offset: Offset(1, 3))
                              ],
                            ),
                            margin: EdgeInsets.all(spacing_standard_new),
                            child: Center(
                                child: CachedNetworkImage(
                                    placeholder: placeholderWidgetFn() as Widget
                                        Function(BuildContext, String),
                                    imageUrl: slider,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover)),
                          );
                        },
                      );
                    }).toList(),
                    onPageChanged: (index) {
                      _onBoardingController.position.value = index;
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(spacing_large),
                  child: Column(
                    children: <Widget>[
                      DotsIndicator(
                        dotsCount: 3,
                        position: _onBoardingController.position.value,
                        decorator: DotsDecorator(
                            color: sh_view_color,
                            activeColor: sh_colorPrimary,
                            activeSize: const Size.square(14.0),
                            spacing: EdgeInsets.all(spacing_control)),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: MaterialButton(
                          padding: EdgeInsets.all(spacing_standard),
                          child: Text(
                              "${translator.translate(sh_text_start_to_shopping)}",
                              style: TextStyle(fontSize: 18)),
                          textColor: sh_white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0)),
                          color: primaryColor,
                          onPressed: () {
                            finish(context);
                            ShHomeScreen().launch(context);
                          },
                        ),
                      ),
                      SizedBox(height: spacing_standard),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                            return T3SignIn();
                          }));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            text(sh_lbl_already_have_a_account),
                            text(sh_lbl_sign_in, textColor: sh_textColorPrimary, fontFamily: fontBold),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
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
                child: CachedNetworkImage(
                    placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String),
                    imageUrl: slider,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: cardSize.height),
              ),
            );
          },
        );
      }).toList(),
      onPageChanged: (index) {},
    );
  }
}
