import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/LoginPage/forgetPasswordStepOne.dart';
import 'package:robot/views/LoginPage/freeRegister.dart';
import 'package:robot/views/LoginPage/registerStepOne.dart';
import 'package:robot/views/Part/pageView.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}


String selectedNotificationPayload;

class LoginPage extends StatefulWidget {
  final url;
  final onChangeLanguage;

  LoginPage(this.url, this.onChangeLanguage);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _validate = false;
  bool visible = true;

  var currentLanguage = 'en';
  var site;
  var version;
  var androidLink;
  var iosLink;
  bool gms, hms;
  var refId;
  var otp = '1';
  var mobileNumber;
  String firebaseToken = " ";

  setUpMsg()async{   

  final NotificationAppLaunchDetails notificationAppLaunchDetails = 
   await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('food');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:(int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(id: id, title: title, body: body, payload: payload));
      }
  );
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _showNotification(notice) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, notice['title'], notice['body'], platformChannelSpecifics,
        payload: 'item x');
  }

  lookUp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    print(versionName);
    var contentData = await Request().getWithoutRequest(Config().url + "api/global/lookup", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          site = contentData['data']['system']['SITE_ON'];
          version = contentData['data']['system']['APP_VERSION'];
          androidLink = contentData['data']['system']['ANDROID_DOWNLOAD_LINK'];
          iosLink = contentData['data']['system']['IOS_DOWNLOAD_LINK'];
          if(site == '0'){
            _showPendingInfo();
          }
          if(versionName != version){
            print('123123123');
           checkOSType();
          }
        });
      }
    }
    }
  }

  checkOSType() {
    _showUpdateInfo();
    // if (Platform.isAndroid) {
    //   if (gms = true) {
    //     setState(() {
    //     _showUpdateInfo();
    //     });
    //   } else {
    //     setState(() {
    //       _showUpdateInfo();
    //     });
    //   }
    // } else if (Platform.isIOS) {
    //   setState(() {
    //   _showUpdateInfo();
    //   });
    // }
  }

  Future<void> _showGoogleInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.blue[100],
            title: Center(
              child: Icon(
              Icons.update, 
              color: Colors.white,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Center(
                    child: Text(MyLocalizations.of(context).getData('download_new_version'),style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                 TextButton(onPressed: ()async{
                try {
                  launch("market://details?id=" + 'com.robot.INFINITY');
                } on PlatformException catch(e) {
                    launch("https://play.google.com/store/apps/details?id=" + 'com.robot.INFINITY');        
                } finally {
                  launch("https://play.google.com/store/apps/details?id=" + 'com.robot.INFINITY');        
                }
              }, 
              child: Text(MyLocalizations.of(context).getData('go_google__download'),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

              TextButton(onPressed: ()async{
                var url = androidLink;
                if(await canLaunch(url)){
                  await launch(url);
                }else{

                }
              }, 
              child: Text(MyLocalizations.of(context).getData('go_download'),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showUpdateInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Color(0xff9957ED),
            title: Center(
              child: Icon(
              Icons.update, 
              color: Colors.white,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Center(
                    child: Text(MyLocalizations.of(context).getData('download_new_version'),style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: ()async{
                var url = androidLink;
                if(await canLaunch(url)){
                  await launch(url);
                }else{

                }
              }, 
              child: Text(MyLocalizations.of(context).getData('go_download'),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPendingInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Color(0xff9957ED),
            title: Center(
              child: Icon(
              Icons.access_time, 
              color: Colors.white,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Center(
                    child: Text(MyLocalizations.of(context).getData('maintanence'),style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  postData(dynamic data) async {
    var contentData = await Request().postWithoutToken(Config().url + "api/auth/login", data, context);
    print(contentData);
    if (contentData != null) {
      if (contentData['code'] == 0) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", contentData['data']['token']);

        Timer(
            Duration(seconds: 0),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TopViewing(
                          widget.url,
                          widget.onChangeLanguage,
                        ))));
      
      } else {
       
      }
    }
  }


  initialiseLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'language';

    if (this.mounted) {
      setState(() {
        currentLanguage = prefs.getString(key) ?? " ";
      });
    }


    if (currentLanguage == "") {
      setState(() {
        currentLanguage = "en";
      });
    } else {
      setState(() {
        currentLanguage = "en";
      });
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    initialiseLanguage();
    lookUp();
    setUpMsg();
    _requestPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {});
        print("onMessage: $message");
        _showNotification(message['notification']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {});
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {});
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String deviceToken) {
      assert(deviceToken != null);
      setState(() {
        firebaseToken = deviceToken;
      });
      print('-----');
      print(firebaseToken);
      print('-----');
    });
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
 
      body: new GestureDetector(
         onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          
        },
        child: Stack(
          children: [
            Container(
            child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 0),
              decoration: BoxDecoration(
                color: Color(0xff212630),
              ),
              height: MediaQuery.of(context).size.height,
                child: Container(
                  child: Form(
                      key: _key,
                      autovalidate: _validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Center(
                          //   child: Container(
                          //         width: 130.0,
                          //         height: 130.0,
                          //         decoration: new BoxDecoration(
                          //           image: new DecorationImage(
                          //               fit: BoxFit.cover,
                          //               image: AssetImage("lib/assets/img/sae.png")
                          //           )
                          //       )),
                          // ),
                          Spacer(flex: 3,),
                          Container(
                            child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 30)),
                          ),
                          SizedBox(height: 40.0),
                          _inputUserName(),
                          SizedBox(height: 30.0),
                          _inputPassword(),
                          SizedBox(height: 30.0),
                          GestureDetector(
                            onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetPwdStepOne(
                                      widget.url,
                                      widget.onChangeLanguage)),
                            );
                          },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child:Text( MyLocalizations.of(context).getData('forget_password'),style: TextStyle(color: Color(0xfff9f21a)),),
                            ),
                          ),
                          
                          SizedBox(height: 30.0),
                          Container(
                            child: GestureDetector(
                            onTap: ()async{
                              setState(() {
                                _sendToServer();
                              });
                            }, 
                            child: Center(
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xfffaef1d), Color(0xfff9f21a)])
                                  ),
                                  height: MediaQuery.of(context).size.height / 15,
                                  alignment: Alignment.center,
                                  child: Text(
                                    MyLocalizations.of(context).getData('log_in'),
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                          ),),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(bottom: 25),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 30),
                                    child: GestureDetector(
                                        child: Text(
                                          MyLocalizations.of(context)
                                              .getData('don_have_an_account'),
                                          style: TextStyle(
                                              color: Colors.white70),
                                        )),
                                  ),
                                  Container(
                                    child: GestureDetector(
                                         onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => FreeRegister(widget.url,widget.onChangeLanguage)),
                                          );
                                        },
                                        child: Text(
                                          MyLocalizations.of(context)
                                              .getData('sign_up'),
                                          style: TextStyle(
                                              color: Color(0xfff9f21a)),
                                        )),
                                  )
                                ]),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  _inputUserName() {
    return new Container(
    
      child: TextFormField(
        controller: nameController,
        validator: validateUsername,
        autofocus: false,
        style: TextStyle(color: Colors.white),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_outline,color: Colors.white,),
          isDense: true,
          hintText: MyLocalizations.of(context).getData('username'),
          hintStyle: TextStyle(color: Colors.white70),
          suffixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          enabledBorder: OutlineInputBorder(
             borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
          ),
        ),
        keyboardType: TextInputType.text,
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  _inputPassword() {
    return new Container(
      child: TextFormField(
        controller: passwordController,
        autofocus: false,
        obscureText: visible,
        validator: validatePassword,
        style: TextStyle(color: Colors.white),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock,color: Colors.white,),
          isDense: true,
          hintText: MyLocalizations.of(context).getData('password'),
          hintStyle: TextStyle(color: Colors.white70),
          suffixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          enabledBorder: OutlineInputBorder(
             borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
          ),
        ),
        keyboardType: TextInputType.text,
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  String validateUsername(String value) {
   
    if (value.isEmpty) {
      return 'Username is required';
    } 
    return null;
  }

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.replaceAll(" ", "").isEmpty) {
      return 'Mobile is required';
    } else if (!regExp.hasMatch(value.replaceAll(" ", ""))) {
      return 'Mobile number must be digits';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } 
    return null;
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['username'] = nameController.text;
          tmap['password'] = passwordController.text;
        });
        print(tmap['username']);
        print(tmap['password']);
        postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
