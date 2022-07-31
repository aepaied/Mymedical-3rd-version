import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/no_internet.png',
            width: 150,
          ),
          Text("${translator.translate("no_internet")}")
        ]),
      ),
    );
  }
}
