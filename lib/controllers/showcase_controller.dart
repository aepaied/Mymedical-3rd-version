import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseController extends GetxController {
  final searchShowcase = GlobalKey();
  final catShowcase = GlobalKey();
  final accountShowcaseKey = GlobalKey();
  final appbarCartShowcaseKey = GlobalKey();
  BuildContext myContext;

  bool showShowcase() {
    final box = GetStorage();
    bool show = box.read('show_showcase');
    return show == null || show ? true : false;
  }

  runShowcase() {
    if (showShowcase()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(myContext)
            .startShowCase([searchShowcase, catShowcase]);
      });
    }
  }

  // runSecondShowcase() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ShowCaseWidget.of(secondContext).startShowCase([accountShowcaseKey]);
  //   });
  // }

  // runThirdShowcase() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ShowCaseWidget.of(appbarCartContext)
  //         .startShowCase([appbarCartShowcaseKey]);
  //   });
  // }

  finishShowcase() {
    final box = GetStorage();
    box.write("show_showcase", false);
  }
}
