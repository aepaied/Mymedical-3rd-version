import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/controllers/system_settings_controller.dart';

////Facebook Provider
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//
////Google Provider
//import 'package:google_sign_in/google_sign_in.dart';

class SocialMediaWidget extends StatefulWidget {
  Function onGooglePressed;
  Function onFaceBookPressed;

  SocialMediaWidget({Key key, this.onGooglePressed, this.onFaceBookPressed})
      : super(key: key);

  @override
  _SocialMediaWidgetState createState() => _SocialMediaWidgetState();
}

class _SocialMediaWidgetState extends State<SocialMediaWidget> {
  //Facebook Login
  // FacebookLogin fbLogin = new FacebookLogin();
  // AuthPresenter presenter;
  String name = "";
  String email = "";
  String imageUrl = "";
  BusinessSettingController businessSettingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        businessSettingController.currentBusinessSettings.value.details
                    .where((element) => element.type == "facebook_login")
                    .toList()[0]
                    .value ==
                "1"
            ? SizedBox(
                width: 45,
                height: 45,
                child: InkWell(
                  onTap: widget.onFaceBookPressed,
                  child: Image.asset('assets/images/facebook.png'),
                ),
              )
            : Container(),
        SizedBox(width: 10),
        businessSettingController.currentBusinessSettings.value.details
                    .where((element) => element.type == "google_analytics")
                    .toList()[0]
                    .value ==
                "1"
            ? SizedBox(
                width: 45,
                height: 45,
                child: InkWell(
                  onTap: widget.onGooglePressed,
                  child: Image.asset('assets/images/google-plus.png'),
                ),
              )
            : Container(),
        SizedBox(width: 10),
      ],
    );
  }
}
