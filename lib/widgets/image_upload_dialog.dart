import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/image_upload_controller.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppConstant.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ImageUploadDialog extends StatelessWidget {
  final String type;
  final UploadMainImageCallBack uploadImageCallback;

  ImageUploadDialog({@required this.type, this.uploadImageCallback});

  final ImageUploadController imageUploadC = Get.put(ImageUploadController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: radius(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: new BoxDecoration(
          color: context.cardColor,
          shape: BoxShape.rectangle,
          borderRadius: radius(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0)),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Image(
                  width: MediaQuery.of(context).size.width,
                  image: AssetImage('assets/images/widget_delete.jpg'),
                  height: 120,
                  fit: BoxFit.cover),
            ),
            24.height,
            Text('${translator.translate("upload_image")}',
                style:
                    boldTextStyle(color: appStore.textPrimaryColor, size: 18)),
            16.height,
            16.height,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecoration(
                          color: Colors.blueAccent,
                          radius: 8,
                          bgColor: context.scaffoldBackgroundColor),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.photo,
                                          color: primaryColor, size: 18))),
                              TextSpan(
                                  text: "${translator.translate('gallery')}",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: primaryColor,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      if (type == "thumb") {
                        imageUploadC.getThumbImage(ImageSource.gallery);
                      } else if (type == "main") {
                        imageUploadC
                            .getMainImage(ImageSource.gallery)
                            .then((value) {
                          uploadImageCallback.onUploadSuccess(value);
                        });
                      } else if (type == "meta"){
                        imageUploadC.getMetaImage(ImageSource.gallery);
                      } else if (type == "profile"){
                        imageUploadC.getProfileImage(ImageSource.gallery);
                      }
                      //TODO rest of types
                    }),
                  ),
                  16.width,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration:
                          boxDecoration(bgColor: primaryColor, radius: 8),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.camera,
                                          color: Colors.white, size: 18))),
                              TextSpan(
                                  text: "${translator.translate("camera")}",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      if (type == "thumb") {
                        imageUploadC.getThumbImage(ImageSource.camera);
                      } else if (type == "main") {
                        imageUploadC
                            .getMainImage(ImageSource.camera)
                            .then((value) {
                          uploadImageCallback.onUploadSuccess(value);
                        });
                      }else if (type == "meta"){
                        imageUploadC.getMetaImage(ImageSource.camera);
                      }else if (type == "profile"){
                        imageUploadC.getProfileImage(ImageSource.camera);

                      }
                      //TODO rest of types
                    }),
                  )
                ],
              ),
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}

abstract class UploadMainImageCallBack {
  void onUploadSuccess(File file);
}
