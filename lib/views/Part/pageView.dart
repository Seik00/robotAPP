import 'dart:async';

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:robot/views/LoginPage/loginPage.dart';
import 'package:robot/views/SystemSetting/setSecPassword.dart';
import 'package:robot/views/SystemSetting/settings.dart';
import 'package:robot/views/clientSide/myAssest.dart';
import 'package:robot/views/clientSide/product.dart';
import 'package:robot/views/clientSide/quantity.dart';
import 'package:robot/views/clientSide/services.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:io' show Platform;

class TopViewing extends StatefulWidget {
  final url;
  final onChangeLanguage;

  TopViewing(this.url,this.onChangeLanguage);

  @override
  _TopViewingState createState() => _TopViewingState();
}

class _TopViewingState extends State<TopViewing>
    with SingleTickerProviderStateMixin {
  var _selectedPage = 0;
  String secPwd = "";
  var active;
  var site;
  var version;
  var annouceNumber;
  final keyIsFirstLoaded = 'is_first_loaded';

  var currentLanguage;
  var username;
  var pointOne;
  var packageIcon;
  var  total_asset;
  var  total_income;
  var total_income_today;
  var totalCurrency;
  var type;
  var notice;
  var language;
  var title;
  var description;
  var createdAt;
  var publicPath;
  var annouceNumber2;
  var check = true;
  String firebaseToken = " ";
  var osType;
  String _deviceId = 'Unknown';
  bool gms, hms;

   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    getRequest();
    lookUp();
    _firebaseMessaging.getToken().then((String deviceToken) {
      assert(deviceToken != null);
      setState(() {
        firebaseToken = deviceToken;
      });
    });
  }


   lookUp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    var contentData = await Request().getWithoutRequest(Config().url + "api/global/lookup", context);
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
          if(versionName != version){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginPage(widget.url, widget.onChangeLanguage)),
            );
          }
        });
         checkPhoneType();
      }
    }
    }
  }

  checkPhoneType() {
    if (Platform.isAndroid) {
      if (gms = true) {
        setState(() {
        osType = "ANDROID";
        });
      } else {
        setState(() {
          osType = "HUAWEI";
        });
      }
    } else if (Platform.isIOS) {
      setState(() {
        osType = "IOS";
      });
    }
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
    
    sendToken();
  }

  sendToken(){
    var tmap = new Map<String, dynamic>();
    setState(() {
      tmap['device_token'] = firebaseToken;
      tmap['device_id'] = _deviceId;
      tmap['device_type'] = osType;
    });
  
    postDeviceToken(tmap);
  }

  postDeviceToken(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    
    var contentData = await Request().postRequest(Config().url+"api/global/add_user_device_token", bodyData, token, context);
    print(contentData);
  }

   getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          secPwd = contentData['password2'];
          active = contentData['active'];
          
        });
      }
      checkIsLogin();
    }
   
  }

  checkIsLogin() async{
    if(secPwd == null || secPwd == ""){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetSecPassword(widget.url,widget.onChangeLanguage)),
      );
      //  setState(() {
      //   Timer(
      //     Duration(seconds: 1),
      //     () => Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => TopViewing(
      //                 widget.url, widget.onChangeLanguage))));
      // });
    }else if(active == 0){
      print('--------------------------------------');
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(widget.url,widget.onChangeLanguage)),
      );
    }else{
      
    }
  }

  @override
  Widget build(BuildContext context) {
    List _pageOptions = [];
      _pageOptions = [
        Services(widget.url, widget.onChangeLanguage),
        Quantity(widget.url, widget.onChangeLanguage),
        Product(widget.url, widget.onChangeLanguage),
        //Market(widget.url, widget.onChangeLanguage),
        MyAssests(widget.url,widget.onChangeLanguage),
        Settings(widget.url, widget.onChangeLanguage),
      ];

    setIcon(){
        return [
          TabItem(icon: Icons.home,title:MyLocalizations.of(context).getData('home')),
          TabItem(icon: Icons.compare_arrows,title: MyLocalizations.of(context).getData('quantitative')),
          TabItem(icon: Icons.construction_rounded,title: MyLocalizations.of(context).getData('derivatives')),
          //TabItem(icon: Icons.language,title:'Market'),
          TabItem(icon: Icons.monetization_on,title:MyLocalizations.of(context).getData('my_assets')),
          TabItem(icon: Icons.person,title:MyLocalizations.of(context).getData('me')),
        ];
    }

    return Scaffold(
      // resizeToAvoidBottomPadding: true,
      body: _pageOptions[_selectedPage],
      bottomNavigationBar:ConvexAppBar(
        backgroundColor: Color(0xff474c56),
        activeColor: Color(0xfffbf615),
        color: Colors.white,
        style: TabStyle.react,
        items: setIcon(),
        initialActiveIndex: 0 /*optional*/,
        onTap: (int i) {
          setState(() {
            _selectedPage = i;
          });
        } 
      ),
    );
  }
}
