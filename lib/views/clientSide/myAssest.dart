import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/apiBinding.dart';
import 'package:robot/views/Explore/buyPin.dart';
import 'package:robot/views/Explore/changeWallet.dart';
import 'package:robot/views/Explore/deposit.dart';
import 'package:robot/views/Explore/invest.dart';
import 'package:robot/views/Explore/transfer.dart';
import 'package:robot/views/Explore/transferPin.dart';
import 'package:robot/views/Explore/withdraw.dart';
import 'package:robot/views/SystemSetting/invitation.dart';
import 'package:robot/views/Trade/trade.dart';
import 'package:robot/views/Trade/tradeDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class MyAssests extends StatefulWidget {
  final url;
  final onChangeLanguage;

  MyAssests(this.url, this.onChangeLanguage);
  @override
  _MyAssestsState createState() => _MyAssestsState();
}

class _MyAssestsState extends State<MyAssests>
    with SingleTickerProviderStateMixin {

  var dataList = [];
  var usdt;
  var gas;
  var walletType = 'point1';
  
  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          print(contentData);
          usdt = contentData['point1'];
          gas = contentData['point2'];
        });
      }
    }
  }

  initializeData(walletType) async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'wallet': walletType,
      };
      var uri = Uri.https(Config().url2, 'api/record/wallet-record', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
    
      setState(() {
        dataList = contentData['data']['data'];
        print(dataList);
        print('--------');
    });
  }

  
 TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    getRequest();
    initializeData(walletType);
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
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(MyLocalizations.of(context).getData('wallet'),style: TextStyle(color: Colors.white),),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: new BoxDecoration(
                    color:Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelStyle: TextStyle(fontSize:13),
                  labelStyle: TextStyle(fontSize:16),
                  indicator: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xfff6fb15), Color(0xfffed323)]),
                  borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: (index) {
                    if(index == 0){
                      initializeData('point1');
                    }else{
                      initializeData('point2');
                    }
                  },
                  tabs: [
                    Tab(
                      text: 'USDT',
                    ),
                    Tab(
                      text: 'GAS',
                    )
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                ),
                
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                              color: Color(0xff595c64),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(top:20,bottom:10,left: 10,right: 10),
                            padding:EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Text(MyLocalizations.of(context).getData('total_assets_converted_USDT'),style: TextStyle(color:Colors.white,fontSize: 16),),
                               SizedBox(height: 10,),
                               Text(usdt==null?'':usdt,style: TextStyle(color:Colors.white,fontSize: 26)),
                               SizedBox(height: 5,),
                               usdt==null?Text(''):
                               Text('≈ ' + usdt +' USD',style: TextStyle(color:Colors.white,fontSize: 14)),
                              ],
                            ),
                            ),
                            Container(
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Column(children: <Widget>[
                                    FlatButton(
                                      onPressed: () => {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => Deposit(widget.url,widget.onChangeLanguage)),
                                        // ).then((value) {
                                        //   getRequest();getRequest();
                                        // })
                                      },
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Container(
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white,width: 3, )
                                            ),
                                            child: Image(
                                              image: AssetImage(
                                                  "lib/assets/img/trade_one_shot.png"),
                                              height: 60,
                                              width: 60,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(MyLocalizations.of(context).getData('deposit'),style: TextStyle(color:Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ])),
                                  Container(
                                    child: Column(children: <Widget>[
                                    FlatButton(
                                      onPressed: () => {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => Withdraw(widget.url)),
                                        // ).then((value) {
                                        //   getRequest();getRequest();
                                        // })
                                      },
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                            Container(
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white,width: 3, )
                                            ),
                                            child: Image(
                                              image: AssetImage(
                                                  "lib/assets/img/trade_clearance sale.png"),
                                              height: 60,
                                              width: 60,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(MyLocalizations.of(context).getData('withdraw'),style: TextStyle(color:Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ])),
                                  Container(
                                    child: Column(children: <Widget>[
                                    FlatButton(
                                      onPressed: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChangeWallet(widget.url)),
                                        ).then((value) {
                                          getRequest();initializeData('point1');
                                        })
                                      },
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Container(
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white,width: 3, )
                                            ),
                                            child: Image(
                                              image: AssetImage(
                                                  "lib/assets/img/trade_replenishment.png"),
                                              height: 60,
                                              width: 60,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(MyLocalizations.of(context).getData('change_wallet'),style: TextStyle(color:Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ])),
                                ],
                              ),
                            ),
                            SizedBox(height:10),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(MyLocalizations.of(context).getData('history_record'),style: TextStyle(color:Colors.white,fontSize: 18),),
                            ),
                            
                            Container(
                              child: dataList == null || dataList.isEmpty ? 
                              Container(
                                padding: EdgeInsets.only(top:20),
                                margin: EdgeInsets.only(bottom:120),
                                child: Center(
                                  child: Text(MyLocalizations.of(context).getData('no_record'),style: TextStyle(color:Colors.white),),
                                ),
                              ):ListView.builder(
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
                                              Text(dataList[index]['detail'],style: TextStyle(color: Colors.white,fontSize: 18),),
                                              SizedBox(height:5),
                                              dataList[index]['action'] =='-'?
                                              Text('-'+dataList[index]['found'],style: TextStyle(color: Colors.redAccent,fontSize: 20)):
                                              Text('+'+dataList[index]['found'],style: TextStyle(color: Colors.greenAccent,fontSize: 20)),
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
                                                    Text(MyLocalizations.of(context).getData('order_time'),style: TextStyle(color: Colors.white70)),
                                                    Text(dataList[index]['created_at'],style: TextStyle(color: Colors.white70)),
                                                  ],
                                                )),
                                              SizedBox(height:5),
                                              Container(
                                                alignment: Alignment.bottomLeft,
                                                padding: EdgeInsets.only(left:15),
                                                child: Row(
                                                  children: [
                                                    Text(MyLocalizations.of(context).getData('previous_balance')+ ' : ',style: TextStyle(color: Colors.white70)),
                                                    Text(dataList[index]['previous'].toString()+ ' USDT',style: TextStyle(color: Colors.white70)),
                                                  ],
                                                )),
                                              SizedBox(height:5),
                                              Container(
                                                alignment: Alignment.bottomLeft,
                                                padding: EdgeInsets.only(left:15),
                                                child: Row(
                                                  children: [
                                                    Text(MyLocalizations.of(context).getData('current_balance')+ ' : ',style: TextStyle(color: Colors.white70)),
                                                    Text(dataList[index]['current'].toString()+ ' USDT',style: TextStyle(color: Colors.white70)),
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
                            )
                          ],
                        ),
                      ),

                      Container(
                        child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                              color: Color(0xff595c64),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(top:20,bottom:10,left: 10,right: 10),
                            padding:EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Text(MyLocalizations.of(context).getData('total_assets_converted_USDT'),style: TextStyle(color:Colors.white,fontSize: 16),),
                               SizedBox(height: 10,),
                               Text(gas==null?'':gas,style: TextStyle(color:Colors.white,fontSize: 26)),
                               SizedBox(height: 5,),
                               gas==null?Text(''):
                               Text(gas==''?'':'≈ ' + gas +' USD',style: TextStyle(color:Colors.white,fontSize: 14)),
                              ],
                            ),
                            ),
                            Container(
                              child: dataList == null || dataList.isEmpty ? 
                              Container(
                                padding: EdgeInsets.only(top:20),
                                child: Center(
                                  child: Text(MyLocalizations.of(context).getData('no_record'),style: TextStyle(color:Colors.white),),
                                ),
                              ):ListView.builder(
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
                                              Text(dataList[index]['detail'],style: TextStyle(color: Colors.white,fontSize: 18),),
                                              SizedBox(height:5),
                                              dataList[index]['action'] =='-'?
                                              Text('-'+dataList[index]['found'],style: TextStyle(color: Colors.redAccent,fontSize: 20)):
                                              Text('+'+dataList[index]['found'],style: TextStyle(color: Colors.greenAccent,fontSize: 20)),
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
                                                    Text(MyLocalizations.of(context).getData('order_time'),style: TextStyle(color: Colors.white70)),
                                                    Text(dataList[index]['created_at'],style: TextStyle(color: Colors.white70)),
                                                  ],
                                                )),
                                              SizedBox(height:5),
                                              Container(
                                                alignment: Alignment.bottomLeft,
                                                padding: EdgeInsets.only(left:15),
                                                child: Row(
                                                  children: [
                                                    Text(MyLocalizations.of(context).getData('previous_balance')+ ' : ',style: TextStyle(color: Colors.white70)),
                                                    Text(dataList[index]['previous'].toString()+ ' USDT',style: TextStyle(color: Colors.white70)),
                                                  ],
                                                )),
                                              SizedBox(height:5),
                                              Container(
                                                alignment: Alignment.bottomLeft,
                                                padding: EdgeInsets.only(left:15),
                                                child: Row(
                                                  children: [
                                                    Text(MyLocalizations.of(context).getData('current_balance')+ ' : ',style: TextStyle(color: Colors.white70)),
                                                    Text(dataList[index]['current'].toString()+ ' USDT',style: TextStyle(color: Colors.white70)),
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
                            )
                          ],
                        ),
                      ),
                        ),
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
