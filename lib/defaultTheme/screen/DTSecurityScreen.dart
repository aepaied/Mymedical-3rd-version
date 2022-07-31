import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';

import 'DTChangePasswordScreen.dart';
import 'DTDrawerWidget.dart';

class DTSecurityScreen extends StatefulWidget {
  static String tag = '/DTSecurityScreen';

  @override
  DTSecurityScreenState createState() => DTSecurityScreenState();
}

class DTSecurityScreenState extends State<DTSecurityScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${translator.translate("security")}',),
      body: Column(
        children: [
          settingItem(context, 'Change Password', onTap: () {
            DTChangePasswordScreen().launch(context);
          }, leading: Icon(AntDesign.lock), detail: SizedBox()),
        ],
      ),
    );
  }
}
