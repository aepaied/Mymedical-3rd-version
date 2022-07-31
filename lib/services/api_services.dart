import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_medical_app/utils/constants.dart';

class ApiServices{

  Future getTopSellers()async{
    String theUrl = Constants.BASE_URL + "products/best-seller";
    Client client = Client();
    try{
      return await client.get(Uri.parse(theUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      }).then((response) async {
        Map<String, dynamic> responseData = await jsonDecode(response.body);
        return responseData;
      });
    }catch(e){
      print(e);
    }finally{
      client.close();
    }
  }
  Future getFeatured()async{
    String theUrl = Constants.BASE_URL + "products/featured";
    Client client = Client();
    try{
      return await client.get(Uri.parse(theUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      }).then((response) async {
        Map<String, dynamic> responseData = await jsonDecode(response.body);
        return responseData;
      });
    }catch(e){
      print(e);
    }finally{
      client.close();
    }
  }
  Future getWalkTrough()async{
    String theUrl = Constants.BASE_URL + "appStartPages/";
    Client client = Client();
    try{
      return await client.get(Uri.parse(theUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      }).then((response) async {
        print(response.body);
        Map<String, dynamic> responseData = await jsonDecode(response.body);
        return responseData;
      });
    }catch(e){
      print(e);
    }finally{
      client.close();
    }
  }
  Future getProductDetails(String theID) async {
    String theUrl ="${Constants.BASE_URL}products/related/$theID?page=1";
    Client client = Client();
    try{
      return await client.get(Uri.parse(theUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      }).then((response) async {
        Map<String, dynamic> responseData = await jsonDecode(response.body);
        return responseData['data'];
      });
    }catch(e){
      print(e);
    }finally{
      client.close();
    }

  }
  Future getProductReviews(String theURL) async {
    Client client = Client();
    print(theURL);
    try{
      return await client.get(Uri.parse(theURL), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      }).then((response) async {
        print(response.body);
        Map<String, dynamic> responseData = await jsonDecode(response.body);
        return responseData['data'];
      });
    }catch(e){
      print(e);
    }finally{
      client.close();
    }

  }
}