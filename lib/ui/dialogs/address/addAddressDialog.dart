import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_medical_app/data/remote/models/CountryModel.dart';
import 'package:my_medical_app/data/remote/models/VerifiedPhonesModel.dart';
import 'package:my_medical_app/data/remote/models/myAddressesModel.dart';
import 'package:my_medical_app/ui/dialogs/phoneDialog/phoneDialog.dart';
import 'package:my_medical_app/utils/oColors.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

import 'addAddressPresenter.dart';

class AddAddressDialog extends Dialog {
  AddAddressDialog(
      {Key key,
      this.elevation,
      this.insetAnimationDuration = const Duration(milliseconds: 100),
      this.insetAnimationCurve = Curves.decelerate,
      this.context,
      this.title,
      this.phone,
      this.myAddressesList})
      : super(key: key);

  final Color backgroundColor = Colors.transparent;
  final double elevation;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final BuildContext context;
  final String title;
  final String phone;
  List<MyAddressesData> myAddressesList;

  @override
  // TODO: implement child
  ShapeBorder get shape {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0));
  }

  @override
  // TODO: implement child
  Widget get child {
    return AddAddressWidget(
      phone: phone,
      myAddressesList: myAddressesList,
    );
  }
}

class AddAddressWidget extends StatefulWidget {
  final String phone;
  List<MyAddressesData> myAddressesList;

  AddAddressWidget({this.phone, this.myAddressesList});

  @override
  State<StatefulWidget> createState() {
    return AddAddressWidgetState();
  }
}

