import 'dart:convert';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Trade/trade.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Quantity extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Quantity(this.url, this.onChangeLanguage);
  @override
  _QuantityState createState() => _QuantityState();
}

class _QuantityState extends State<Quantity>
    with SingleTickerProviderStateMixin {

  var dataList;
  var dataList2;
  var body;
  var type = 'binance';
  var type2 = 'huobi';
  var marketId;
  var marketName;
  var bodyUSDT;
  List coin;
  var usdt;
  var coinUsdt ='USDT';
  Timer _timer;
  int count= 0;

  startLoop(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        // if (contentData['status']) {
            var checkApi= await initializeData();
            if (this.mounted) {
              setState(() {
                count++;
              });
            }

          if(!checkApi){
            timer.cancel();

          }
      },
    );

  }

  startLoop2(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        // if (contentData['status']) {
            var checkApi= await initializeData2();
            if (this.mounted) {
              setState(() {
                count++;
              });
            }

          if(!checkApi){
            timer.cancel();

          }
      },
    );

  }

  getLocalStorage()async{
    final prefs = await SharedPreferences.getInstance();

    var tempList = prefs.getString('marketList');
    if (tempList!=null) {
      setState(() {
        dataList = json.decode(tempList);
      });
    }
    startLoop();

  }

  getLocalStorage2()async{
    final prefs = await SharedPreferences.getInstance();

    var tempList = prefs.getString('marketList2');
    if (tempList!=null) {
      setState(() {
        dataList2 = json.decode(tempList);
      });
    }
    startLoop2();

  }

   initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'platform': 'binance',
        'type': 'spot',
      };
      // print(body);
      print('part1:' + count.toString());
      var uri = Uri.https(Config().url2, 'api/trade-robot/marketList', body);
   
      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      // print(contentData);
      try {
        if(contentData != null){
          if (contentData['code'] == 0) {
            if (this.mounted) {
                setState(() {
                  dataList = contentData['data'];
                  prefs.setString('marketList', json.encode(dataList));
                });
              }
          }
        } 
        return true;
      } catch (e) {
       
        return false;
        
      }
  }

   initializeData2() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'platform': 'huobi',
        'type': 'spot',
      };
      // print(body);
      var uri = Uri.https(Config().url2, 'api/trade-robot/marketList', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      print('part2:' + count.toString());
      try {
        if(contentData != null){
          if (contentData['code'] == 0) {
            if (this.mounted) {
              setState(() {
                dataList2 = contentData['data'];
                prefs.setString('marketList2', json.encode(dataList2));
              });
            }
          }
        } 
        return true;
      } catch (e) {
       
        return false;
        
      }
  }

  getAPIInfo(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/trade-account/accountBalance", bodyData, token, context);
    if (this.mounted) {
      if (contentData['code'] == 0) {
        setState(() {
          // print(contentData['data'].length);
          coin = contentData['data'].toList();
          usdt = coin.singleWhere((element) =>
              element['asset'] == 'USDT', orElse: () {
                return null;
            });

            print(usdt);
        });
        } else {
        
        }
    }
  }

  @override
  void initState() {
    super.initState();
    bodyUSDT = {
      'platform': 'binance',
    };
    getAPIInfo(bodyUSDT);
    getLocalStorage();
    // startLoop();
  }

 
  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xff212630),
          appBar: AppBar(
            backgroundColor: Color(0xff474c56),
            bottom: TabBar(
                onTap: (index) {
                  setState(() {
                    _timer.cancel();
                    count = 0;
                  });
                  if(index == 0){
                    startLoop();
                  }else if(index == 1){
                    getLocalStorage2();
                  }
                },
              tabs: [
                Tab(child: Text(MyLocalizations.of(context).getData('binance')),),
                Tab(child: Text(MyLocalizations.of(context).getData('huobi')),),
              ],
            ),
          ),
          body:TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                child:  dataList == null || dataList.isEmpty ?Center(child: CircularProgressIndicator()):
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                        ),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(MyLocalizations.of(context).getData('usdt_balance')),
                            usdt == null?
                            Text('0.00'):
                            Text(usdt['free']),
                          ],
                        ),
                      ),
                      Container(
                        child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                        return GestureDetector(
                           onTap: (){
                            _timer.cancel();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,type,dataList[index]['id'],dataList[index]['market_name'],dataList[index]['market_name'])),
                            ).then((value) => startLoop());
                          },
                          child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                color: Color(0xff595c64),
                                borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Container(
                                        //   decoration: BoxDecoration(
                                        //     shape: BoxShape.circle,
                                        //   ),
                                        //   margin: EdgeInsets.only(right: 20),
                                        //   padding: EdgeInsets.all(10),
                                        //   child:  Image(
                                        //     image: NetworkImage(
                                        //       dataList[index]['img_url']
                                        //       ),
                                        //     height: 20,
                                        //     width: 20,
                                        //   ),
                                        // ),
                                        Container(
                                          child: Text(dataList[index]['market_name'],style: TextStyle(color: Colors.grey),),),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: new BoxDecoration(
                                            color: Colors.yellowAccent,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Text('0.00%'),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      height: 10,
                                      color: Colors.grey[400],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('market_price'),style: TextStyle(color: Colors.grey))), 
                                            SizedBox(width: 10),
                                            Container(child: Text(dataList[index]['price'],style: TextStyle(color: Colors.grey))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('floating'),style: TextStyle(color: Colors.grey))),
                                             SizedBox(width: 10),
                                            double.parse(dataList[index]['change']) > 0?
                                            Text(dataList[index]['change']+'%',style: TextStyle(color: Colors.greenAccent)):
                                            Text(dataList[index]['change']+'%',style: TextStyle(color: Colors.redAccent)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child:  dataList2 == null || dataList2.isEmpty ?Center(child: CircularProgressIndicator()):ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: dataList2.length,
                itemBuilder: (BuildContext ctxt, int index) {
                return GestureDetector(
                   onTap: (){
                      _timer.cancel();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,type2,dataList2[index]['id'],dataList2[index]['market_name'],dataList[index]['market_name'])),
                      ).then((value) => startLoop2());
                  },
                  child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                        color: Color(0xff595c64),
                        borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //   ),
                                //   margin: EdgeInsets.only(right: 20),
                                //   padding: EdgeInsets.all(10),
                                //   child:  Image(
                                //     image: NetworkImage(
                                //       dataList[index]['img_url']
                                //       ),
                                //     height: 20,
                                //     width: 20,
                                //   ),
                                // ),
                                Container(
                                  child: Text(dataList2[index]['market_name'],style: TextStyle(color: Colors.grey),),),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: new BoxDecoration(
                                    color: Colors.yellowAccent,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text('0.00%'),
                                )
                              ],
                            ),
                            Divider(
                              height: 10,
                              color: Colors.grey[400],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Row(
                                  children: [
                                    Container(child: Text(MyLocalizations.of(context).getData('market_price'),style: TextStyle(color: Colors.grey))), 
                                    SizedBox(width: 10),
                                    Container(child: Text(dataList2[index]['price'],style: TextStyle(color: Colors.grey))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(child: Text(MyLocalizations.of(context).getData('floating'),style: TextStyle(color: Colors.grey))),
                                      SizedBox(width: 10),
                                    double.parse(dataList2[index]['change']) > 0?
                                    Text(dataList2[index]['change']+'%',style: TextStyle(color: Colors.greenAccent)):
                                    Text(dataList2[index]['change']+'%',style: TextStyle(color: Colors.redAccent)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
