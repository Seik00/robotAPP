import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/LoginPage/loginPage.dart';
import 'package:robot/views/LoginPage/registerStepOne.dart';
import 'package:robot/views/SystemSetting/BonusCenter.dart';
import 'package:robot/views/SystemSetting/allTransactionRecord.dart';
import 'package:robot/views/SystemSetting/customerService.dart';
import 'package:robot/views/SystemSetting/invitation.dart';
import 'package:robot/views/SystemSetting/myTeam.dart';
import 'package:robot/views/SystemSetting/securityCenter.dart';
import 'package:robot/views/SystemSetting/serviceCenter.dart';
import 'package:robot/views/SystemSetting/teamRevenue.dart';
import 'package:robot/views/Trade/tradeLog.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';

class Settings extends StatefulWidget {
  final url;
  final onChangeLanguage;
 

  Settings(this.url, this.onChangeLanguage);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();
  var type;
  var currentLanguage;
  var username;
  var id;
  var packageName;
  var packageNameEn;
  var language;
  var package;
  var robotList =[];
  var expiredDate;
  var pin;

   getLanguage() async{
      final prefs = await SharedPreferences.getInstance();
      language = prefs.getString('language');
      print(language);
    }


   getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          print(contentData);
          username = contentData['username'];
          pin = contentData['pin'];
          expiredDate = contentData['expired_date'];
          id = contentData['id'];
          packageName = contentData['package']['package_name'];
          packageNameEn = contentData['package']['package_name_en'];
        });
      }
    }
  }

  getRobotList() async {
    var contentData = await Request().getRequest(Config().url + "api/trade-robot/robotList", context);
    print(contentData);
    if(contentData != null){
      if (contentData['code'] == 0) {
          setState(() {
             robotList = contentData['data'];
            print(robotList);
          });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getRequest();
    getLanguage();
    getRobotList();
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
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
                children: [
                    Container(
                        // color: Theme.of(context).backgroundColor,
                        child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: new BoxDecoration(
                                  color: Color(0xff595c64),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height:20),
                                    Image(
                                      image: AssetImage(
                                          "lib/assets/img/inv_logo.png"),
                                      height: 60,
                                      width: 60,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      child: Text(id==null?'':'ID: '+id.toString(),style: TextStyle(color:Colors.white)),
                                    ),
                                    Container(
                                      child: Text(username==null?'':username,style: TextStyle(color:Colors.white),),
                                    ),
                                    if(pin == 0)
                                    Container(
                                      child: Text(expiredDate==null?'': MyLocalizations.of(context).getData('robot_date')+': ' + MyLocalizations.of(context).getData('not_active') ,style: TextStyle(color:Color(0xffa2c6ff)),),
                                    ),
                                    if(pin == 1)
                                    Container(
                                      child: Text(expiredDate==null?'': MyLocalizations.of(context).getData('robot_date')+': ' +expiredDate,style: TextStyle(color:Color(0xffa2c6ff)),),
                                    ),
                                    if(pin == 2)
                                    Container(
                                      child: Text(expiredDate==null?'': MyLocalizations.of(context).getData('robot_date')+': ' +MyLocalizations.of(context).getData('permanent'),style: TextStyle(color:Color(0xffa2c6ff)),),
                                    ),
                                    Container(
                                      child: 
                                      language == 'zh'?
                                      Text(packageName == null?'':packageName,style: TextStyle(color:Color(0xfff9f21a),fontSize: 18)):
                                      Text(packageNameEn == null?'':packageNameEn,style: TextStyle(color:Color(0xfff9f21a),fontSize: 18)),
                                    ),
                                    SizedBox(height:10),
                                  ],
                                )
                              ),
                              SizedBox(height: 10),
                              
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyTeam(widget.url,widget.onChangeLanguage)),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff595c64),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff212630),
                                        ),
                                        margin: EdgeInsets.only(right: 20),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/my_team.png"),
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
                                                    .getData('my_team'),
                                                style: TextStyle(color: Colors.white,fontSize: 16),
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
                              
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TeamRevenue(widget.url,widget.onChangeLanguage)),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff595c64),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff212630),
                                        ),
                                        margin: EdgeInsets.only(right: 20),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/my_team.png"),
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
                                                    .getData('team_revenue'),
                                                style: TextStyle(color: Colors.white,fontSize: 16),
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
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => Invitation(widget.url,widget.onChangeLanguage)),
                              //     );
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.all(6),
                              //     decoration: new BoxDecoration(
                              //       color: Color(0xff595c64),
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                              //     child: Row(
                              //       children: <Widget>[
                              //         Container(
                              //           padding: EdgeInsets.all(5),
                              //           decoration: BoxDecoration(
                              //             shape: BoxShape.circle,
                              //             color: Color(0xff212630),
                              //           ),
                              //           margin: EdgeInsets.only(right: 20),
                              //           child: Image(
                              //             image: AssetImage(
                              //                 "lib/assets/img/inv_friend.png"),
                              //             height: 30,
                              //             width: 40,
                              //           )
                              //         ),
                              //         Expanded(
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: <Widget>[
                              //               Container(
                              //                 child: Text(
                              //                   MyLocalizations.of(context)
                              //                       .getData('invite_friend'),
                              //                   style: TextStyle(color: Colors.white,fontSize: 16),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //         Expanded(
                              //           child: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.end,
                              //             children: <Widget>[
                              //               Container(
                              //                   child: (Icon(
                              //                       Icons.chevron_right_outlined,color: Colors.white,))),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => RegisterStepOne(widget.url,widget.onChangeLanguage)),
                              //     );
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.all(6),
                              //     decoration: new BoxDecoration(
                              //       color: Color(0xff595c64),
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                              //     child: Row(
                              //       children: <Widget>[
                              //         Container(
                              //           padding: EdgeInsets.all(5),
                              //           decoration: BoxDecoration(
                              //             shape: BoxShape.circle,
                              //             color: Color(0xff212630),
                              //           ),
                              //           margin: EdgeInsets.only(right: 20),
                              //           child: Image(
                              //             image: AssetImage(
                              //                 "lib/assets/img/register.png"),
                              //             height: 30,
                              //             width: 40,
                              //           )
                              //         ),
                              //         Expanded(
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: <Widget>[
                              //               Container(
                              //                 child: Text(
                              //                   MyLocalizations.of(context)
                              //                       .getData('register'),
                              //                   style: TextStyle(color: Colors.white,fontSize: 16),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //         Expanded(
                              //           child: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.end,
                              //             children: <Widget>[
                              //               Container(
                              //                   child: (Icon(
                              //                       Icons.chevron_right_outlined,color: Colors.white,))),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllTransactionRecord(widget.url,widget.onChangeLanguage)),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff595c64),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff212630),
                                        ),
                                        margin: EdgeInsets.only(right: 20),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/transaction_details.png"),
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
                                                    .getData('transaction_details'),
                                                style: TextStyle(color: Colors.white,fontSize: 16),
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
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BonusCenter(widget.url,widget.onChangeLanguage,type)),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff595c64),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff212630),
                                        ),
                                        margin: EdgeInsets.only(right: 20),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/bonus.png"),
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
                                                    .getData('bonus'),
                                                style: TextStyle(color: Colors.white,fontSize: 16),
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
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => TransactionLog(widget.url,robotList[0]['id'])),
                              //     );
                              //   },
                              //   child: Container(
                              //     decoration: new BoxDecoration(
                              //       color: Color(0xff595c64),
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                              //     child: Row(
                              //       children: <Widget>[
                              //         Container(
                              //           decoration: BoxDecoration(
                              //             shape: BoxShape.circle,
                              //           ),
                              //           margin: EdgeInsets.only(right: 20),
                              //           padding: EdgeInsets.all(10),
                              //           child: Image(
                              //             image: AssetImage(
                              //                 "lib/assets/img/transcation.png"),
                              //             height: 30,
                              //             width: 40,
                              //           )
                              //         ),
                              //         Expanded(
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: <Widget>[
                              //               Container(
                              //                 child: Text(
                              //                   'Log',
                              //                   style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //         Expanded(
                              //           child: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.end,
                              //             children: <Widget>[
                              //               Container(
                              //                   child: (Icon(
                              //                       Icons.chevron_right_outlined,color: Colors.white,))),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ServiceCenter(widget.url)),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff595c64),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff212630),
                                        ),
                                        margin: EdgeInsets.only(right: 20),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/me_customer_service.png"),
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
                                                    .getData('contact_service'),
                                                style: TextStyle(color: Colors.white,fontSize: 16),
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
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SecurityCenter(widget.url,widget.onChangeLanguage)),
                                  ).then((value) {
                                    getRequest();getLanguage();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff595c64),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff212630),
                                        ),
                                        margin: EdgeInsets.only(right: 20),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/me_settings.png"),
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
                                                    .getData('settings'),
                                                style: TextStyle(color: Colors.white,fontSize: 16),
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
                             
                              InkWell(
                                onTap: () {
                                  // showAlertDialog(context);
                                  final action = CupertinoActionSheet(
                                    title: Text(
                                      MyLocalizations.of(context).getData('log_out_confirmation'),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey[700]),
                                    ),
                                    actions: [
                                      CupertinoActionSheetAction(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.remove('token');
                                          await Future.delayed(Duration(seconds: 0));
                                          // _showToast(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage(
                                                    widget.url,
                                                    widget.onChangeLanguage)),
                                          );
                                        },
                                        child: Text(MyLocalizations.of(context).getData('log_out')),
                                        isDestructiveAction: true,
                                      )
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      child: Text(MyLocalizations.of(context).getData('cancel')),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                  showCupertinoModalPopup(
                                      context: context, builder: (context) => action);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff595c64),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.only(left:10,right:10,bottom: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff212630),
                                        ),
                                        margin: EdgeInsets.only(right: 20),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/logout.png"),
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
                                                    .getData('log_out'),
                                                style: TextStyle(color: Colors.white,fontSize: 16),
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
                              )
                              
                            ])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
