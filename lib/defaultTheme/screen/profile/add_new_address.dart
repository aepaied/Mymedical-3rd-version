import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/otp_controller.dart';
import 'package:my_medical_app/data/remote/models/CountryModel.dart';
import 'package:my_medical_app/data/remote/models/VerifiedPhonesModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTOrderSummaryScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/my_addresses.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/ui/dialogs/address/addAddressPresenter.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/otp/otp_widget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

class AddNewAddress extends StatefulWidget {
  final bool isCheckOut;
  final double subTotal;
  final double tax;
  final int selectedCountryID;
  final String addressText;
  final String selectedPhone;
  final int selectedCityID;
  final int selectedProvinceID;
  final int selectedRegionID;
  final int addressID;
  final int setDefault;

  AddNewAddress(
      {Key key,
      @required
          this.isCheckOut, //Got check out or not so we can show the order summary screen after adding the address
      this.subTotal,
      this.tax,
      this.addressText,
      this.selectedCountryID,
      this.selectedCityID,
      this.selectedProvinceID,
      this.selectedRegionID,
      this.addressID,
      this.selectedPhone,
      this.setDefault})
      : super(key: key);

  @override
  _AddNewAddressState createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress>
    implements AddAddressCallBack {
  AddAddressPresenter presenter;
  bool isLoading = false;
  List<CountryData> countriesList = [];
  List<CountryData> citiesList = [];
  List<CountryData> provincesList = [];
  List<CountryData> regionsList = [];
  List<PhonesData> myPhones = [];
  PhonesData selectedPhone;
  CountryData selectedCountry;
  CountryData selectedCity;
  CountryData selectedProvince;
  CountryData selectedRegion;

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool canEdit = false;

  bool showAllFieldsError = false;

  @override
  void initState() {
    if (presenter == null) {
      presenter = AddAddressPresenter(context: context, callBack: this);
      presenter.getCountries();
      presenter.getMyVerifiedPhones();
      if (widget.selectedCountryID != null) {
        isLoading = true;
        setState(() {});
      }
      Future.delayed(Duration(seconds: 3), () {
        if (widget.selectedCountryID != null) {
          addressController.text = widget.addressText;
          presenter.getProvinces(widget.selectedCountryID);
          presenter.getCities(widget.selectedProvinceID);
          presenter.getRegions(widget.selectedCityID);
          selectedCountry = getSelectedCountry(widget.selectedCountryID);
          selectedProvince = getSelectedProvince(widget.selectedProvinceID);
          selectedCity = getSelectedCity(widget.selectedCityID);
          selectedRegion = getSelectedRegion(widget.selectedRegionID);
          selectedPhone = getSelectedPhone(widget.selectedPhone);
        }
        isLoading = false;
        setState(() {});
      });
    }
    setState(() {});
    super.initState();
  }

  CountryData getSelectedCountry(int theID) {
    CountryData theCountry;
    print(theCountry);
    print(countriesList.length);
    for (var item in countriesList) {
      if (item.id == theID) {
        theCountry = item;
        print(theCountry);
      }
    }
    print(theCountry);
    return theCountry;
  }

  CountryData getSelectedProvince(int theID) {
    CountryData theProvince;
    for (var item in provincesList) {
      if (item.id == theID) {
        theProvince = item;
      }
    }
    return theProvince;
  }

  CountryData getSelectedCity(int theID) {
    CountryData theCity;
    for (var item in citiesList) {
      if (item.id == theID) {
        theCity = item;
      }
    }
    return theCity;
  }

  CountryData getSelectedRegion(int theID) {
    CountryData theRegion;
    for (var item in regionsList) {
      if (item.id == theID) {
        theRegion = item;
      }
    }
    return theRegion;
  }

  PhonesData getSelectedPhone(String theNumber) {
    PhonesData thePhone;
    for (var item in myPhones) {
      if (item.phone == theNumber) {
        thePhone = item;
      }
    }
    return thePhone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${translator.translate("add_address")}",
        isHome: false,
      ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.selectedCityID == null
                                ? "${translator.translate("add_new_address")}"
                                : "${translator.translate("edit_address")}",
                            style: TextStyle(color: primaryColor, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    myPhones.length == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "${translator.translate("no_phones_found")}"),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor)),
                                  onPressed: () {
                                    final OTPController otpC =
                                        Get.put(OTPController());
                                    otpC.smsSent.value = false;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AddPhoneDialog());
                                  },
                                  child: Text(
                                      '${translator.translate("click_to_add")}'))
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(widget.selectedPhone == null
                                      ? '${translator.translate("select_phone")}'
                                      : '${selectedPhone.phone}'),
                                  value: selectedPhone,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedPhone = newValue;
                                    });
                                  },
                                  items: myPhones.map((type) {
                                    return DropdownMenuItem(
                                      child: new Text(type.phone),
                                      value: type,
                                    );
                                  }).toList(),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AddPhoneDialog());
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                  ))
                            ],
                          ),
                    DropdownButton(
                      isExpanded: true,
                      hint: Text(widget.selectedCountryID == null
                          ? '${translator.translate("select_country")}'
                          : '${selectedCountry.name}'),
                      value: selectedCountry,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCountry = newValue;
                          if (provincesList.isEmpty) {
                            presenter.getProvinces(selectedCountry.id);
                          }
                        });
                      },
                      items: countriesList.map((type) {
                        return DropdownMenuItem(
                          child: new Text(type.name),
                          value: type,
                        );
                      }).toList(),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      hint: Text(widget.selectedProvinceID == null
                          ? '${translator.translate("select_province")}'
                          : "${selectedProvince.name}"),
                      value: selectedProvince,
                      onChanged: (newValue) {
                        setState(() {
                          selectedProvince = newValue;
                          presenter.getCities(selectedProvince.id);
                        });
                      },
                      items: provincesList.map((type) {
                        return DropdownMenuItem(
                          child: new Text(type.name),
                          value: type,
                        );
                      }).toList(),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      hint: Text('${translator.translate("select_city")}'),
                      value: selectedCity,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCity = newValue;
                          presenter.getRegions(selectedCity.id);
                        });
                      },
                      items: citiesList.map((type) {
                        return DropdownMenuItem(
                          child: new Text(type.name),
                          value: type,
                        );
                      }).toList(),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      hint: Text('${translator.translate("select_region")}'),
                      value: selectedRegion,
                      onChanged: (newValue) {
                        setState(() {
                          selectedRegion = newValue;
                        });
                      },
                      items: regionsList.map((type) {
                        return DropdownMenuItem(
                          child: new Text(type.name),
                          value: type,
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      controller: addressController,
                      onFieldSubmitted: (String value) {
                        setState(() {
                          /*      _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;*/
                        });
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        labelText: '${translator.translate("address")}',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    !showAllFieldsError
                        ? Container()
                        : Text(
                            "${translator.translate("please_fill_all_fields")}",
                            style: TextStyle(color: Colors.red),
                          ),
                    selectedPhone == null
                        ? Container()
                        : T3AppButton(
                            textContent: widget.selectedCityID == null
                                ? "${translator.translate("add")}"
                                : "${translator.translate("edit")}",
                            onPressed: () {
                              if (widget.selectedCityID != null) {
                                if (selectedCountry == null ||
                                    selectedProvince == null ||
                                    selectedCity == null ||
                                    selectedRegion == null ||
                                    addressController.text == "") {
                                  showAllFieldsError = true;
                                  setState(() {});
                                  Future.delayed(Duration(seconds: 2), () {
                                    showAllFieldsError = false;
                                    setState(() {});
                                  });
                                } else {
                                  print(widget.setDefault.toString());
                                  presenter.editAddress(
                                      widget.addressID.toString(),
                                      addressController.text.toString().trim(),
                                      selectedCountry.id.toString(),
                                      selectedProvince.id.toString(),
                                      selectedCity.id.toString(),
                                      selectedRegion.id.toString(),
                                      // postalCodeController.text.toString().trim(),
                                      "0000",
                                      selectedPhone.phone.toString().trim(),
                                      widget.setDefault.toString());
                                }
                              } else {
                                if (selectedCountry == null ||
                                    selectedProvince == null ||
                                    selectedCity == null ||
                                    selectedRegion == null ||
                                    addressController.text == "") {
                                  showAllFieldsError = true;
                                  setState(() {});
                                  Future.delayed(Duration(seconds: 2), () {
                                    showAllFieldsError = false;
                                    setState(() {});
                                  });
                                } else {
                                  presenter.addNewAddress(
                                      addressController.text.toString().trim(),
                                      selectedCountry.id.toString(),
                                      selectedProvince.id.toString(),
                                      selectedCity.id.toString(),
                                      selectedRegion.id.toString(),
                                      // postalCodeController.text.toString().trim(),
                                      "0000",
                                      selectedPhone.phone.toString().trim());
                                }
                              }
                            })
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void onCitiesDataLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void onCitiesDataSuccess(List<CountryData> data) {
    setState(() {
      citiesList.clear();
      citiesList.addAll(data);
      selectedCity = citiesList[0];
      presenter.getRegions(citiesList[0].id);
    });
  }

  @override
  void onCountriesDataLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void onCountriesDataSuccess(List<CountryData> data) {
    setState(() {
      countriesList.clear();
      countriesList.addAll(data);
    });
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }
//IT all working
  @override
  void onDataSuccess(String message) {
    //MM-44 this part made sure that the user will be redirected to the previous page
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            )).then((value) {
      //the check togo back to order or my addresses
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return widget.isCheckOut
            ? DTOrderSummaryScreen(
                subTotal: widget.subTotal,
                tax: widget.tax,
              )
            : MyAddresses(
                isWidget: false,
              );
      }));
    });
  }

  @override
  void onRegionsDataLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void onRegionsDataSuccess(List<CountryData> data) {
    setState(() {
      regionsList.clear();
      regionsList.addAll(data);
      selectedRegion = regionsList[0];
    });
  }

  @override
  void onProvincesDataLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void onProvincesDataSuccess(List<CountryData> data) {
    setState(() {
      provincesList.clear();
      provincesList.addAll(data);
    });
  }

  @override
  void onLoadVerifiedPhonesDataLoading(bool show) {
    isLoading = show;
  }

  @override
  void onLoadVerifiedPhonesSuccess(List<PhonesData> data) {
    myPhones = data;
    setState(() {});
  }
}

