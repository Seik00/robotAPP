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
  var huobi;
  var money;
  var coinUsdt ='USDT';
  Timer _timer;
  int count= 0;
  var info;

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

  dealAmount(data){
     if(data['robot_info']['values_str'] !=null){
        var jsonData = json.decode(data['robot_info']['values_str']);
        return jsonData['deal_amount'].toStringAsFixed(5);
     }else{
       return '0.00';
     }
    

  }

  dealMoney(data){
    if(data['robot_info']['values_str'] !=null){
      var jsonData = json.decode(data['robot_info']['values_str']);
      return jsonData['deal_money'].toStringAsFixed(5);
    }else{
       return '0.00';
     }
    

  }

  infoStatus(data){
    if(data['robot_info']['values_str'] !=null){
       var jsonData = json.decode(data['robot_info']['values_str']);
       return jsonData['status'].toString();
    }
   
  }

  infoShowMsg(data){
    var jsonData = json.decode(data['robot_info']['values_str']);
    return jsonData['show_msg'].toString();
  }


   initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'platform': 'binance',
        'type': 'spot',
      };
      print('part1:' + count.toString());
      var uri = Uri.https(Config().url2, 'api/trade-robot/marketList', body);
   
      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);

      try {
        if(contentData != null){
          if (contentData['code'] == 0) {
            if (this.mounted) {
                setState(() {
                  dataList = contentData['data'];
                  prefs.setString('marketList', json.encode(dataList));
                  
                  //info = json.encode(coin[0]['robot_info']['values_str']);
                  
                  // for(int i= 0; i<dataList.length; i++){
                  //    info = json.decode(dataList[i]['robot_info']['values_str']);

                  //    if(contentData['data']['robot_info']==null){
                  //       coin = contentData['data']['robot_info'].toList();
                  //       //info = json.decode(coin);
                  //       print(coin);
                  //     }else{
                  //       print('jibai');
                  //     }
                  // }
                 
                  
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
        setState(() {
          
          money = contentData;
          print(money);
          // coin = contentData['data'].toList();
          // usdt = coin.singleWhere((element) =>
          //     element['asset'] == 'USDT', orElse: () {
          //       return null;
          //   });

          //   print('------');
          //   print(usdt);
          //   print('------');
        });
        
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
            bottom: new PreferredSize(
              preferredSize: new Size(0.0, 0.0),
              child: new Container(
                child: TabBar(
                    onTap: (index) {
                      setState(() {
                        _timer.cancel();
                        count = 0;
                      });
                      if(index == 0){
                        getAPIInfo(bodyUSDT = {'platform': 'binance',});
                        startLoop();
                        print(money['data']);
                      }else if(index == 1){
                        getAPIInfo(bodyUSDT = {'platform': 'huobi',});
                        getLocalStorage2();
                        print(money['data']);
                      }
                    },
                  tabs: [
                    Tab(child: Text(MyLocalizations.of(context).getData('binance')),),
                    Tab(child: Text(MyLocalizations.of(context).getData('huobi')),),
                  ],
                ),
              ),
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
                            money ==null?Text(''):
                            money['code'] == 1?
                            Text('0.00'):
                            Text(money['data'].toString()),
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
                            dataList[index]['robot_info'] == null?
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,type,dataList[index]['id'],dataList[index]['market_name'],'')),
                            ).then((value) => startLoop()):
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,type,dataList[index]['id'],dataList[index]['market_name'],dataList[index]['robot_info']['id'])),
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
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(dataList[index]['market_name'],style: TextStyle(color: Colors.white),),),
                                            SizedBox(width:10),
                                            dataList[index]['robot_info']==null?Container():
                                            dataList[index]['robot_info']['status'] == 0 && dataList[index]['robot_info']['show_msg'] == '卖出成功' && dataList[index]['robot_info']['values_str'] == ''?
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.yellowAccent,
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: 
                                             
                                              Text(
                                                MyLocalizations.of(context).getData('sold')
                                                ,style: TextStyle(color: Colors.black,fontSize: 12),
                                              ),
                                            ):
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.yellowAccent,
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: 
                                             
                                              Text(
                                                dataList[index]['robot_info']['recycle_status']==0?
                                                MyLocalizations.of(context).getData('single'):
                                                MyLocalizations.of(context).getData('cycle')
                                                ,style: TextStyle(color: Colors.black,fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: new BoxDecoration(
                                            color: Colors.yellowAccent,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: 
                                          Text(
                                            dataList[index]['robot_info'] ==null?'0.00%':
                                            double.parse(dataList[index]['robot_info']['revenue']).toStringAsFixed(2)+'%')
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
                                            Container(child: Text(MyLocalizations.of(context).getData('market_price')+ ' :',style: TextStyle(color: Colors.grey))), 
                                            SizedBox(width: 5),
                                            Container(child: Text(dataList[index]['price'],style: TextStyle(color: Colors.grey))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('floating')+ ' :',style: TextStyle(color: Colors.grey))),
                                             SizedBox(width: 5),
                                            double.parse(dataList[index]['change']) > 0?
                                            Text(double.parse(dataList[index]['change']).toStringAsFixed(2)+'%',style: TextStyle(color: Colors.greenAccent)):
                                            Text(double.parse(dataList[index]['change']).toStringAsFixed(2)+'%',style: TextStyle(color: Colors.redAccent)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    dataList[index]['robot_info'] ==null?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('quantity')+ ' :',style: TextStyle(color: Colors.grey))), 
                                            SizedBox(width: 5),
                                            Container(child: 
                                            Text('0.00',
                                            style: TextStyle(color: Colors.grey))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('amount')+ ' :',style: TextStyle(color: Colors.grey))),
                                             SizedBox(width: 5),
                                            Text('0.00',style: TextStyle(color: Colors.grey))
                                          ],
                                        ),
                                      ],
                                    ):
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('quantity')+ ' :',style: TextStyle(color: Colors.grey))), 
                                            SizedBox(width: 5),
                                            Container(child: 
                                            Text( dataList[index]['robot_info']['values_str']!=''?dealAmount(dataList[index]):'0.00',
                                            style: TextStyle(color: Colors.grey))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('amount')+ ' :',style: TextStyle(color: Colors.grey))),
                                             SizedBox(width: 5),
                                            Text(dataList[index]['robot_info']['values_str']!=''?dealMoney(dataList[index])+' USDT':'0.00',style: TextStyle(color: Colors.grey))
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
                child:  dataList2 == null || dataList2.isEmpty ?Center(child: CircularProgressIndicator()):
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
                            money ==null?Text(''):
                            money['code'] == 1?
                            Text('0.00'):
                            Text(money['data'].toString()),
                          ],
                        ),
                      ),
                      Container(
                        child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: dataList2.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                        return GestureDetector(
                           onTap: (){
                              _timer.cancel();
                              dataList2[index]['robot_info'] == null?
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,type2,dataList2[index]['id'],dataList2[index]['market_name'],'')),
                              ).then((value) => startLoop2()):
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,type2,dataList2[index]['id'],dataList2[index]['market_name'],dataList2[index]['robot_info']['id'])),
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
                                       Row(
                                          children: [
                                            Container(
                                              child: Text(dataList2[index]['market_name'],style: TextStyle(color: Colors.white),),),
                                            SizedBox(width:10),
                                            dataList2[index]['robot_info']==null?Container():
                                            dataList2[index]['robot_info']['status'] == 0 && dataList2[index]['robot_info']['show_msg'] == '卖出成功' && dataList2[index]['robot_info']['values_str'] == ''?
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.yellowAccent,
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: 
                                             
                                              Text(
                                                MyLocalizations.of(context).getData('sold')
                                                ,style: TextStyle(color: Colors.black,fontSize: 12),
                                              ),
                                            ):
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.yellowAccent,
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: 
                                             
                                              Text(
                                                dataList2[index]['robot_info']['recycle_status']==0?
                                                MyLocalizations.of(context).getData('single'):
                                                MyLocalizations.of(context).getData('cycle')
                                                ,style: TextStyle(color: Colors.black,fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: new BoxDecoration(
                                            color: Colors.yellowAccent,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: 
                                          Text(
                                            dataList2[index]['robot_info'] ==null?'0.00%':
                                            double.parse(dataList2[index]['robot_info']['revenue']).toStringAsFixed(2)+'%')
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
                                            Container(child: Text(MyLocalizations.of(context).getData('market_price')+' :',style: TextStyle(color: Colors.grey))), 
                                            SizedBox(width: 5),
                                            Container(child: Text(dataList2[index]['price'],style: TextStyle(color: Colors.grey))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('floating')+ ' :',style: TextStyle(color: Colors.grey))),
                                              SizedBox(width: 5),
                                            double.parse(dataList2[index]['change']) > 0?
                                            Text(double.parse(dataList2[index]['change']).toStringAsFixed(2)+'%',style: TextStyle(color: Colors.greenAccent)):
                                            Text(double.parse(dataList2[index]['change']).toStringAsFixed(2)+'%',style: TextStyle(color: Colors.redAccent)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    dataList2[index]['robot_info'] ==null?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('quantity')+ ' :',style: TextStyle(color: Colors.grey))), 
                                            SizedBox(width: 5),
                                            Container(child: 
                                            Text('0.00',
                                            style: TextStyle(color: Colors.grey))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('amount')+ ' :',style: TextStyle(color: Colors.grey))),
                                             SizedBox(width: 5),
                                            Text('0.00',style: TextStyle(color: Colors.grey))
                                          ],
                                        ),
                                      ],
                                    ):
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('quantity')+ ' :',style: TextStyle(color: Colors.grey))), 
                                            SizedBox(width: 5),
                                            Container(child: 
                                            Text( dataList2[index]['robot_info']['values_str']!=''?dealAmount(dataList2[index]):'0.00',
                                            style: TextStyle(color: Colors.grey))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(child: Text(MyLocalizations.of(context).getData('amount')+ ' :',style: TextStyle(color: Colors.grey))),
                                             SizedBox(width: 5),
                                            Text(dataList2[index]['robot_info']['values_str']!=''?dealMoney(dataList2[index])+' USDT':'0.00',style: TextStyle(color: Colors.grey))
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
            ],
          ),
        ),
      ),
    );
  }
}
