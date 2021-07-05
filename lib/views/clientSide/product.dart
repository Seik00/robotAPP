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
class Product extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Product(this.url, this.onChangeLanguage);
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product>
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
      body: Stack(
        children: [
          Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction_rounded,color: Colors.white,size: 50,),
                  Text(MyLocalizations.of(context).getData('coming_soon'),style: TextStyle(color: Colors.white,fontSize: 20),),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
