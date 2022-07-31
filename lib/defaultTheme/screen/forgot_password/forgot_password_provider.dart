import 'dart:convert';

import 'package:http/http.dart' as http;

class ForgotPasswordProvider {
  final ForgotPasswordCallback forgotPasswordCallback;

  ForgotPasswordProvider({this.forgotPasswordCallback});

  Future<void> doForgotPassword(Map<String, dynamic> body) async {
    await http
        .post(
            Uri.parse("https://mymedicalshope.com/api/v1/auth/password/create"),
            body: body)
        .then((value) {
      final resp = jsonDecode(utf8.decode(value.bodyBytes));
      if (resp['success']) {
        forgotPasswordCallback.onForgotPasswordSuccess(resp['message'],
            resp['email'], resp['phone'], resp['code'].toString());
      } else {
        forgotPasswordCallback.onForgotPasswordError(resp['message']);
      }
    });
  }

  Future<void> doResetPassword(Map<String, dynamic> body) async {
    await http
        .post(
            Uri.parse("https://mymedicalshope.com/api/v1/auth/password/reset"),
            body: body)
        .then((value) {
      final resp = jsonDecode(utf8.decode(value.bodyBytes));
      if (resp['success']) {
        forgotPasswordCallback.onResetPasswordSuccess();
      } else {
        forgotPasswordCallback.onResetPasswordError();
      }
    });
  }
}

abstract class ForgotPasswordCallback {
  void onForgotPasswordSuccess(
      String message, String email, String phone, String code);

  void onForgotPasswordError(String message);

  void onResetPasswordSuccess();

  void onResetPasswordError();
}
