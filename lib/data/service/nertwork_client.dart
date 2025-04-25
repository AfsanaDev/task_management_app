
import 'dart:convert';

import 'package:api_class/ui/controllers/auth_controller.dart';
import 'package:api_class/ui/screens/login_screen.dart';
import 'package:api_class/app.dart';
import 'package:api_class/data/models/password_verify_email_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class NetworkResponse{
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String errorMessage;

  NetworkResponse({
    required this.isSuccess,
     required this.statusCode,  
     this.data, 
   this.errorMessage = 'Something went wrong' });

}
class NetworkClient{
  static final Logger _logger = Logger();
  static Future<NetworkResponse> getRequest({required String url})async{
  try{
      Uri uri = Uri.parse(url);
     Map<String, String> headers = {
      'token': AuthController.token ?? '',
    } ;
      _preRequestLog(url, headers);
    Response response = await get(uri, headers: headers);
    _postRequestLog(
      url, response.statusCode, responseBody: response.body, 
      header: response.headers);

    if(response.statusCode ==200){
      final decodedJson = jsonDecode(response.body);
      return NetworkResponse(isSuccess: true, statusCode: response.statusCode, data: decodedJson);
    }else if(response.statusCode == 401){
      _moveToLoginScreen();
      return NetworkResponse(isSuccess: false, statusCode: response.statusCode,errorMessage: 'Unauthorized user please login again');
    }
    else{
      final decodedJson = jsonDecode(response.body);
      String errorMessage = decodedJson['data'] ?? 'Something went wrong';
      return NetworkResponse(isSuccess: false, statusCode: response.statusCode, errorMessage: errorMessage);
    }
  }catch(e){
    _postRequestLog(url, -1 , errorMessage: e.toString() );
    return NetworkResponse(isSuccess: false, statusCode:-1,errorMessage: e.toString());
  }
  }


  //PostRequest 

   static Future<NetworkResponse> postRequest({required String url, Map<String, dynamic> ?body})async{
  try{
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
      'Content-type': 'application/json',
      'token': AuthController.token ?? '',
    } ;
      _preRequestLog(url,headers, body: body);
    Response response = await post(uri,
    headers:headers, 
    body: jsonEncode(body),
    );
    _postRequestLog(url, response.statusCode,
    header: response.headers,
    responseBody: response.body
    );

    if(response.statusCode ==200){
    
      final decodedJson = jsonDecode(response.body);
      return NetworkResponse(isSuccess: true, statusCode: response.statusCode, data: decodedJson);
    }else if(response.statusCode == 401){
      _moveToLoginScreen();
      return NetworkResponse(isSuccess: false, statusCode: response.statusCode,errorMessage: 'Unauthorized user please login again');
    }
    else{
      final decodedJson = jsonDecode(response.body);
      String errorMessage = decodedJson['data'] ?? 'Something went wrong';
      return NetworkResponse(isSuccess: false, statusCode: response.statusCode, errorMessage: errorMessage);
    }
  }catch(e){
    _logger.e(e.toString());
    return NetworkResponse(isSuccess: false, statusCode:-1,errorMessage: e.toString());
  }
  }
  static void _preRequestLog(String url, Map<String, String> headers,
      {Map<String, dynamic>? body}) {
    _logger.i('URL => $url\nHeaders: $headers\n'
        'Body: $body');
  }

  static void _postRequestLog(String url,int statusCode,{ Map<String, dynamic> ?header, 
   dynamic responseBody, dynamic errorMessage} ){
    if(errorMessage!= null){
       _logger.e(
      'Url => $url'
    'Error Message => $errorMessage'
    'Status Code => $statusCode'
    'Header => $header'
    );
    }else{
      _logger.i(
      'Url => $url'
    'Response => $responseBody'
    'Status Code => $statusCode'
    'Header => $header'
    );
    }
    
  }

  static Future <void> _moveToLoginScreen()async{
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(
      TaskManagerApp.navigatorKey.currentContext!, 
      MaterialPageRoute(builder: (context)=> LoginScreen()), (predicate)=>false);
  }
}