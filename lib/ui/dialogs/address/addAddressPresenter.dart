import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/ActivePhoneModel.dart';
import 'package:my_medical_app/data/remote/models/AddAddressModel.dart';
import 'package:my_medical_app/data/remote/models/CountryModel.dart';
import 'package:my_medical_app/data/remote/models/OtpModel.dart';
import 'package:my_medical_app/data/remote/models/VerifiedPhonesModel.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/update_profile_presenetr.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';

class AddAddressPresenter {
  final BuildContext context;
  AddAddressCallBack callBack;
  ActivePhoneCallBack phoneCallBack;

  AddAddressPresenter({this.context, this.callBack, this.phoneCallBack});

  getCountries() {
    var url = Constants.BASE_URL + 'getCountries';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          CountryModel data = CountryModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onCountriesDataSuccess(data.data);
          } else {
            callBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          callBack.onDataError(error.toString());
        },
        onLoading: (show) {
          callBack.onCountriesDataLoading(show);
        }).makeRequest();
  }

  getProvinces(int countryId) {
    var url =
        Constants.BASE_URL + 'getProvincesByCountryId/' + countryId.toString();

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          CountryModel data = CountryModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onProvincesDataSuccess(data.data);
          } else {
            callBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          callBack.onDataError(error.toString());
        },
        onLoading: (show) {
          callBack.onProvincesDataLoading(show);
        }).makeRequest();
  }

  getCities(int ProvinceId) {
    var url =
        Constants.BASE_URL + 'getCitiesByProvinceId/' + ProvinceId.toString();

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          CountryModel data = CountryModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onCitiesDataSuccess(data.data);
          } else {
            callBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          callBack.onDataError(error.toString());
        },
        onLoading: (show) {
          callBack.onCitiesDataLoading(show);
        }).makeRequest();
  }

  getRegions(int cityId) {
    var url = Constants.BASE_URL + 'getRegionsByCityId/' + cityId.toString();

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };

    ApiCallBack(
        context: context,
        call: http.get(Uri.parse(url), headers: headers),
        onResponse: (response) {
          CountryModel data = CountryModel.fromJson(response);
          print(data.toString());
          if (data.success) {
            callBack.onRegionsDataSuccess(data.data);
          } else {
            callBack.onDataError("Error");
          }
        },
        onFailure: (error) {
          callBack.onDataError(error.toString());
        },
        onLoading: (show) {
          callBack.onRegionsDataLoading(show);
        }).makeRequest();
  }

  getMyVerifiedPhones() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'getMyVerifiedPhones';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
            VerifiedPhonesModel data = VerifiedPhonesModel.fromJson(response);
            print(response);
            if (data.success) {
              callBack.onLoadVerifiedPhonesSuccess(data.data);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onLoadVerifiedPhonesDataLoading(show);
          }).makeRequest();
    });
  }

  sendOtpCode(String phone) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'sendOtpCode';
      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, String> body = {
        'phone': phone,
      };

      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers, body: body),
          onResponse: (response) {
            print(response);
            OtpModel data = OtpModel.fromJson(response);
            print(response);
            print(data.toString());
            if (data.success) {
              phoneCallBack.onOtpSuccess(data.message);
            } else {
              phoneCallBack.onOtpError(data.message);
            }
          },
          onFailure: (error) {
            print(error);
            phoneCallBack.onOtpError(error.toString());
          },
          onLoading: (show) {
            phoneCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  activePhone(String phone, String code) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'activePhone';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, dynamic> body = {'phone': phone, 'code': code};

      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers, body: body),
          onResponse: (response) {
            ActivePhoneModel data = ActivePhoneModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              phoneCallBack.onActivePhoneSuccess(data.message);
            } else {
              phoneCallBack.onDataError(data.message);
            }
          },
          onFailure: (error) {
            phoneCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            phoneCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  addNewAddress(String address, String countryId, String provinceId,
      String cityId, String regionId, String postalCode, String phone) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'addNewAdress';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      var req = http.MultipartRequest("POST", Uri.parse(url));
      req.headers.addAll(headers);

      req.fields['user_id'] = user.id;
      req.fields['address'] = address;
      req.fields['country'] = countryId;
      req.fields['province'] = provinceId;
      req.fields['city'] = cityId;
      req.fields['region'] = regionId;
      req.fields['postal_code'] = postalCode;
      req.fields['phone'] = phone;

      ApiCallBack(
          context: context,
          call: req,
          onResponse: (response) {
            print(response);
            AddAddressModel data = AddAddressModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onDataSuccess(data.message);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onDataLoading(show);
          }).makeMultiPartRequest();
    });
  }

  editAddress(
      String addressID,
      String address,
      String countryId,
      String provinceId,
      String cityId,
      String regionId,
      String postalCode,
      String phone,
      String setDefault) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'editUserAddress';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      var req = http.MultipartRequest("POST", Uri.parse(url));
      req.headers.addAll(headers);

      req.fields['id'] = addressID;
      req.fields['address'] = address;
      req.fields['country'] = countryId;
      req.fields['province'] = provinceId;
      req.fields['city'] = cityId;
      req.fields['region'] = regionId;
      req.fields['postal_code'] = postalCode;
      req.fields['phone'] = phone;
      print(addressID.toString());
      ApiCallBack(
          context: context,
          call: req,
          onResponse: (response) {
            print(response);
            AddAddressModel data = AddAddressModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              if (setDefault == 1.toString()) {
                UpdatePresenter presneter = UpdatePresenter();
                presneter.setDefaultAddress(addressID.toString());
              }

              callBack.onDataSuccess(data.message);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onDataLoading(show);
          }).makeMultiPartRequest();
    });
  }
}

abstract class AddAddressCallBack {
  void onDataLoading(bool show);

  void onDataError(String message);

  void onDataSuccess(String message);

  void onCountriesDataLoading(bool show);

  void onCountriesDataSuccess(List<CountryData> data);

  void onLoadVerifiedPhonesSuccess(List<PhonesData> data);

  void onLoadVerifiedPhonesDataLoading(bool show);

  void onProvincesDataLoading(bool show);

  void onProvincesDataSuccess(List<CountryData> data);

  void onCitiesDataLoading(bool show);

  void onCitiesDataSuccess(List<CountryData> data);

  void onRegionsDataLoading(bool show);

  void onRegionsDataSuccess(List<CountryData> data);
}

abstract class ActivePhoneCallBack {
  void onActivePhoneSuccess(String message);
  void onDataError(String message);
  void onDataLoading(bool show);
  void onOtpSuccess(String message);
  void onOtpError(String message);
}
