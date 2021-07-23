import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/changeWallet.dart';
import 'package:robot/views/Explore/comingSoon.dart';
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
            child: Column(
              children: [
                 Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ComingSoon(widget.url,widget.onChangeLanguage)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(  
                          color: Color(0xffEA5F75), 
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color(0xffEA5F75),width: 3,)
                        ),
                        margin: EdgeInsets.only(top:50,bottom:10,left: 10,right: 10),
                        padding: EdgeInsets.all(10),
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
                                    "lib/assets/img/de_1.png"),
                                height: 40,
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
                                      MyLocalizations.of(context).getData('ai_robot'),
                                      style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
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
                                          Icons.chevron_right_outlined,color: Colors.black,))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ComingSoon(widget.url,widget.onChangeLanguage)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(  
                          color: Color(0xff5dbb95), 
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color(0xff68dbac),width: 3,)
                        ),
                        margin: EdgeInsets.only(bottom:10,left: 10,right: 10),
                        padding: EdgeInsets.all(10),
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
                                    "lib/assets/img/de_2.png"),
                                height: 40,
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
                                      MyLocalizations.of(context).getData('ai_robot2'),
                                      style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
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
                                          Icons.chevron_right_outlined,color: Colors.black,))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ComingSoon(widget.url,widget.onChangeLanguage)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(  
                          color: Color(0xffa2c6ff), 
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color(0xff7aabf7),width: 3,)
                        ),
                        margin: EdgeInsets.only(bottom:10,left: 10,right: 10),
                        padding: EdgeInsets.all(10),
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
                                    "lib/assets/img/de_3.png"),
                                height: 40,
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
                                      MyLocalizations.of(context).getData('ai_robot3'),
                                      style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
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
                                          Icons.chevron_right_outlined,color: Colors.black,))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
