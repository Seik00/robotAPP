import 'dart:async';

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:robot/views/LoginPage/loginPage.dart';
import 'package:robot/views/SystemSetting/setSecPassword.dart';
import 'package:robot/views/SystemSetting/settings.dart';
import 'package:robot/views/clientSide/circle.dart';
import 'package:robot/views/clientSide/market.dart';
import 'package:robot/views/clientSide/myAssest.dart';
import 'package:robot/views/clientSide/quantity.dart';
import 'package:robot/views/clientSide/share.dart';
import 'package:robot/views/clientSide/upload.dart';
import 'package:robot/views/clientSide/services.dart';
import 'package:robot/views/videoPlayer.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:platform_device_id/platform_device_id.dart';

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
  String _deviceId;

  @override
  void initState() {
    super.initState();
    getRequest();
    initPlatformState();
    lookUp();
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
      print("deviceId->$_deviceId");
    });
  }

   lookUp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    print(versionName);
    var contentData = await Request().getRequest(Config().url + "/api/project/lookup", context);
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
          if(versionName != version){
            print('hererererererereree');
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
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          secPwd = contentData['data']['password2'];
          active = contentData['data']['active'];
          
        });
      }
      checkIsLogin();
    }
    }
   
  }

  checkIsLogin() async{
    if(secPwd == null || secPwd == ""){
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SetSecPassword(widget.url,widget.onChangeLanguage)),
      // );
       setState(() {
        Timer(
          Duration(seconds: 1),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TopViewing(
                      widget.url, widget.onChangeLanguage))));
      });
    }else if(active == 0){
      print(active);
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
        //Market(widget.url, widget.onChangeLanguage),
        MyAssests(widget.url,widget.onChangeLanguage),
        Settings(widget.url, widget.onChangeLanguage),
      ];

    setIcon(){
        return [
          TabItem(icon: Icons.home,title:MyLocalizations.of(context).getData('home')),
          TabItem(icon: Icons.compare_arrows,title: MyLocalizations.of(context).getData('quantitative')),
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
