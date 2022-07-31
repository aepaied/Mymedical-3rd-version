import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/facebookModel.dart';
import 'package:my_medical_app/data/remote/models/forgetPasswordModel.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/data/remote/models/logoutModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_medical_app/utils/helpers.dart';

class AuthPresenter {
  final BuildContext context;
  LoginCallBack loginCallBack;
  ForgetPasswordCallBack forgetPasswordCallBack;
  LogoutCallBack logoutCallBack;

  AuthPresenter(
      {this.context,
      this.loginCallBack,
      this.forgetPasswordCallBack,
      this.logoutCallBack});

/*  makeSignIn(String email, String password) {
    var url = Constants.BASE_URL + 'auth/login?lang=' + Constants.API_LANG;
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest'
    };
    ApiCallBack(
        context: context,
        call: http.post(url,
            body: {
              'email': email,
              'password': password,
              'remember_me': 0.toString()
            },
            headers: headers),
        onResponse: (response) {
          LoginModel data = LoginModel.fromJson(response);
          print(data.toString());
          if (data.status) {
            String av = (data.user.avatar == null ? '' : data.user.avatar);
            data.user.avatar = Constants.IMAGE_BASE_URL + av;
            loginCallBack.onDataSuccess(data);
          } else {
            loginCallBack.onDataError(data.message);
          }
        },
        onFailure: (error) {
          loginCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          loginCallBack.onDataLoading(show);
        }).makeRequest();
  }*/

