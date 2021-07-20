import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/changeWallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ComingSoon extends StatefulWidget {
  final url;
  final onChangeLanguage;

  ComingSoon(this.url, this.onChangeLanguage);
  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon>
    with SingleTickerProviderStateMixin {

  var dataList = [];
  var usdt;
  var gas;
  var gasPingyi;
  var walletType = 'point1';
  



  
 TabController _tabController;

  @override
  void initState() {
    super.initState();
   
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/img/inv_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
          Container(
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
            Spacer(),
            Center(
               child: Container(
                 padding: EdgeInsets.all(10),
                 child: Text(MyLocalizations.of(context).getData('coming'),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
               ),
             ),
            Spacer(),
          ],
        )
      ),
    );
  }
}
