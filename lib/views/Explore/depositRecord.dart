import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DepositRecord extends StatefulWidget {
  final url;
 

  DepositRecord(this.url);
  @override
  _DepositRecordState createState() => _DepositRecordState();

  
}
  
class _DepositRecordState extends State<DepositRecord> {
  var dataList = [];
  var language;
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
   
  }

   getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/wallet/deposit-record", context);
    if(contentData!= null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          dataList = contentData['data']['data'];
          print(dataList);
        });
      }
    }
    }
  }

 
  
  @override
  void initState() {
    super.initState();
    getLanguage();
    getRequest();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                onPressed: () => Navigator.pop(context)),
                Center(
                    child: Text(
                        MyLocalizations.of(context).getData('deposit_record'),
                        style: Theme.of(context).textTheme.headline1)),
                SizedBox(height:20),
                dataList.isEmpty?
                Container(
                  margin: EdgeInsets.only(top:40),
                  child: Center(
                    child: Column(children: [
                      Icon(Icons.content_paste_outlined,size: 50,color: Colors.white,),
                      Text(MyLocalizations.of(context).getData('no_record'),style:TextStyle(color: Colors.white,fontSize: 20)),
                    ],)
                   
                  ),
                ):
                Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(10),
                          decoration: new BoxDecoration(
                          color: Color(0xff595c64),
                          borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                              child: ExpansionTile(
                                title: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(dataList[index]['detail'],style: TextStyle(color: Colors.white,fontSize: 12),),
                                      SizedBox(height:5),
                                      dataList[index]['action'] =='-'?
                                      Text('-'+dataList[index]['found'],style: TextStyle(color: Colors.redAccent,fontSize: 16)):
                                      Text('+'+dataList[index]['found'],style: TextStyle(color: Colors.greenAccent,fontSize: 16)),
                                      SizedBox(height:5),
                                    ],
                                  ),
                                ),
                                children: <Widget>[
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height:10),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: EdgeInsets.only(left:15),
                                        child: Row(
                                          children: [
                                            Text(MyLocalizations.of(context).getData('order_time'),style: TextStyle(color: Colors.white70,fontSize: 13)),
                                            Text(dataList[index]['created_at'],style: TextStyle(color: Colors.white70,fontSize: 13)),
                                          ],
                                        )),
                                      SizedBox(height:5),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: EdgeInsets.only(left:15),
                                        child: Row(
                                          children: [
                                            Text(MyLocalizations.of(context).getData('previous_balance')+ ' : ',style: TextStyle(color: Colors.white70,fontSize: 13)),
                                            Text(dataList[index]['previous'].toString()+ ' USDT',style: TextStyle(color: Colors.white70,fontSize: 13)),
                                          ],
                                        )),
                                      SizedBox(height:5),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: EdgeInsets.only(left:15),
                                        child: Row(
                                          children: [
                                            Text(MyLocalizations.of(context).getData('current_balance')+ ' : ',style: TextStyle(color: Colors.white70,fontSize: 13)),
                                            Text(dataList[index]['current'].toString()+ ' USDT',style: TextStyle(color: Colors.white70,fontSize: 13)),
                                          ],
                                        )),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            ],
                          ),
                        );
                        }),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}
