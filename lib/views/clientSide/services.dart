import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/apiBinding.dart';
import 'package:robot/views/Explore/buyPin.dart';
import 'package:robot/views/Explore/invest.dart';
import 'package:robot/views/Explore/pinCenter.dart';
import 'package:robot/views/Explore/revenue.dart';
import 'package:robot/views/Explore/robotPackage.dart';
import 'package:robot/views/Explore/transferPin.dart';
import 'package:robot/views/SystemSetting/invitation.dart';
import 'package:robot/views/Trade/trade.dart';
import 'package:robot/views/Trade/tradeDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Services extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Services(this.url, this.onChangeLanguage);
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services>
    with SingleTickerProviderStateMixin {

  var dataList = [];
  var robotList = [];
  Timer _timer;
  int count= 0;
  List coin;
  var btc;
  var eth;
  var ltc;
  double revenue;

  startLoop(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        // if (contentData['status']) {
            var checkApi= await getRobotList();
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

  // initializeData() async {
  //     var contentData = await Request().getRequest(Config().url + "api/market/all", context);
  //     print(contentData);
      
  //     try {
  //       if(contentData != null){
  //       if (contentData['code'] == 0) {
  //         if (this.mounted) {
  //               setState(() {
  //             coin = contentData['data']['list'][0]['ticker_list']['list'].toList();
            
  //             btc = coin.singleWhere((element) =>
  //               element['coin'] == 'BTC', orElse: () {
  //                 return null;
  //             });

  //             eth = coin.singleWhere((element) =>
  //               element['coin'] == 'ETH', orElse: () {
  //                 return null;
  //             });

  //             ltc = coin.singleWhere((element) =>
  //               element['coin'] == 'LTC', orElse: () {
  //                 return null;
  //             });

  //           });
  //         }
  //       }
  //       } 
  //       return true;
  //     } catch (e) {
       
  //       return false;
        
  //     }
     
  // }
  
  getRobotList() async {
    var contentData = await Request().getRequest(Config().url + "api/trade-robot/robotList", context);
    try {
        if(contentData != null){
          if (contentData['code'] == 0) {
              if (this.mounted) {
                setState(() {
                robotList = contentData['data'];
                if(robotList.isEmpty){
                    
                }else{
                  revenue = double.parse(robotList[0]['revenue']);
                  
                }
              });
              }
              
          }
        }
        return true;
      } catch (e) {
       
        return false;
        
      }
  }

  
 TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    // initializeData();
    startLoop();
  }

  @override
  void dispose() {
    if (_timer!=null) {
      _timer.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      backgroundColor: Color(0xff212630),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(440),
        child: Container(
          child: Wrap(
          children: [
          Container(
            child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                // color: Theme.of(context).backgroundColor,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/img/btc_bg.png'),
                    fit: BoxFit.cover
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.8),
                    border: Border.all(color:Colors.white54)),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                               _timer.cancel(),
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ApiBinding(widget.url)),
                              ).then((value) => startLoop())
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                 Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                    color: Color(0xff212630),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color:Colors.white54)),
                                   child: Image(
                                      image: AssetImage(
                                          "lib/assets/img/api_binding.png"),
                                      height: 30,
                                      width: 30,
                                    ),
                                 ),
                                SizedBox(height:5),
                                Text(MyLocalizations.of(context).getData('api_binding'),style: TextStyle(fontSize: 12),)
                              ],
                            ),
                          ),
                        ])),
                        Expanded(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              _timer.cancel(),
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PinCenter(widget.url)),
                              ).then((value) => startLoop())
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                    color: Color(0xff212630),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color:Colors.white54)),
                                   child: Image(
                                      image: AssetImage(
                                          "lib/assets/img/api_binding.png"),
                                      height: 30,
                                      width: 30,
                                    ),
                                 ),
                                 SizedBox(height:5),
                                Text(MyLocalizations.of(context).getData('pin_manage'),style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        ])),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              _timer.cancel(),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RobotPackage(widget.url)),
                              ).then((value) => startLoop())
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                    color: Color(0xff212630),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color:Colors.white54)),
                                   child: Image(
                                      image: AssetImage(
                                          "lib/assets/img/api_binding.png"),
                                      height: 30,
                                      width: 30,
                                    ),
                                 ),
                                SizedBox(height:5),
                                Text(MyLocalizations.of(context).getData('robot_package'),style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        ])),
                        // Expanded(
                        //   child: Column(children: <Widget>[
                        //   FlatButton(
                        //     onPressed: () => {
                        //       _timer.cancel(),
                        //        Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => Invitation(widget.url,widget.onChangeLanguage)),
                        //       ).then((value) => startLoop())
                        //     },
                        //     padding: EdgeInsets.all(10.0),
                        //     child: Column(
                        //       // Replace with a Row for horizontal icon + text
                        //       children: <Widget>[
                        //         Container(
                        //             padding: EdgeInsets.all(10),
                        //             decoration: BoxDecoration(
                        //             color: Color(0xff212630),
                        //             borderRadius: BorderRadius.circular(25),
                        //             border: Border.all(color:Colors.white54)),
                        //            child: Image(
                        //               image: AssetImage(
                        //                   "lib/assets/img/api_binding.png"),
                        //               height: 30,
                        //               width: 30,
                        //             ),
                        //          ),
                        //         SizedBox(height:5),
                        //         Text(MyLocalizations.of(context).getData('invite_friend'),style: TextStyle(fontSize: 12))
                        //       ],
                        //     ),
                        //   ),
                        // ])),
                        Expanded(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              _timer.cancel(),
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Revenue(widget.url,widget.onChangeLanguage)),
                              ).then((value) => startLoop())
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                    color: Color(0xff212630),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color:Colors.white54)),
                                   child: Image(
                                      image: AssetImage(
                                          "lib/assets/img/api_binding.png"),
                                      height: 30,
                                      width: 30,
                                    ),
                                 ),
                                SizedBox(height:5),
                                Text(MyLocalizations.of(context).getData('revenue'),style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        ])),
                      ]),
                )
              ),
              SizedBox(height:20),
            // Container(
            //   padding: EdgeInsets.only(left: 10, right: 10, top: 0),
            //   child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //       SizedBox(height: 20),
            //       Container(
            //         child:Text(MyLocalizations.of(context).getData('recommend'),style: TextStyle(color: Colors.white),),
            //       ),
            //       coin == null? Container(
            //         margin: EdgeInsets.only(bottom: 10),
            //         child: GridView.count(
            //           primary: false,
            //           shrinkWrap: true,
            //           crossAxisCount: 3,
            //           childAspectRatio: 1.5,
            //           crossAxisSpacing: 5.0,
            //           mainAxisSpacing: 5.0,
            //           children: [
            //             FlatButton(
            //                 onPressed: () {
            //                   setState(() {
                                
            //                   });
            //                 },
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15),
            //                   side: BorderSide(
            //                       color: Colors.grey)),
            //               child:Container(
            //                 padding: EdgeInsets.only(top:10,bottom: 5),
            //                 alignment: Alignment.topLeft,
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                          Spacer(),
            //                         Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                         Spacer(),
            //                         Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     Container(
            //                       child: Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                     )
            //                 ],),
            //               )
            //             ),
            //             FlatButton(
            //                 onPressed: () {
            //                   setState(() {
                                
            //                   });
            //                 },
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15),
            //                   side: BorderSide(
            //                       color: Colors.grey)),
            //               child:Container(
            //                 padding: EdgeInsets.only(top:10,bottom: 5),
            //                 alignment: Alignment.topLeft,
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                          Spacer(),
            //                         Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                         Spacer(),
            //                        Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     Container(
            //                       child: Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                     )
            //                 ],),
            //               )
            //             ),
            //             FlatButton(
            //                 onPressed: () {
            //                   setState(() {
                                
            //                   });
            //                 },
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15),
            //                   side: BorderSide(
            //                       color: Colors.grey)),
            //               child:Container(
            //                 padding: EdgeInsets.only(top:10,bottom: 5),
            //                 alignment: Alignment.topLeft,
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                          Spacer(),
            //                         Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                         Spacer(),
            //                         Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     Container(
            //                       child: Container(
            //                           child:  Icon(
            //                             Icons.remove,
            //                             color: Colors.grey,
            //                             size: 25,
            //                           ),
            //                         ),
            //                     )
            //                 ],),
            //               )
            //             ),
            //           ],
            //         ),
            //       ):
            //       Container(
            //         margin: EdgeInsets.only(bottom: 10),
            //         child: GridView.count(
            //           primary: false,
            //           shrinkWrap: true,
            //           crossAxisCount: 3,
            //           childAspectRatio: 1.5,
            //           crossAxisSpacing: 5.0,
            //           mainAxisSpacing: 5.0,
            //           children: [
            //             FlatButton(
            //                 onPressed: () {
            //                   setState(() {
                                
            //                   });
            //                 },
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15),
            //                   side: BorderSide(
            //                       color: Colors.grey)),
            //               child:Container(
            //                 padding: EdgeInsets.only(top:10,bottom: 5),
            //                 alignment: Alignment.topLeft,
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Container(
            //                           child: Image(
            //                             image: NetworkImage(
            //                               btc['img_url']
            //                               ),
            //                             height: 20,
            //                             width: 20,
            //                           ),
            //                         ),
            //                         Text(btc['coin'],style: TextStyle(color: Colors.grey),),
            //                       ],
            //                     ),
            //                     SizedBox(height:3),
            //                     Container(
            //                       child: Text(btc['price'],style: TextStyle(color: Colors.grey,fontSize: 16)),
            //                     ),
            //                     SizedBox(height:3),
            //                     Container(
            //                       child: 
            //                       double.parse(btc['change']) > 0?
            //                       Text(btc['change']+'%',style: TextStyle(color: Colors.greenAccent,fontSize: 16)):
            //                       Text(btc['change']+'%',style: TextStyle(color: Colors.redAccent,fontSize: 16)),
            //                     ),
                                
            //                 ],),
            //               )
            //             ),
            //             FlatButton(
            //                 onPressed: () {
            //                   setState(() {
                                
            //                   });
            //                 },
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15),
            //                   side: BorderSide(
            //                       color: Colors.grey)),
            //               child:Container(
            //                 padding: EdgeInsets.only(top:10,bottom: 5),
            //                 alignment: Alignment.topLeft,
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Container(
            //                           child: Image(
            //                             image: NetworkImage(
            //                               eth['img_url']
            //                               ),
            //                             height: 20,
            //                             width: 20,
            //                           ),
            //                         ),
            //                         Text(eth['coin'],style: TextStyle(color: Colors.grey),),
                                   
            //                       ],
            //                     ),
            //                     SizedBox(height:3),
            //                     Container(
            //                       child: Text(eth['price'],style: TextStyle(color: Colors.grey,fontSize: 16)),
            //                     ),
            //                     SizedBox(height:3),
            //                     Container(
            //                       child: 
            //                       double.parse(eth['change']) > 0?
            //                       Text(eth['change']+'%',style: TextStyle(color: Colors.greenAccent,fontSize: 16)):
            //                       Text(eth['change']+'%',style: TextStyle(color: Colors.redAccent,fontSize: 16)),
            //                     ),
            //                 ],),
            //               )
            //             ),
            //             FlatButton(
            //                 onPressed: () {
            //                   setState(() {
                                
            //                   });
            //                 },
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15),
            //                   side: BorderSide(
            //                       color: Colors.grey)),
            //               child:Container(
            //                 padding: EdgeInsets.only(top:10,bottom: 5),
            //                 alignment: Alignment.topLeft,
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Container(
            //                           child: Image(
            //                             image: NetworkImage(
            //                               ltc['img_url']
            //                               ),
            //                             height: 20,
            //                             width: 20,
            //                           ),
            //                         ),
            //                         Text(ltc['coin'],style: TextStyle(color: Colors.grey),),
            //                       ],
            //                     ),
            //                     SizedBox(height:3),
            //                     Container(
            //                       child: Text(ltc['price'],style: TextStyle(color: Colors.grey,fontSize: 16)),
            //                     ),
            //                     SizedBox(height:3),
            //                     Container(
            //                       child: 
            //                       double.parse(ltc['change']) > 0?
            //                       Text(ltc['change']+'%',style: TextStyle(color: Colors.greenAccent,fontSize: 16)):
            //                       Text(ltc['change']+'%',style: TextStyle(color: Colors.redAccent,fontSize: 16)),
            //                     ),
            //                 ],),
            //               )
            //             ),
            //           ],
            //         ),
            //       ),
            //         SizedBox(height: 10),
            //       ])),

            ],
            )
           
          ),
        ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              tabs: [
                Tab(
                  text: MyLocalizations.of(context).getData('binance'),
                ),
                Tab(
                  text: MyLocalizations.of(context).getData('huobi'),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            ),
            
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: robotList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    child: 
                    robotList[index]['platform'] == 'huobi'?Container():
                    GestureDetector(
                      // onTap: (){
                      //   Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => TradeDetails(widget.url,widget.onChangeLanguage,robotList[index]['id'],robotList[index]['first_order_value'],robotList[index]['max_order_count'],robotList[index]['stop_profit_rate'],robotList[index]['stop_profit_callback_rate'],robotList[index]['cover_rate'],robotList[index]['cover_callback_rate'],robotList[index]['recycle_status'],robotList[index]['status'])),
                      // ).then((value) => getRobotList());;
                      // },
                      onTap: (){
                      _timer.cancel();
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,robotList[index]['platform'],robotList[index]['market_id'],robotList[index]['market_name'],robotList[index]['id'])),
                      ).then((value) => startLoop());
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: new BoxDecoration(
                          color: Color(0xff595c64),
                          borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(robotList[index]['market_name'],style: TextStyle(color: Colors.white),),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      child: 
                                      robotList[index]['revenue'][0] =='-'?
                                      Text(double.parse(robotList[index]['revenue']).toStringAsFixed(5) + '%',style: TextStyle(color: Colors.redAccent),):
                                      Text(double.parse(robotList[index]['revenue']).toStringAsFixed(5) + '%',style: TextStyle(color: Colors.greenAccent),),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                            child: robotList[index]['is_clean'] == 1?
                            Text(MyLocalizations.of(context).getData('robot_clean'),style: TextStyle(color: Colors.white)):
                            robotList[index]['status'] == 0 && robotList[index]['show_msg'] == '卖出成功' && robotList[index]['values_str'] == ''?(Text(MyLocalizations.of(context).getData('sold'),style: TextStyle(color: Colors.white))):
                            robotList[index]['status'] == 0?(Text(MyLocalizations.of(context).getData('robot_pause'),style: TextStyle(color: Colors.white))):Text(MyLocalizations.of(context).getData('robot_running'),style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    }),
                  ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: robotList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    child: 
                    robotList[index]['platform'] == 'binance'?Container():
                    GestureDetector(
                      // onTap: (){
                      //   Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => TradeDetails(widget.url,widget.onChangeLanguage,robotList[index]['id'],robotList[index]['first_order_value'],robotList[index]['max_order_count'],robotList[index]['stop_profit_rate'],robotList[index]['stop_profit_callback_rate'],robotList[index]['cover_rate'],robotList[index]['cover_callback_rate'],robotList[index]['recycle_status'],robotList[index]['status'])),
                      // ).then((value) => getRobotList());;
                      // },
                      onTap: (){
                      _timer.cancel();
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,robotList[index]['platform'],robotList[index]['market_id'],robotList[index]['market_name'],robotList[index]['id'])),
                      ).then((value) => startLoop());
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: new BoxDecoration(
                          color: Color(0xff595c64),
                          borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(robotList[index]['market_name'],style: TextStyle(color: Colors.white),),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      child: 
                                      robotList[index]['revenue'][0] =='-'?
                                      Text(double.parse(robotList[index]['revenue']).toStringAsFixed(5) + '%',style: TextStyle(color: Colors.redAccent),):
                                      Text(double.parse(robotList[index]['revenue']).toStringAsFixed(5) + '%',style: TextStyle(color: Colors.greenAccent),),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                            child: robotList[index]['is_clean'] == 1?Text(MyLocalizations.of(context).getData('robot_clean'),style: TextStyle(color: Colors.white)):robotList[index]['status'] == 0?(Text(MyLocalizations.of(context).getData('robot_pause'),style: TextStyle(color: Colors.white))):Text(MyLocalizations.of(context).getData('robot_running'),style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    }),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
