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
  var id;

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          shareLink = contentData['share_link'];
          id = contentData['id'];
          print(shareLink);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getRequest();
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
            image: AssetImage("lib/assets/img/inv_bg.png"),
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
            Center(
              child: Container(
                child: Image(
                  image: AssetImage(
                      "lib/assets/img/inv_logo.png"),
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            SizedBox(height:10),
            // Center(child: Container(
            //   padding: EdgeInsets.all(20),
            //   child: Text(MyLocalizations.of(context).getData('invite_desc'),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),)
            //   ),
            Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(MyLocalizations.of(context).getData('invi_code'),style: TextStyle(color: Colors.white),),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(new ClipboardData(text: id.toString()));
                      Fluttertoast.showToast(
                        msg: MyLocalizations.of(context).getData('copy_invi_code'),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Color(0xFFDCDCDC),
                        textColor: Colors.black,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[ 
                          Container(
                            padding: EdgeInsets.only(right:5),
                            child:Text(
                              id==null?'':id.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal
                              ),
                            )
                          ),
                          Icon(Icons.content_copy, size: 20, color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),
             SizedBox(height:20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                    //image: DecorationImage(image: AssetImage("lib/assets/img/qr-frame.png"))
                ), 
                padding: EdgeInsets.all(6),
                child: Container(
                  child: QrImage(
                    data: shareLink ==null?'':shareLink,
                    version: QrVersions.auto,
                    size: 150.0,
                  ),
                ),
              ),
            ),
            SizedBox(height:20),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 2,),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                    //image: DecorationImage(image: AssetImage("lib/assets/img/vietnam_flag.png"))
                ), 
                child: Text(
                      MyLocalizations.of(context).getData('scan_qr'),
                      style: TextStyle(color: Colors.black,fontSize: 16,),)
              ),
            ),
            SizedBox(height:20),
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
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xfffaef1d), Color(0xfff9f21a)])
                ),
                width: MediaQuery.of(context).size.width/2,
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
