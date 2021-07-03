import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Explore/apiBindingForm.dart';
import 'package:robot/views/Explore/investRecord.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllTransactionRecord extends StatefulWidget {
   final url;
   final robotID;

  AllTransactionRecord(this.url,this.robotID);
  @override
  _AllTransactionRecordState createState() => _AllTransactionRecordState();
}

class _AllTransactionRecordState extends State<AllTransactionRecord> {
  var type = '';
  var dataList;
 


  @override
  void initState() {
    super.initState();
    getRequest();
  }

  getRequest() async {
    var contentData = await Request()
        .getRequest(Config().url + "api/trade-revenue/tradeOrder", context);
    if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          dataList = contentData['data']['data'];
          print(dataList);
        });
      }
    }

    
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
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [
            Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                             alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context, true)),
                          ),
                           Expanded(
                            child: 
                            Container(
                               alignment: Alignment.centerLeft,
                              child: Text(MyLocalizations.of(context).getData('transaction_details'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                dataList==null?Container():
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    padding: EdgeInsets.all(10),
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
                                  Row(
                                    children: [
                                      dataList[index]['platform'] =='binance'?
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white
                                        ),
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(5),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/BNB.png"),
                                          height: 15,
                                          width: 15,
                                        )
                                      ):
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white
                                        ),
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(5),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/HT.png"),
                                          height: 15,
                                          width: 15,
                                        )
                                      ),
                                      Text(dataList[index]['market'],style: TextStyle(color: Colors.white,fontSize: 18),),
                                    ],
                                  ),
                                  SizedBox(height:5),
                                  Text(double.parse(dataList[index]['price']).toStringAsFixed(5),style: TextStyle(color: Colors.white,fontSize: 18)),
                                  SizedBox(height:5),
                                  Text(MyLocalizations.of(context).getData('deal_price') + ' (USDT)',style: TextStyle(color: Colors.white70,fontSize: 14)),
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
                                        Text(MyLocalizations.of(context).getData('order_time'),style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['ctime'],style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                  SizedBox(height:5),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('deal_money'),style: TextStyle(color: Colors.white70)),
                                        Text(double.parse(dataList[index]['deal_money']).toStringAsFixed(8),style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                  SizedBox(height:5),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('deal_amount'),style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['deal_amount'],style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                  SizedBox(height:5),
                                  
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                  }),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
