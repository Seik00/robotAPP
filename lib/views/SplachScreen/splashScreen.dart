import 'dart:async';
import 'dart:convert';

import 'package:robot/views/LoginPage/loginPage.dart';
import 'package:robot/views/Part/pageView.dart';
import 'package:flutter/material.dart';
import 'package:robot/views/SystemSetting/setSecPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:package_info/package_info.dart';


class SplashScreen extends StatefulWidget {
  final url;
  final onChangeLanguage;

  SplashScreen(this.url, this.onChangeLanguage);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = " ";
  String secPwd = "";
  var site;
  var version;

  @override
  void initState() {
    super.initState();
    validateLogin();
    lookUp();
  }

   lookUp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    print(versionName);
    var contentData = await Request().getWithoutRequest(Config().url + "api/global/lookup", context);
    print(contentData);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          site = contentData['data']['system']['SITE_ON'];
          version = contentData['data']['system']['APP_VERSION'];
          if(site == '0'){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginPage(widget.url, widget.onChangeLanguage)),
            );
          }
          if(Config().version != version){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginPage(widget.url, widget.onChangeLanguage)),
            );
          }
        });
      }
    }
    }
    
  }

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    
    if(contentData == 401){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage(widget.url, widget.onChangeLanguage)),
      );
      return null;
    }
    if(contentData != null){
      if (mounted) {
        setState(() {
          secPwd = contentData['password2'];
         
        });
      }
    checkIsLogin();
    }else{
        // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SetSecPassword(widget.url,widget.onChangeLanguage)),
      // );
    }
  }

   checkIsLogin() async{
    if(secPwd == null || secPwd == ""){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetSecPassword(widget.url,widget.onChangeLanguage)),
      );
      // setState(() {
      //   Timer(
      //     Duration(seconds: 1),
      //     () => Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => TopViewing(
      //                 widget.url, widget.onChangeLanguage))));
      // });
    }else{
      setState(() {
        Timer(
          Duration(seconds: 1),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TopViewing(
                      widget.url, widget.onChangeLanguage))));
      });
    }
  }

  validateLogin() async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token") ?? "";
    print(token);
    if (token == "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage(widget.url, widget.onChangeLanguage)),
      );
    } else {
      print(token);
      getRequest();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
