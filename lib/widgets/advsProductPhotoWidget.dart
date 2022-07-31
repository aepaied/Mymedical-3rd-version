import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_medical_app/controllers/image_upload_controller.dart';
import 'package:my_medical_app/ui/dialogs/imageDialog.dart';
import 'package:my_medical_app/utils/oColors.dart';
import 'package:my_medical_app/widgets/image_upload_dialog.dart';

class AdvsProductPhotoWidget extends StatefulWidget {
  String photoPath;
  String photoUrl;
  File photoFile;

  AdvsProductPhotoWidget({this.photoPath, this.photoFile, this.photoUrl});
  final ImageUploadController imageUploadC = Get.put(ImageUploadController());
  @override
  State<StatefulWidget> createState() {
    return AdvsProductPhotoWidgetState();
  }
}

class AdvsProductPhotoWidgetState extends State<AdvsProductPhotoWidget> implements UploadMainImageCallBack{
  final picker = ImagePicker();

  // String mainImage = "";
  // File main_image;

  Future getMainImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        widget.photoPath = "";
        widget.photoFile = File(pickedFile.path);
        print('_image path => ' + pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ImageUploadDialog(type:"main",uploadImageCallback: this,),
        );

/*
        showDialog(
            context: context,
            builder: (BuildContext context) => ImageDialog(
                  context: context,
                  viewRemoveImage: false,
                )).then((type) {
          switch (type) {
            case 1: // take photo from camera
              {
                getMainImage(ImageSource.camera);
              }
              break;
            case 2: // choose image from gallery
              {
                getMainImage(ImageSource.gallery);
              }
              break;
            */
/* case 3: // remove image
                                  {
                                    // presenter.removeProfileImage();
                                  }
                                  break;*//*

          }
        });
*/
      },
      child: Container(
        // width: 160,
        height: 100,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(6),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: OColors.colorGray),
          image: DecorationImage(
            image: widget.photoPath == ""
                ? widget.photoFile == null
                    ? AssetImage('assets/images/add.png')
                    : FileImage(widget.photoFile)
                : NetworkImage(widget.photoPath),
          ),
        ),
      ),
    );
  }

  @override
  void onUploadSuccess(File file) {
    widget.photoPath = "";
    widget.photoFile = file;
    setState(() {});
  }
}