  makeSignIn(String email, String phone, String password) {
    Map<String, dynamic> erros = {};
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint("device token $value");
      var url = Constants.BASE_URL + 'auth/login';
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, String> body = email != ""
          ? {'email': email, 'password': password, 'device_token': value}
          : {'phone': phone, 'password': password, 'device_token': value};
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers, body: body),
          onResponse: (response) {
            LoginModel data = LoginModel.fromJson(response);
            if (data.success) {
              String av = (data.user.avatar == null ? null : data.user.avatar);
              data.user.avatar = av;
              String avo = (data.user.avatarOriginal == null
                  ? null
                  : data.user.avatarOriginal);
              data.user.avatarOriginal = avo;
              loginCallBack.onDataSuccess(data, false);
            } else {
              print("res is ${response['errors']}");
              loginCallBack.onDataError(data.message);
            }
          },
          onFailure: (error) {
            print(error);
            loginCallBack.onDataError(
              error.toString(),
            );
          },
          errorsList: (errors) {
            loginCallBack.onErrorList(errors);
          },
          onLoading: (show) {
            loginCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  makeSocialLogin(String email, String name, String socialAvatar) {
    debugPrint(socialAvatar);
    Helpers.getFcmToken().then((token) {
      debugPrint("device token $token");
      // var url = Constants.BASE_URL + 'auth/social-login?lang=' + Constants.API_LANG;
      var url = Constants.BASE_URL + 'auth/social-login';
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url),
              body: {'email': email, 'name': name, 'device_token': token},
              headers: headers),
          onResponse: (response) {
            LoginModel data = LoginModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              String av = (data.user.avatar == null ? null : data.user.avatar);
              data.user.avatar = av;
              String avo = (data.user.avatarOriginal == null
                  ? null
                  : data.user.avatarOriginal);
              data.user.avatarOriginal = avo;
              loginCallBack.onSocialDataSuccess(data);
            } else {
              loginCallBack.onDataError(data.message);
            }
          },
          onFailure: (error) {
            loginCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            loginCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  getFacebookData(String token) {
    var url =
        'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}';

    ApiCallBack(
            context: context,
            call: http.get(Uri.parse(url)),
            onResponse: (response) {
              FacebookModel data = FacebookModel.fromJson(response);
              print(data.toString());

              makeSocialLogin(data.email, data.name, data.picture.data.url);
            },
            onFailure: (error) {
              loginCallBack.onDataError(error.toString());
            },
            onLoading: (show) {
              // loginCallBack.onDataLoading(show);
            })
        .makeRequest();
  }

  makeLogout() {
    Helpers.getMyToken().then((_result) {
      // var url = Constants.BASE_URL + 'auth/logout?lang=' + Constants.API_LANG;
      var url = Constants.BASE_URL + 'auth/logout';

      Map<String, String> headers = {
        'Authorization': _result,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
            LogoutModel data = LogoutModel.fromJson(response);
            print(data.toString());
            if (data.status) {
              logoutCallBack.onLogoutDataSuccess(data.message);
            } else {
              logoutCallBack.onLogoutDataError(data.message);
            }
          },
          onFailure: (error) {
            logoutCallBack.onLogoutDataError(error.toString());
          },
          onLoading: (show) {
            logoutCallBack.onLogoutDataLoading(show);
          }).makeRequest();
    });
  }

  makeRegister(String name, String email, String phone, String password,
      String passowrd_confirmation, String token) {
    Helpers.getFcmToken().then((token) {
      // var url = Constants.BASE_URL + 'auth/signup?lang=' + Constants.API_LANG;

      var url = Constants.BASE_URL + 'auth/signup';

      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, String> body = email != ""
          ? {
              'name': name,
              'email': email,
              'password': password,
              'device_token': token
            }
          : {
              'name': name,
              'phone': phone,
              'password': password,
              'device_token': token
            };
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers, body: body),
          onResponse: (response) {
            debugPrint(response.toString());
            // LoginModel data = LoginModel.fromJson(response);
            if (response['success']) {
              //sendingData
              if (response['message'].contains('Verification mail')) {
                print(response);
                loginCallBack.onEmailOTP(response['message'], response['code']);
                print("email otp");
              } else if (response['message'].contains('Verification code')) {
                loginCallBack.onMobileOTP(response['message'],response['code']);
                print("mobile otp");
              }
              // loginCallBack.onDataSuccess(data, false);
            } else {
              loginCallBack.onDataError(response['message']);
            }
          },
          errorsList: (errors) {
            loginCallBack.onErrorList(errors);
          },
          onFailure: (error) {
            loginCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            loginCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  makeForgetPassword(String email) {
    // var url = Constants.BASE_URL + 'auth/password/email?lang=' + Constants.API_LANG;
    var url = Constants.BASE_URL + 'auth/password/email';
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
    ApiCallBack(
        context: context,
        call:
            http.post(Uri.parse(url), body: {'email': email}, headers: headers),
        onResponse: (response) {
          ForgetPasswordModel data = ForgetPasswordModel.fromJson(response);
          print(data.toString());
          if (data.status) {
            forgetPasswordCallBack.onDataSuccess(data.message);
          } else {
            forgetPasswordCallBack.onDataError(data.message);
          }
        },
        onFailure: (error) {
          forgetPasswordCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          forgetPasswordCallBack.onDataLoading(show);
        }).makeRequest();
  }

  makeResetPassword(String code, String email, String password,
      String password_confirmation) {
    // var url = Constants.BASE_URL + 'auth/password/reset?lang=' + Constants.API_LANG;
    var url = Constants.BASE_URL + 'auth/password/reset';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'lang': Constants.LANG
    };
    ApiCallBack(
        context: context,
        call: http.post(Uri.parse(url),
            body: {
              'code': code,
              'email': email,
              'password': password,
              'password_confirmation': password_confirmation
            },
            headers: headers),
        onResponse: (response) {
          ForgetPasswordModel data = ForgetPasswordModel.fromJson(response);
          print(data.toString());
          if (data.status) {
            forgetPasswordCallBack.onDataSuccess(data.message);
          } else {
            forgetPasswordCallBack.onDataError(data.message);
          }
        },
        onFailure: (error) {
          forgetPasswordCallBack.onDataError(error.toString());
        },
        onLoading: (show) {
          forgetPasswordCallBack.onDataLoading(show);
        }).makeRequest();
  }
}

abstract class LoginCallBack {
  void onDataSuccess(LoginModel data, bool isSocial);
  void onSocialDataSuccess(LoginModel data);

  // void onFacebookDataSuccess(String email, String name);

  void onDataLoading(bool show);

  void onDataError(String message);
  void onErrorList(Map<String, dynamic> errors);
  void onEmailOTP(String text, int code);
  void onMobileOTP(String text,int code);
}

abstract class ForgetPasswordCallBack {
  void onDataSuccess(String message);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class LogoutCallBack {
  void onLogoutDataSuccess(String message);

  void onLogoutDataLoading(bool show);

  void onLogoutDataError(String message);
}
