import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Request {
  Map<String, String> headers = {};

  postWithoutToken(url, bodyData, context) async {

    try { 
        
      http.Response response = await http.post(url, body: bodyData, headers: headers).timeout(new Duration(seconds: 10));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var contentData = json.decode(response.body); 
        if(contentData['message'] =='Incorrect_otp'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_otp'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_OTP'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_otp'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_EMAIL_FORMAT'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_email'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_USERNAME'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_username'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='MEMBER_EXITS'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('member_exist'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='USER_NO_MOBILE'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('user_no_mobile'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='LOGIN_FAIL'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('login_fail'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_SPONSOR'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_sponsor'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        return contentData;
        
      }else if(response.statusCode == 401){
        
        Fluttertoast.showToast(
          msg: 'Welcome',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFDCDCDC),
          textColor: Colors.black,
        );
        return null;
      }else if (response.statusCode == 500) {
        Fluttertoast.showToast(
          msg: MyLocalizations.of(context).getData('internalError'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFDCDCDC),
          textColor: Colors.black,
        );
        return null;

      }
      else{
        return null;
      }
    } on TimeoutException catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: MyLocalizations.of(context).getData('loadingTimeOut'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFDCDCDC),
        textColor: Colors.black,
      );
      return null;
      
    } on SocketException catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: MyLocalizations.of(context).getData('loadingTimeOut'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFDCDCDC),
        textColor: Colors.black,
      );
      return null;

    }
    
  }
  
  postRequest(url, bodyData, token, context) async {
    headers = {'Authorization': 'Bearer' + token};

    try { 

      http.Response response = await http.post(url, body: bodyData, headers: headers).timeout(new Duration(seconds: 10));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var contentData = json.decode(response.body);  
        if(contentData['message'] =='INCORRECT_SEC_PASSWORD'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('sec_pwd_wrong'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_OTP'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_otp'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='ACCOUNT_ACTIVATED'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('account_activated'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='INCORRECT_EMAIL_FORMAT'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_email_format'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='MIN_WITHDRAW_AMOUNT'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('withdraw_minimum_10'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='NOT_ENUF_GAS'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('not_enough_point_2'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='NO_PIN'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('no_pin'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='ROBOT_EXIST'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('robot_exist'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='ROBOT_NOT_ACTIVE'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('robot_not_active'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='NO_BIND_API'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('no_bind_api'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='INCORRECT_API'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_api'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='USER_QUIT'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('user_quit'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='NO_PACKAGE'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('package_not_active'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }else if(contentData['message'] =='PACKAGE_NOTACTIVE'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('package_not_active'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='MAXIMUN_SHARE_TIMES'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('share_time_max'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='MUST_Integer'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('must_integer'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_PASSWORD'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('pwd_wrong'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='MEMBER_EXITS'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('member_exist'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_SPONSOR'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_sponsor'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='PLACEMENT_GOT_USER'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('placement_got_user'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='PLACEMENT_USER_ERROR'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('placement_user_error'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_PACKAGE'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_package'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INSUFFICIAN_BALANCE'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('insuffician_balance'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='REQUEST_FAIL'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('request_failed'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_USERNAME'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_username'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_ACTION'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_action'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='INCORRECT_BANK'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_bank'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='NO_PERMISSION'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('no_permission'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='WITHDRAW_BETWEEN100_5000'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('withdraw_between100_5000'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='LAST_WITHDRAWAL_PENDING'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('last_withdrwal_pending'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='Incorrect_otp'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('incorrect_otp'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        else if(contentData['message'] =='USER_NO_MOBILE'){
          AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: MyLocalizations.of(context).getData('error'),
          desc: MyLocalizations.of(context).getData('user_no_mobile'),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
        }
        
        return contentData;

      }else if (response.statusCode == 500) {
        Fluttertoast.showToast(
          msg: MyLocalizations.of(context).getData('internalError'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFDCDCDC),
          textColor: Colors.black,
        );
        return null;

      }else if(response.statusCode == 401){
        Fluttertoast.showToast(
          msg: MyLocalizations.of(context).getData('unauthorized'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFDCDCDC),
          textColor: Colors.black,
        );
        return null;

      }else{
        return null;
      }
    } on TimeoutException catch (e) {
      print(e.toString());
      return null;
      
    } on SocketException catch (e) {
      print(e.toString());
      return null;

    }
    
  }

  getRequest(url, context) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if(token!=null){
      headers = {'Authorization': 'Bearer' + token};

    }

    try { 

      http.Response response = await http.get(url, headers: headers).timeout(new Duration(seconds: 10));
      
      print(response.statusCode);    

      if (response.statusCode == 200) {
        var contentData = json.decode(response.body); 
        return contentData;
        

      }else if (response.statusCode == 500) {
        Fluttertoast.showToast(
          msg: MyLocalizations.of(context).getData('internalError'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFDCDCDC),
          textColor: Colors.black,
        );
        return null;

      }else if(response.statusCode == 401){
        Fluttertoast.showToast(
          msg: MyLocalizations.of(context).getData('unauthorized'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFDCDCDC),
          textColor: Colors.black,
        );
        return null;

      }else{
        return null;
      }
    } on TimeoutException catch (e) {
      print(e.toString());
      return null;
      
    } on SocketException catch (e) {
      print(e.toString());
      return null;

    }catch (exception) {
      Fluttertoast.showToast(
        msg: MyLocalizations.of(context).getData('internalError'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFDCDCDC),
        textColor: Colors.black,
      );
      return null;
    }
    
  }

  getWithoutRequest(url, context) async {

    try { 

      http.Response response = await http.get(url, headers: headers).timeout(new Duration(seconds: 10));
      
      print(response.statusCode);    

      if (response.statusCode == 200) {
        var contentData = json.decode(response.body); 
        return contentData;
        

      }else if (response.statusCode == 500) {
        Fluttertoast.showToast(
          msg: MyLocalizations.of(context).getData('internalError'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFDCDCDC),
          textColor: Colors.black,
        );
        return null;

      }else if(response.statusCode == 401){
        Fluttertoast.showToast(
          msg: MyLocalizations.of(context).getData('unauthorized'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFDCDCDC),
          textColor: Colors.black,
        );
        return null;

      }else{
        return null;
      }
    } on TimeoutException catch (e) {
      print(e.toString());
      return null;
      
    } on SocketException catch (e) {
      print(e.toString());
      return null;

    }catch (exception) {
      Fluttertoast.showToast(
        msg: MyLocalizations.of(context).getData('internalError'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFDCDCDC),
        textColor: Colors.black,
      );
      return null;
    }
    
  }
  
}