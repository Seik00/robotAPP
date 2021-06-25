import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class Invitation extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Invitation(this.url, this.onChangeLanguage);
  @override
  _InvitationState createState() => _InvitationState();
}

class _InvitationState extends State<Invitation> with SingleTickerProviderStateMixin {

  var shareLink;
  var pattern;

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          shareLink = contentData['share_link'];
          print(shareLink);
        });
      }
    }
  }

  Future<void> savePattern() async {
    final prefs = await SharedPreferences.getInstance();
     prefs.setString("pattern", pattern);

  }

  Future<String> getPattern() async {
    final prefs = await SharedPreferences.getInstance();
    pattern = prefs.getString('pattern') ?? "null";

    return pattern;
  }

  Future<void> _showPattern() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color(0xff9957ED),
            title: Text(MyLocalizations.of(context).getData('sport_type'),style: TextStyle(color: Colors.white)),
            content: Wrap(
              direction: Axis.vertical,
              spacing: 15,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                       setState(() {
                        pattern = '1';
                        savePattern();
                        Navigator.pop(context);
                      });
                    },
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(right:10),
                        width: 30.0,
                        height: 30.0,
                        child: Icon(Icons.sports_soccer,color: Colors.white,),
                        ),
                      Text(MyLocalizations.of(context).getData('sport_type_one'),style: TextStyle(color: Colors.white),)
                    ],)
                   ),
                GestureDetector(
                    onTap: () {
                       setState(() {
                        pattern = '2';
                        print(pattern);
                        savePattern();
                        Navigator.pop(context);
                      });
                    },
                    child: Row(children:[
                      Container(
                        margin: EdgeInsets.only(right:10),
                        width: 30.0,
                        height: 30.0,
                        child: Icon(Icons.sports_volleyball,color: Colors.white),
                        ),
                      Text(MyLocalizations.of(context).getData('sport_type_two'),style: TextStyle(color: Colors.white))
                    ]),
                   ),
                GestureDetector(
                   onTap: () {
                       setState(() {
                        pattern = '3';
                        print(pattern);
                        savePattern();
                        Navigator.pop(context);
                      });
                    },
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(right:10),
                        width: 30.0,
                        height: 30.0,
                        child: Icon(Icons.sports_basketball,color: Colors.white),
                        ),
                      Text(MyLocalizations.of(context).getData('sport_type_three'),style: TextStyle(color: Colors.white),)
                    ],)
                   ),
              ],
            ));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getRequest();
    getPattern();
    print(pattern);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: pattern == '1'?AssetImage("lib/assets/img/invite_bg1.png"):pattern == '2'?AssetImage("lib/assets/img/invite_bg2.png"):pattern == '3'?AssetImage("lib/assets/img/invite_bg3.png"):AssetImage("lib/assets/img/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                  margin: EdgeInsets.only(right:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context, true)),
                    ],
                  ),
                ),
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.only(top:10,bottom:10),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                    //image: DecorationImage(image: AssetImage("lib/assets/img/vietnam_flag.png"))
                ), 
              child: Center(
                child:Container(
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                    Container(
                      child: Text(
                      MyLocalizations.of(context).getData('scan'),
                      style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),)
                    ),
                    Container(
                      child: Text(
                      MyLocalizations.of(context).getData('download'),
                      style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),)
                    ),
                    Container(
                      child: Flexible(
                        child: Text(
                        MyLocalizations.of(context).getData('experience'),
                        style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,),),
                      )
                    )
                  ],),
                )
              ),
            ),
            Container(
               padding: EdgeInsets.only(bottom:10),
               decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                    //image: DecorationImage(image: AssetImage("lib/assets/img/vietnam_flag.png"))
                ), 
               child: Center(
                child:Container(
                  child: Text(
                    MyLocalizations.of(context).getData('scan_qr'),
                    style: TextStyle(color: Colors.grey[350],fontSize: 18,fontWeight: FontWeight.bold),),)
              ),
            ),
            SizedBox(height:10),
            // Center(child: Container(
            //   padding: EdgeInsets.all(20),
            //   child: Text(MyLocalizations.of(context).getData('invite_desc'),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),)
            //   ),
             SizedBox(height:20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                    //image: DecorationImage(image: AssetImage("lib/assets/img/qr-frame.png"))
                ), 
                padding: EdgeInsets.all(10),
                child: Container(
                  child: QrImage(
                    data: shareLink ==null?'':shareLink,
                    version: QrVersions.auto,
                    size: 180.0,
                  ),
                ),
              ),
            ),
            SizedBox(height:30),
            Center(
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(new ClipboardData(text: shareLink));
                  Fluttertoast.showToast(
                    msg: MyLocalizations.of(context).getData('copy_link'),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Color(0xFFDCDCDC),
                    textColor: Colors.black,
                  );
                },
                child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xfffaef1d), Color(0xfff9f21a)])
                ),
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.height / 15,
                alignment: Alignment.center,
                child: Text(MyLocalizations.of(context).getData('copy'),style: TextStyle(color: Colors.black),
                )),
              ),
            ),
          
          ],
        ),
      ),
    );
  }

  
}
