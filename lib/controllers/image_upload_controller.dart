import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_medical_app/defaultTheme/screen/DTProfileScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/update_profile_presenetr.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUploadController extends GetxController
    implements UpdateAvatarCallBack {
  final picker = ImagePicker();
  var thumbImage = "".obs;
  var thumb_image = File("").obs;
  var metaImage = "".obs;
  var meta_image = File("").obs;
  var profileImage = "".obs;
  var profile_image = File("").obs;
  var photoPath = "".obs;
  var photoUrl = "".obs;
  var photoFile = File("").obs;
  UpdatePresenter upDatePresenter;
  User currentUser;

  Future getThumbImage(ImageSource source) async {
    await picker.getImage(source: source).then((pickedFile) {
      if (pickedFile != null) {
        thumbImage.value = "";
        thumb_image.value = File(pickedFile.path);
        print('_image path => ' + pickedFile.path);
        Get.back();
      } else {
        print('No image selected.');
        Get.back();
      }
    });
  }

  Future getMetaImage(ImageSource source) async {
    await picker.getImage(source: source).then((pickedFile) {
      if (pickedFile != null) {
        metaImage.value = "";
        meta_image.value = File(pickedFile.path);
        print('_image path => ' + pickedFile.path);
        Get.back();
      } else {
        print('No image selected.');
        Get.back();
      }
    });
  }

  Future getProfileImage(ImageSource source) async {
    await picker.getImage(source: source).then((pickedFile) {
      if (pickedFile != null) {
        profileImage.value = "";
        profile_image.value = File(pickedFile.path);
        print('_image path => ' + pickedFile.path);
        updateProfile(pickedFile.path);
        Get.back();
      } else {
        print('No image selected.');
        Get.back();
      }
    });
  }

  updateProfile(String avatar) {
    if (upDatePresenter == null) {
      upDatePresenter =
          UpdatePresenter(context: Get.context, updateAvatarCallBack: this);
    }
    upDatePresenter.updateAvatar(currentUser.name, currentUser.email, avatar);
  }

  Future<File> getMainImage(ImageSource source) async {
    return await picker.getImage(source: source).then((pickedFile) {
      if (pickedFile != null) {
        photoPath.value = "";
        print('_image path => ' + pickedFile.path);
        Get.back();
        return photoFile.value = File(pickedFile.path);
      } else {
        Get.back();
        print('No image selected.');
        return null;
      }
    });
  }

  @override
  void onUpdateAvatarError(String message) {
    showDialog(
        context: Get.context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onUpdateAvatarLoading(bool show) {}

  @override
  void onUpdateAvatarSuccess(String newAvatar) {
    currentUser.avatar = newAvatar;
    setClientImage();
    print(currentUser.avatar);
  }

  setClientImage() async {
    final box = GetStorage();
    box.write(Constants.avatar, currentUser.avatar ?? "");
    box.write(Constants.avatar_original, currentUser.avatarOriginal ?? "");
    Get.to(() => ShHomeScreen());
  }
}
