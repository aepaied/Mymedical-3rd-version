import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/app_localizations.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/utils/oColors.dart';

class ImageDialog extends Dialog {
  ImageDialog(
      {Key key,
      this.elevation,
      this.insetAnimationDuration = const Duration(milliseconds: 100),
      this.insetAnimationCurve = Curves.decelerate,
      this.context,
      this.content,
      this.title,
      this.viewRemoveImage})
      : super(key: key);

  final Color backgroundColor = Colors.transparent;
  final double elevation;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final BuildContext context;
  final String title;
  final String content;

  bool viewRemoveImage;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double wUnit;
  static double vUnit;

  @override
  // TODO: implement child
  ShapeBorder get shape {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0));
  }

  @override
  // TODO: implement child
  Widget get child {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    vUnit = screenHeight / 100;
    return Container(
      color: OColors.colorWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // To make the card compact
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'add_photo',
                style: TextStyle(
                    color: OColors.colorBlack,
                    decoration: TextDecoration.none,
                    fontSize: wUnit * 5,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop(1);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset("assets/icons/ic_camera.svg",
                        semanticsLabel: "arrow_right",
                        color: primaryColor,
                        width: wUnit * 7,
                        height: wUnit * 7),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${translator.translate("take_photo")}",
                      style: TextStyle(
                        color: OColors.colorBlack,
                        decoration: TextDecoration.none,
                        fontSize: wUnit * 5,
                      ),
                    )
                  ],
                ),
              )),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop(2);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset("assets/icons/ic_gallery.svg",
                        semanticsLabel: "arrow_right",
                        color: primaryColor,
                        width: wUnit * 7,
                        height: wUnit * 7),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Text(
                      '${translator.translate("choose_from_gallery")}',
                      style: TextStyle(
                        color: OColors.colorBlack,
                        decoration: TextDecoration.none,
                        fontSize: wUnit * 5,
                      ),
                    ))
                  ],
                ),
              )),
          Visibility(
            visible: viewRemoveImage == null ? true : viewRemoveImage,
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(3);
                },
                child: Container(
                  color: OColors.transparent,
                  padding: EdgeInsets.only(
                      top: vUnit * 2,
                      bottom: vUnit * 2,
                      left: wUnit * 10,
                      right: wUnit * 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset("assets/icons/ic_remove.svg",
                          semanticsLabel: "arrow_right",
                          color: OColors.colorAccent,
                          width: wUnit * 7,
                          height: wUnit * 7),
                      Container(
                        width: wUnit * 2,
                      ),
                      Expanded(
                          child: Text(
                        'remove_image',
                        style: TextStyle(
                          color: OColors.colorBlack,
                          decoration: TextDecoration.none,
                          fontSize: wUnit * 5,
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          Divider(),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop(0);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset("assets/icons/ic_cancel.svg",
                        semanticsLabel: "arrow_right",
                        color: Colors.red,
                        width: wUnit * 6,
                        height: wUnit * 6),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'cancel',
                      style: TextStyle(
                        color: OColors.colorBlack,
                        decoration: TextDecoration.none,
                        fontSize: wUnit * 5,
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
