import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/edit_delete_address_controller.dart';
import 'package:my_medical_app/data/remote/models/myAddressesModel.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/add_new_address.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/update_profile_presenetr.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/size_config.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';

class MyAddresses extends StatefulWidget {
  final bool isWidget;

  MyAddresses({Key key, @required this.isWidget}) : super(key: key);

  @override
  _MyAddressesState createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses>
    implements GetAddressesCallBack {
  bool isLoading = false;
  List<MyAddressesData> myAddressesList = [];
  UpdatePresenter presenter;
  String phoneNumber;
  final EditDeleteAddressController _editDeleteAddressController =
      Get.put(EditDeleteAddressController());
  getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneNumber = prefs.getString(Constants.phone);
    print("phone is $phoneNumber");
  }

  @override
  void initState() {
    getPhoneNumber();
    if (presenter == null) {
      presenter = UpdatePresenter(context: context, getAddressesCallBack: this);
      presenter.getMyAdresses();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddNewAddress(
              isCheckOut: false,
            );
          }));
        },
        child: Center(
            child: Icon(
          Icons.add,
          color: Colors.white,
        )),
      ),
      appBar: widget.isWidget
          ? Container()
          : AppBar(
              title: Text(
                "${translator.translate("my_addresses")}",
                style: TextStyle(color: Colors.black),
              ),
            ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : myAddressesList.length == 0
              ? Center(
                  child: Text("${translator.translate("no_address_found")}"),
                )
              : ListView(
                  children: myAddressesList.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 12,
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("${e.phone}"),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _editDeleteAddressController
                                          .confirmDeleteAddress(e.id);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                      width: SizeConfig.wUnit * 5, height: 0.0),
                                  GestureDetector(
                                    onTap: () {
                                      //TODO define it is edit
                                      Get.to(() => AddNewAddress(
                                            addressText: e.address,
                                            selectedCountryID: e.country,
                                            selectedProvinceID: e.province,
                                            selectedCityID: e.city,
                                            selectedRegionID: e.region,
                                            selectedPhone: e.phone,
                                            addressID: e.id,
                                            isCheckOut: false,
                                            setDefault: e.setDefault,
                                          ));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${e.address}"),
                              Text("${e.addressCity.name}"),
                              Text("${e.addressCountry.name}"),
                            ],
                          ),
                          leading: Icon(
                            Icons.home,
                            color: primaryColor,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              e.setDefault == 1
                                  ? Text(
                                      "${translator.translate("default_address")}")
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  primaryColor)),
                                      child: Text(
                                        "${translator.translate("set_default")}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        presenter
                                            .setDefaultAddress(e.id.toString());
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }

  @override
  void onGetMyAddressesDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("$message"),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor)),
                  child: Text("${translator.translate("add")}"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddNewAddress(
                        isCheckOut: false,
                      );
                    }));
                  },
                )
              ],
            ));
  }

  @override
  void onGetMyAddressesDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onGetMyAddressesDataSuccess(List<MyAddressesData> data) {
    myAddressesList.clear();
    myAddressesList.addAll(data);
    setState(() {});
  }

  @override
  void onSetDefaultAddressDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onSetDefaultAddressDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onSetDefaultAddressDataSuccess(String message) {
    presenter.getMyAdresses();
    Get.to(() => MyAddresses(isWidget: false));
  }
}