class AddPhoneDialog extends StatefulWidget {
  @override
  _AddPhoneDialogState createState() => _AddPhoneDialogState();
}

class _AddPhoneDialogState extends State<AddPhoneDialog>
    implements ActivePhoneCallBack {
  TextEditingController newPhoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  bool codeSent = false;
  bool isLoading = false;
  AddAddressPresenter presenter;

  @override
  void initState() {
    if (presenter == null) {
      presenter = AddAddressPresenter(context: context, phoneCallBack: this);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OTPCustomDialog(isRegister: false);
    /*return AlertDialog(
      title: Text("${translator.translate("add_new_phone")}"),
      content: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                codeSent
                    ? TextField(
                        controller: codeController,
                        decoration: InputDecoration(
                            hintText: "${translator.translate("code")}"),
                      )
                    : TextField(
                        controller: newPhoneController,
                        decoration: InputDecoration(
                            hintText: "${translator.translate("phone")}"),
                      ),
                SizedBox(
                  height: 10,
                ),
                T3AppButton(
                    textContent: "${translator.translate("confirm")}",
                    onPressed: () {
                      if (!codeSent) {
                        presenter.sendOtpCode(newPhoneController.text);
                      } else {
                        presenter.activePhone(
                            newPhoneController.text, codeController.text);
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                codeSent
                    ? Text("${translator.translate("code_sent_to_your_phone")}")
                    : Container()
              ],
            ),
    );*/
  }

  @override
  void onActivePhoneSuccess(String message) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return AddNewAddress(
        isCheckOut: false,
      );
    }));
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
  void onOtpError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onOtpSuccess(String message) {
    codeSent = true;
    setState(() {});
  }
}