class AddAddressWidgetState extends State<AddAddressWidget>
    implements AddAddressCallBack {
  AddAddressPresenter presenter;

  List<CountryData> countriesList = List();
  List<CountryData> citiesList = List();
  List<CountryData> provincesList = List();
  List<CountryData> regionsList = List();

  CountryData selectedCountry;
  CountryData selectedCity;
  CountryData selectedProvince;
  CountryData selectedRegion;

  bool isLoadingCountries = false;
  bool isLoadingCities = false;
  bool isLoadingProvinces = false;
  bool isLoadingRegions = false;

  bool isLoadingData = false;

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  List<MyAddressesData> myPhonesList = List();

  // TextEditingController postalCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    phoneController.text = widget.phone;

    if(widget.myAddressesList != null){

      final phones = widget.myAddressesList.map((e) => e.phone).toSet();
      widget.myAddressesList.retainWhere((x) => phones.remove(x.phone));
    }

    if (presenter == null) {
      presenter = AddAddressPresenter(context: context, callBack: this);
      presenter.getCountries();
    }
  }

  bool canEdit = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: SizeConfig.wUnit * 14,
            bottom: SizeConfig.wUnit * 4,
            left: SizeConfig.wUnit * 2,
            right: SizeConfig.wUnit * 2,
          ),
          margin: EdgeInsets.only(top: SizeConfig.wUnit * 10),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(SizeConfig.wUnit * 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      isLoadingCountries
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButton(
                              isExpanded: true,
                              hint: Text('select_country'),
                              value: selectedCountry,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCountry = newValue;
                                  presenter.getProvinces(selectedCountry.id);
                                });
                              },
                              items: countriesList.map((type) {
                                return DropdownMenuItem(
                                  child: new Text(type.name),
                                  value: type,
                                );
                              }).toList(),
                            ),
                      SizedBox(height: SizeConfig.vUnit * 1),
                      isLoadingProvinces
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButton(
                              isExpanded: true,
                              hint: Text('select_province'),
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
                      SizedBox(height: SizeConfig.vUnit * 1),
                      isLoadingCities
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButton(
                              isExpanded: true,
                              hint: Text('select_city'),
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
                      SizedBox(height: SizeConfig.vUnit * 1),
                      isLoadingRegions
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButton(
                              isExpanded: true,
                              hint: Text('select_region'),
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
                      SizedBox(height: SizeConfig.vUnit * 1),
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
                          color: OColors.colorGray2,
                        ),
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: OColors.colorGray2)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: OColors.colorGray2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: OColors.colorGray2),
                          ),
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          labelText:'address',
                        ),
                      ),
                      SizedBox(height: SizeConfig.vUnit * 1),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              readOnly: !canEdit,
                              enabled: canEdit,
                              enableInteractiveSelection: canEdit,
                              controller: phoneController,
                              onFieldSubmitted: (String value) {
                                setState(() {
                                  /*      _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;*/
                                });
                              },
                              style: TextStyle(
                                color: OColors.colorGray2,
                              ),
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: OColors.colorGray2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: OColors.colorGray2),
                                ),
                                labelStyle: Theme.of(context).textTheme.bodyText1,
                                labelText: 'phone',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.wUnit * 2,
                          ),
                          GestureDetector(
                              onTap: () {
                                if (canEdit) {
                                  bool result = false;
                                  for (MyAddressesData address
                                      in widget.myAddressesList) {
                                    if (address.phone ==
                                        phoneController.text
                                            .toString()
                                            .trim()) {
                                      result = true;
                                      break;
                                    }
                                  }

                                  if (!result) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            PhoneDialog(
                                              context: context,
                                              checkThisPhone: phoneController
                                                  .text
                                                  .toString()
                                                  .trim(),
                                            )).then((phone) {
                                      if (phone != null) {
                                        if (phone != "") {
                                          setState(() {
                                            phoneController.text = phone;
                                            canEdit = false;
                                          });
                                        }
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      canEdit = !canEdit;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    canEdit = !canEdit;
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    left: SizeConfig.wUnit,
                                    right: SizeConfig.wUnit),
                                padding: EdgeInsets.only(
                                    top: SizeConfig.vUnit,
                                    bottom: SizeConfig.vUnit,
                                    left: SizeConfig.vUnit,
                                    right: SizeConfig.vUnit),
                                color: OColors.colorAccent,
                                child: Text(
                                  canEdit
                                      ? 'verify'
                                          .toUpperCase()
                                      : 'edit'
                                          .toUpperCase(),
                                  style: TextStyle(
                                    color: OColors.colorWhite,
                                    decoration: TextDecoration.none,
                                    fontSize: SizeConfig.wUnit * 5,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(height: SizeConfig.vUnit * 1),
                      Visibility(
                          visible: canEdit,
                          child: Container(
                            padding: EdgeInsets.all(SizeConfig.wUnit * 3),
                            decoration: BoxDecoration(
                                // color: OColors.colorGreen,
                                border: Border.all(
                                  color: OColors.colorBlack,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('choose_phone' +
                                      ":",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                ListView.separated(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount:widget.myAddressesList.length != null ? widget.myAddressesList.length:0,
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: OColors.colorBlack,
                                      height: 1,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        phoneController.text =
                                            widget.myAddressesList[index].phone;
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          widget.myAddressesList[index].phone,
                                          style: TextStyle(
                                              color: OColors.colorBlack,
                                              fontSize: 15),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.vUnit * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: isLoadingData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            onTap: () {
                              // Navigator.of(context).pop();
                              presenter.addNewAddress(
                                  addressController.text.toString().trim(),
                                  selectedCountry.id.toString(),
                                  selectedProvince.id.toString(),
                                  selectedCity.id.toString(),
                                  selectedRegion.id.toString(),
                                  // postalCodeController.text.toString().trim(),
                                  "0000",
                                  phoneController.text.toString().trim());
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: SizeConfig.wUnit,
                                  right: SizeConfig.wUnit),
                              padding: EdgeInsets.only(
                                  top: SizeConfig.vUnit,
                                  bottom: SizeConfig.vUnit),
                              color: OColors.colorAccent,
                              child: Text('save'
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: OColors.colorWhite,
                                  decoration: TextDecoration.none,
                                  fontSize: SizeConfig.wUnit * 5,
                                ),
                              ),
                            )),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: SizeConfig.wUnit * 2,
          right: SizeConfig.wUnit * 2,
          child: CircleAvatar(
            backgroundColor: OColors.colorWhite,
            radius: SizeConfig.wUnit * 10,
            child: SvgPicture.asset("assets/icons/ic_address.svg",
                semanticsLabel: "address",
//                color: EgColor().defaultText,
                width: SizeConfig.wUnit * 18,
                height: SizeConfig.wUnit * 18),
          ),
        ),
      ],
    );
  }

  @override
  void onCitiesDataLoading(bool show) {
    setState(() {
      isLoadingCities = show;
    });
  }

  @override
  void onCitiesDataSuccess(List<CountryData> data) {
    setState(() {
      citiesList.clear();
      citiesList.addAll(data);
    });
  }

  @override
  void onCountriesDataLoading(bool show) {
    setState(() {
      isLoadingCountries = show;
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
      isLoadingData = show;
    });
  }

  @override
  void onDataSuccess(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            )).then((value) {
      Navigator.of(context).pop();
    });
  }

  @override
  void onRegionsDataLoading(bool show) {
    setState(() {
      isLoadingRegions = show;
    });
  }

  @override
  void onRegionsDataSuccess(List<CountryData> data) {
    setState(() {
      regionsList.clear();
      regionsList.addAll(data);
    });
  }

  @override
  void onProvincesDataLoading(bool show) {
    setState(() {
      isLoadingProvinces = show;
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
    // TODO: implement onLoadVerifiedPhonesDataLoading
  }

  @override
  void onLoadVerifiedPhonesSuccess(List<PhonesData> data) {
    // TODO: implement onLoadVerifiedPhonesSuccess
  }

  @override
  void onActivePhoneSuccess(String message) {
    // TODO: implement onActivePhoneSuccess
  }
}
