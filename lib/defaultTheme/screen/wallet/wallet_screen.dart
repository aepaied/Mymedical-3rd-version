import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/walletHistoryModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTDrawerWidget.dart';
import 'package:my_medical_app/defaultTheme/screen/checkout/fawryScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/wallet/wallet_presenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/theme12/utils/t12_colors.dart';
import 'package:my_medical_app/theme12/utils/t12_constant.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/rechargeWalletDialog.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> implements WalletCallBack {
  WalletPresenter presenter;
  bool isLoading = false;
  double currentWalletBalance = 0;
  List<WalletHistoryData> myWalletHistoryList = [];

  @override
  void initState() {
    if (presenter == null) {
      presenter = WalletPresenter(context: context, callBack: this);
      presenter.getWalletBalance();
      presenter.getWalletHistory();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var categoryWidth = (width - 56) / 4;

    return Scaffold(
      appBar: CustomAppBar(
        title: "${translator.translate("wallet")}",
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height,
        child: DrawerWidget(
          categoriesList: categoriesList,
        ),
      ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${translator.translate("my_wallet")}',
                              style: TextStyle(fontSize: 22),
                            ),
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: primaryColor,
                              size: 50,
                            ),
                            Text("${translator.translate("balance")}"),
                            Text(
                                "$currentWalletBalance ${translator.translate("egp")}"),
                            SizedBox(
                              height: 20,
                            ),
                            T3AppButton(
                                textContent:
                                    "${translator.translate("recharge_wallet")}",
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          RechargeWalletDialog(
                                            context: context,
                                          )).then((value) {
                                    if (value != null) {
                                      if (value != 0) {
                                        Helpers.getUserData().then((user) {
                                          var url =
                                              'https://mymedicalshope.com/recharge_wallet_with_paysky/' +
                                                  user.id +
                                                  '/' +
                                                  value;
                                          Navigator.of(context)
                                              .pushNamed('/Fawry',
                                                  arguments: url)
                                              .then((value) {
                                            presenter.getWalletBalance();
                                          });
                                        });
                                      }

                                      RechargePaymentMethod rpm = value;

                                      if (rpm.type == "paysky") {
                                        Helpers.getUserData().then((user) {
                                          var url =
                                              'https://mymedicalshope.com/recharge_wallet_with_paysky/' +
                                                  user.id +
                                                  '/' +
                                                  rpm.amount;
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return FawryScreen(
                                              url: url,
                                              title: "PaySky",
                                            );
                                          })).then((value) {
                                            presenter.getWalletBalance();
                                          });
                                        });
                                      } else if (rpm.type == "fawry") {
                                        Helpers.getUserData().then((user) {
                                          var url =
                                              'https://mymedicalshope.com/charge_wallet_with_fawry/ar/' +
                                                  user.id +
                                                  '/' +
                                                  rpm.amount;
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return FawryScreen(
                                                url: url, title: "Fawry");
                                          })).then((value) {
                                            presenter.getWalletBalance();
                                          });
                                        });
                                      }
                                    }
                                  });
                                }),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: myWalletHistoryList.map((e) {
                    return /*text(
                    e.createdAt,
                    fontSize: textSizeMedium,
                    textColor: t12_text_secondary,
                    fontFamily: fontMedium,
                  ).paddingOnly(top: 12, bottom: spacing_standard_new).visible(
                      e.createdAt
                          .toString()
                          .isNotEmpty)*/
                        transactionWidget(e, categoryWidth);
                  }).toList(),
                ))
              ],
            ),
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onDataSuccess(double balance) {
    currentWalletBalance = balance;
    setState(() {});
  }

  @override
  void onWalletHistoryDataSuccess(List<WalletHistoryData> data) {
    myWalletHistoryList = data;
    setState(() {});
  }

  Widget transactionWidget(WalletHistoryData transaction, var categoryWidth) {
    DateTime theDate = DateTime.parse(transaction.createdAt);
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: boxDecoration(
          bgColor: Colors.white, showShadow: true, radius: spacing_standard),
      padding: EdgeInsets.all(spacing_standard),
      margin: EdgeInsets.only(bottom: spacing_standard),
      child: Row(
        children: <Widget>[
          Image.asset(
            transaction.paymentMethod == "paysky"
                ? "assets/images/visa_master_logo.png"
                : transaction.paymentMethod == "fawry"
                    ? "assets/images/fawry.png"
                    : "assets/images/logo.png",
            width: categoryWidth * 0.75,
            height: categoryWidth * 0.75,
          )
              .cornerRadiusWithClipRRect(spacing_standard)
              .paddingRight(spacing_standard),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                text(transaction.paymentDetails,
                    fontSize: textSizeMedium,
                    textColor: appStore.textPrimaryColor,
                    fontFamily: fontMedium),
                text(transaction.paymentDetails,
                        fontSize: textSizeMedium,
                        textColor: appStore.textSecondaryColor)
                    .paddingTop(spacing_control_half),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              text(
                  transaction.paymentMethod == "Refund" ||
                          transaction.paymentMethod == "from_admin"
                      ? "+ \ ${translator.translate("egp")} " +
                          transaction.amount.toString()
                      : "- \ ${translator.translate("egp")} " +
                          transaction.amount.toString(),
                  fontSize: textSizeMedium,
                  textColor: transaction.paymentMethod == "Refund" ||
                          transaction.paymentMethod == "from_admin"
                      ? t12_success
                      : t12_error,
                  fontFamily: fontBold),
              text(theDate.timeAgo,
                      fontSize: textSizeMedium,
                      textColor: appStore.textSecondaryColor)
                  .paddingTop(spacing_control)
            ],
          )
        ],
      ),
    );
  }
}
