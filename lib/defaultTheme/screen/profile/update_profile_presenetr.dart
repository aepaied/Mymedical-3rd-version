import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/data/remote/models/myAddressesModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/long_string_print.dart';
import 'package:nb_utils/nb_utils.dart';

class UpdatePresenter {
  final BuildContext context;
  UpdateProfileCallBack updateProfileCallBack;
  ResetPasswordCallBack resetPasswordCallBack;
  GetAddressesCallBack getAddressesCallBack;
  UpdateAvatarCallBack updateAvatarCallBack;
  UpdatePresenter(
      {this.context,
      this.updateProfileCallBack,
      this.resetPasswordCallBack,
      this.getAddressesCallBack,
      this.updateAvatarCallBack});

  updateProfile(String name, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(Constants.id);
    Helpers.getUserData().then((user) {
      // var url = Constants.BASE_URL + 'wishlists?lang='+Constants.API_LANG;
      var url = Constants.BASE_URL + 'auth/profile';
      print(url);
      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, dynamic> body = {};
      print(name);
      print(email);
      if (name != "") {
        body['name'] = name;
      }
      if (email != "") {
        body['email'] = email;
      }

      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), body: body, headers: headers),
          onResponse: (response) {
            LongStringPrint().printWrapped(response.toString());
            if (response['success']) {
              LoginModel data = LoginModel.fromJson(response);
              updateProfileCallBack.onDataSuccess(
                  response['message'], data, response[['code']]);
            } else {
              updateProfileCallBack.onDataError(response['message']);
            }
          },
          onFailure: (error) {
            updateProfileCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            updateProfileCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  updateAvatar(String name, String email, String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(Constants.id);
    Helpers.getUserData().then((user) async {
      LongStringPrint().printWrapped(user.accessToken);
      // var url = Constants.BASE_URL + 'wishlists?lang='+Constants.API_LANG;
      var url = Constants.BASE_URL + 'auth/profile';
      print(url);
      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      var req = http.MultipartRequest("POST", Uri.parse(url));
      req.headers.addAll(headers);
      req.files.add(await MultipartFile.fromPath('avatar', avatar));
      req.files.add(await MultipartFile.fromPath('avatar_original', avatar));
      req.fields['name'] = name;
      // req.fields['email'] = email;
      print(req.fields);
      ApiCallBack(
          context: context,
          call: req,
          onResponse: (response) {
            print(response);
            if (response['success']) {
              LoginModel data = LoginModel.fromJson(response);
              updateAvatarCallBack
                  .onUpdateAvatarSuccess(response['user']['avatar']);
            } else {
              updateAvatarCallBack.onUpdateAvatarError(response['message']);
            }
          },
          onFailure: (error) {
            updateAvatarCallBack.onUpdateAvatarError(error);
          },
          onLoading: (show) {
            updateAvatarCallBack.onUpdateAvatarLoading(show);
          }).makeMultiPartRequest();
    });
  }

  resetPassword(String email, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(Constants.id);
    Helpers.getUserData().then((user) {
      // var url = Constants.BASE_URL + 'wishlists?lang='+Constants.API_LANG;
      var url = Constants.BASE_URL + 'auth/password/create';
      print(url);
      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url),
              body: email != null
                  ? {
                      'email': email,
                    }
                  : {
                      'phone': phone,
                    },
              headers: headers),
          onResponse: (response) {
            if (response['success']) {
              updateProfileCallBack.onDataSuccess(
                  response['message'], null, response['code']);
            } else {
              updateProfileCallBack.onDataError(response['message']);
            }
          },
          onFailure: (error) {
            updateProfileCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            updateProfileCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  changepassword(String newpassword) async {
    Helpers.getUserData().then((user) {
      // var url = Constants.BASE_URL + 'wishlists?lang='+Constants.API_LANG;
      var url = Constants.BASE_URL + 'auth/change_passowrd';
      print(url);
      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url),
              body: {
                "new_password": newpassword,
                "confirm_password": newpassword,
              },
              headers: headers),
          onResponse: (response) {
            if (response['success']) {
              resetPasswordCallBack
                  .onResetPasswordDataSuccess(response['message']);
            } else {
              resetPasswordCallBack
                  .onResetPasswordDataError(response['message']);
            }
          },
          onFailure: (error) {
            resetPasswordCallBack.onResetPasswordDataError(error.toString());
          },
          onLoading: (show) {
            resetPasswordCallBack.onResetPasswordDataLoading(show);
          }).makeRequest();
    });
  }

  getMyAdresses() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'getMyAdresses';

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
            MyAddressesModel data = MyAddressesModel.fromJson(response);
            if (data.success) {
              getAddressesCallBack.onGetMyAddressesDataSuccess(data.data);
            } else {
              getAddressesCallBack
                  .onGetMyAddressesDataError("No Address Found");
            }
          },
          onFailure: (error) {
            getAddressesCallBack.onGetMyAddressesDataError(error.toString());
          },
          onLoading: (show) {
            getAddressesCallBack.onGetMyAddressesDataLoading(show);
          }).makeRequest();
    });
  }

  setDefaultAddress(String id) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'set_default_adress/$id';

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
            print(response);
            MyAddressesModel data = MyAddressesModel.fromJson(response);
            print(data.toString());
            if (response['success']) {
              getAddressesCallBack.onSetDefaultAddressDataSuccess("test");
            } else {
              getAddressesCallBack
                  .onSetDefaultAddressDataError("No Address Found");
            }
          },
          onFailure: (error) {
            getAddressesCallBack.onSetDefaultAddressDataError(error.toString());
          },
          onLoading: (show) {
            getAddressesCallBack.onSetDefaultAddressDataLoading(show);
          }).makeRequest();
    });
  }
}

abstract class UpdateProfileCallBack {
  void onDataSuccess(String message, LoginModel data, int theCode);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class UpdateAvatarCallBack {
  void onUpdateAvatarSuccess(String newAvatar);

  void onUpdateAvatarLoading(bool show);

  void onUpdateAvatarError(String message);
}

abstract class ResetPasswordCallBack {
  void onResetPasswordDataSuccess(String message);

  void onResetPasswordDataLoading(bool show);

  void onResetPasswordDataError(String message);
}

abstract class GetAddressesCallBack {
  void onGetMyAddressesDataSuccess(List<MyAddressesData> data);

  void onGetMyAddressesDataLoading(bool show);

  void onGetMyAddressesDataError(String message);
  void onSetDefaultAddressDataSuccess(String message);

  void onSetDefaultAddressDataLoading(bool show);

  void onSetDefaultAddressDataError(String message);
}
