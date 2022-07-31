import 'dart:convert';

// import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/utils/errorCodes.dart';

class ApiCallBack {
  ApiCallBack(
      {this.context,
      this.call,
      this.onResponse,
      this.errorsList,
      this.onFailure,
      this.onLoading});

  final BuildContext context;

  // final Future<Response> call;
  var call;
  final OnResponse onResponse;
  final OnFailure onFailure;
  final ErrorsList errorsList;
  final OnLoading onLoading;

  static int noInternetCounter = 0;

  makeRequest() async {
    onLoading(true);
    print("Call: " + call.toString());

    var res = await call;
    print(res.body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      var jsonResponse = convert.jsonDecode(res.body);
      onLoading(false);
      onResponse(jsonResponse);

      /*ResponseModel data = ResponseModel.fromJson(jsonResponse);
        // print(data.toString());

        if (data.code == ErrorCodes.UNACTIVATED_CODE) {
          onLoading(false);
          Navigator.of(context).pushNamed('/Activation');
        } else if (data.code == ErrorCodes.INVALID_TOKEN_CODE) {
          onLoading(false);
          Navigator.of(context).pushNamed('/Login', arguments: true);
        } else if (data.code == ErrorCodes.INVALID_TOKEN_CODE_2) {
          onLoading(false);
          Navigator.of(context).pushNamed('/Login', arguments: true);
        } else {
          onResponse(jsonResponse);
          onLoading(false);
        }*/
    } else if (res.statusCode == 401) {
      onLoading(false);
      print("Error Unauthorized");
      /*   showDialog(
            context: context,
            builder: (BuildContext context) => UnauthorizedErrorDialog(
                  context: context,
                ));*/

      // Navigator.of(context).pushNamed('/SignIn');
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return T3SignIn();
      }));
    } else {
      onLoading(false);
      var realResp = json.decode(res.body);
      if (realResp['errors'] == null) {
        onFailure(realResp['message']);
      } else {
        errorsList(realResp['errors']);
      }
    }

    /*else if (connectivityResult == ConnectivityResult.mobile) {
    showDialog(
        context: context,
        builder: (BuildContext context) => InfoDialog(
          context: context,
          title: "via mobile data",
        ));
  } else if (connectivityResult == ConnectivityResult.wifi) {
    showDialog(
        context: context,
        builder: (BuildContext context) => InfoDialog(
          context: context,
          title: "via mobile wifi",
        ));
    // I am connected to a wifi network.
  }*/
  }

  makeMultiPartRequest() async {
    onLoading(true);
    print("Call: " + call.toString());

    var res = await call;

    try {
      final streamedResponse = await res.send();
      final response = await http.Response.fromStream(streamedResponse);
      /*if (response.statusCode != 200) {
          return null;
        }
        final Map<String, dynamic> responseData = json.decode(response.body);
        _resetState();
        return responseData;*/

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        onLoading(false);
        onResponse(jsonResponse);

        /* ResponseModel data = ResponseModel.fromJson(jsonResponse);
          // print(data.toString());

          if (data.code == ErrorCodes.UNACTIVATED_CODE) {
            onLoading(false);
            Navigator.of(context).pushNamed('/Activation');
          } else if (data.code == ErrorCodes.INVALID_TOKEN_CODE) {
            onLoading(false);
            Navigator.of(context).pushNamed('/Login', arguments: true);
          } else if (data.code == ErrorCodes.INVALID_TOKEN_CODE_2) {
            onLoading(false);
            Navigator.of(context).pushNamed('/Login', arguments: true);
          } else {
            onResponse(jsonResponse);
            onLoading(false);
          }*/
      } else if (res.statusCode == 401) {
        onLoading(false);
        print("Error Unauthorized");

        Navigator.of(context).pushNamed('/SignIn');
      } else {
        onLoading(false);
        var realResp = json.decode(response.body);
        onFailure(realResp['message']);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

typedef OnResponse = void Function(dynamic response);

typedef OnFailure = void Function(String error);
typedef ErrorsList = void Function(Map<String, dynamic> errors);

typedef OnLoading = void Function(bool show);

class ResponseModel {
  ResponseModel({
    this.status,
    this.code,
    this.message,
  });

  bool status;
  String code;
  String message;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        status: json["status"],
        code: json["code"].toString(),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
      };
}
