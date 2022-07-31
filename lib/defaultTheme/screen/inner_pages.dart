import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/staticPagesModel.dart';
import 'package:my_medical_app/defaultTheme/screen/staticPagesPresenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

class InnerPage extends StatefulWidget {
  final int pageId;

  InnerPage({Key key, @required this.pageId}) : super(key: key);

  @override
  InnerPageState createState() => InnerPageState();
}

class InnerPageState extends State<InnerPage> implements StaticPagesCallBack {
  bool isLogged = false;
  User user;
  String title = "";
  String link = "";
  String htmlContent = "";
  String siteLink = "";
  bool isLoadingData = false;
  bool htmlPageLoading = false;
  String coverPhoto;
  StaticPagesPresenter presenter;

  @override
  void initState() {
    print("page id is ${widget.pageId}");
    htmlPageLoading = true;
    setState(() {});
    if (presenter == null) {
      presenter = StaticPagesPresenter(context: context, callBack: this);
      presenter.getPageData(widget.pageId);
    }

    Helpers.getUserData().then((_user) {
      setState(() {
        isLogged = _user.isLoggedIn;
        user = _user;
      });
    });
    Future.delayed(Duration(seconds: 5), () {
      htmlPageLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);

    return Scaffold(
      body: isLoadingData
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          :
          // Observer(
          /* builder: (_) =>*/
          NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    titleSpacing: 0,
                    backgroundColor: Colors.white,
                    actionsIconTheme: IconThemeData(opacity: 0.0),
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: !innerBoxIsScrolled ? black : Colors.black),
                        onPressed: () {
                          finish(context);
                        }),
                    title: Text('$title',
                        style: boldTextStyle(color: black, size: 22)),
                    flexibleSpace: FlexibleSpaceBar(
                      background: coverPhoto.length > 34? Image.network(coverPhoto): Image.asset('assets/images/default_image_product.png', fit: BoxFit.contain)
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        children: [Text('${translator.translate("share_to")}')],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        children: [
                          //TODO add the links
                          GestureDetector(
                              onTap: () {
                                Share.share('$siteLink');
                              },
                              child: Image.asset(
                                "assets/icons/whatsapp.png",
                                width: 25,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                Share.share('$siteLink');
                              },
                              child: Image.asset(
                                "assets/icons/facebook.png",
                                width: 25,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                Share.share('$siteLink');
                              },
                              child: Image.asset(
                                "assets/icons/instagram.png",
                                width: 25,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                Share.share('$siteLink');
                              },
                              child: Image.asset(
                                "assets/icons/linkedin.png",
                                width: 25,
                              )),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Text("$htmlContent"),
                      Html(data: "$htmlContent")

/*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[Text(t3_text_cheese_roll_done_by_john_doe, style: boldTextStyle(size: 18)), SvgPicture.asset(t3_ic_favourite, color: t3_red)],
                  ),
                  SizedBox(height: 16),
                  Text(t3_lbl_share_to, style: primaryTextStyle(size: 14)),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(t3_ic_wp, height: 24, width: 24),
                      SizedBox(width: 10),
                      Container(margin: EdgeInsets.only(left: 10, right: 10), child: Image.asset(t3_ic_facebook, height: 24, width: 24)),
                      SizedBox(width: 10),
                      SvgPicture.asset(t3_ic_instagram, height: 24, width: 24),
                      SizedBox(width: 10),
                      Container(margin: EdgeInsets.only(left: 10, right: 10), child: Image.asset(t3_ic_linkedin, height: 24, width: 24)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(t3_lbl_recipe_steps, style: primaryTextStyle(size: 14)),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text(t3_lbl_desc, style: primaryTextStyle(size: 16)),
                  ),
*/
                    ],
                  ),
                ),
              ),
            ),
      // ),
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
  void onDataSuccess(Data data) {
    title = data.title;
    htmlContent = "${data.content}";
    siteLink = "${data.site_link}";
    coverPhoto = Constants.IMAGE_BASE_URL + "${data.cover_photo}";
    setState(() {});
  }
}
