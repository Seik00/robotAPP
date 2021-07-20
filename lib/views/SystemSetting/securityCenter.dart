import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/SystemSetting/changePwd.dart';
import 'package:robot/views/SystemSetting/changeSecurityPwd.dart';
import 'package:robot/views/SystemSetting/countryChanges.dart';
import 'package:robot/views/SystemSetting/userBank.dart';
import 'package:robot/views/otpPage.dart/changePasswordOtp.dart';
import 'package:robot/views/otpPage.dart/changeSecPasswordOtp.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityCenter extends StatefulWidget {
  final url;
  final onChangeLanguage;

  SecurityCenter(this.url, this.onChangeLanguage);

  @override
  _SecurityCenterState createState() => _SecurityCenterState();
}

class _SecurityCenterState extends State<SecurityCenter>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  var currentLanguage;
  String versionName;
  var language;
  
  @override
  void initState() {
    super.initState();
    package();
    getLanguage();
  }

  package() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {      
      versionName = packageInfo.version;
      print(versionName);
    });
    
  }
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    print(language);
    if(language == 'zh'){
      language = 'cn';
    }
    _sendToServer();
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
    
  }

  Future<void> _showLanguages() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color(0xfffFDE323),
            title: Text(MyLocalizations.of(context).getData('languageSetting'),style: TextStyle(color: Colors.black)),
            content: Wrap(
              direction: Axis.vertical,
              spacing: 15,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      widget.onChangeLanguage("zh");
                      currentLanguage = "zh";
                      print(currentLanguage);
                      Navigator.pop(context);
                    },
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(right:10),
                        width: 30.0,
                        height: 30.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("lib/assets/img/cn_flag.png")
                          )
                      )),
                      Text(MyLocalizations.of(context).getData('zh'),style: TextStyle(color: Colors.black),)
                    ],)
                   ),
                GestureDetector(
                    onTap: () {
                      widget.onChangeLanguage("en");
                      currentLanguage = "en";
                       print(currentLanguage);
                      Navigator.pop(context);
                    },
                    child: Row(children:[
                      Container(
                        margin: EdgeInsets.only(right:10),
                        width: 30.0,
                        height: 30.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("lib/assets/img/uk_flag.png")
                          )
                      )),
                      Text(MyLocalizations.of(context).getData('en'),style: TextStyle(color: Colors.black))
                    ]),
                   ),
                 GestureDetector(
                    onTap: () {
                      widget.onChangeLanguage("vi");
                      currentLanguage = "vi";
                       print(currentLanguage);
                      Navigator.pop(context);
                    },
                    child: Row(children:[
                      Container(
                        margin: EdgeInsets.only(right:10),
                        width: 30.0,
                        height: 30.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("lib/assets/img/vietnam_flag.png")
                          )
                      )),
                      Text(MyLocalizations.of(context).getData('vn'),style: TextStyle(color: Colors.black))
                    ]),
                   ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212630),
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // color: Theme.of(context).backgroundColor,
                  
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context, true)),
                            Text('v '+versionName.toString(),style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Center(
                          child: Container(
                            child: Text(
                              MyLocalizations.of(context).getData('security_center'),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            _showLanguages();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  margin: EdgeInsets.only(right: 20),
                                  padding: EdgeInsets.all(10),
                                  child: Image(
                                    image: AssetImage(
                                        "lib/assets/img/me_team.png"),
                                    height: 30,
                                    width: 40,
                                  )
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          MyLocalizations.of(context)
                                              .getData('language'),
                                          style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                          child: (Icon(
                                              Icons.chevron_right_outlined,color: Colors.white,))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey[400],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePasswordOtp(widget.url)),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  margin: EdgeInsets.only(right: 20),
                                  padding: EdgeInsets.all(10),
                                  child: Image(
                                    image: AssetImage(
                                        "lib/assets/img/me_team.png"),
                                    height: 30,
                                    width: 40,
                                  )
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          MyLocalizations.of(context)
                                              .getData('change_login_pwd'),
                                          style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                          child: (Icon(
                                              Icons.chevron_right_outlined,color: Colors.white,))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey[400],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangeSecPasswordOtp(widget.url)),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  margin: EdgeInsets.only(right: 20),
                                  padding: EdgeInsets.all(10),
                                  child: Image(
                                    image: AssetImage(
                                        "lib/assets/img/me_team.png"),
                                    height: 30,
                                    width: 40,
                                  )
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          MyLocalizations.of(context)
                                              .getData('change_security_pwd'),
                                          style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                          child: (Icon(
                                              Icons.chevron_right_outlined,color: Colors.white,))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                     
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
