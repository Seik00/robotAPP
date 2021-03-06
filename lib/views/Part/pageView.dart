import 'dart:async';

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:robot/views/LoginPage/loginPage.dart';
import 'package:robot/views/SystemSetting/chgUsername.dart';
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

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 12, color: color,fontWeight: FontWeight.normal);
  }
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
    checkUsername();
    getLanguage();
    checkStoppedRobot();
    _firebaseMessaging.getToken().then((String deviceToken) {
      assert(deviceToken != null);
      setState(() {
        firebaseToken = deviceToken;
      });
    });
  }

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    if(language == 'zh'){
      language = 'cn';
    }
    _sendToServer();
  }

   checkUsername() async {
    var contentData = await Request().getRequest(Config().url + "api/member/detectUsername", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
        
      }else{
        if (mounted) {
            setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChgUsername(widget.url, widget.onChangeLanguage)),
            );
            });
          }
      }
     
    }
  }
  
  checkStoppedRobot() async {
    var contentData = await Request().getRequest(Config().url + "api/trade-robot/stoped-robot", context);
    print(contentData);
    print('----=======-----');
    if(contentData != null){
      if (contentData['code'] == 0) {
        if(contentData['data'].length>0){
           _showStopedInfo();
        }else{
           
        }
      }
    }
  }

  Future<void> _showStopedInfo() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            backgroundColor: Color(0xfffFDE323),
            title: Center(
              child: Icon(
              Icons.stop_screen_share_outlined, 
              color: Colors.black,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Center(
                    child: Text(MyLocalizations.of(context).getData('detect_robot_stopped'),style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

   _sendToServer() {
    var tmap = new Map<String, dynamic>();
    if (mounted)
      setState(() {
        tmap['language'] =language;
      });
      postLanguage(tmap);
  }

  postLanguage(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/member/setLanguage", bodyData, token, context);

    print(contentData);
    if (contentData != null) {
      if (contentData['code'] == 0) {
       
    } else {
     
    }
    }
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
          if(Config().version != version){
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
        MyAssests(widget.url,widget.onChangeLanguage),
        Settings(widget.url, widget.onChangeLanguage),
      ];

    setIcon(){
        return [
          TabItem(icon: Icons.home,title:MyLocalizations.of(context).getData('home')),
          TabItem(icon: Icons.compare_arrows,title: MyLocalizations.of(context).getData('quantitative')),
          TabItem(icon: Icons.construction_rounded,title: MyLocalizations.of(context).getData('derivatives')),
          TabItem(icon: Icons.monetization_on,title:MyLocalizations.of(context).getData('my_assets')),
          TabItem(icon: Icons.person,title:MyLocalizations.of(context).getData('me')),
        ];
    }

    return Scaffold(
      // resizeToAvoidBottomPadding: true,
      body: _pageOptions[_selectedPage],
      bottomNavigationBar:StyleProvider(
        style: Style(),
        child:  ConvexAppBar(
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
      )
    );
  }
}
