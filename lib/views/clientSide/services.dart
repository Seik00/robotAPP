import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/apiBinding.dart';
import 'package:robot/views/Explore/newsList.dart';
import 'package:robot/views/Explore/pinCenter.dart';
import 'package:robot/views/Explore/revenue.dart';
import 'package:robot/views/Explore/robotPackage.dart';
import 'package:robot/views/Trade/trade.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  'https://philip.greatwallsolution.com/btc_bg.png',
  'https://philip.greatwallsolution.com/btc_bg.png',
  'https://philip.greatwallsolution.com/btc_bg.png',
];

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

  final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.fitHeight, width: 1000.0,),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Color.fromARGB(200, 0, 0, 0),
                          //     Color.fromARGB(0, 0, 0, 0)
                          //   ],
                          //   begin: Alignment.bottomCenter,
                          //   end: Alignment.topCenter,
                          // ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        // child: Text(
                        //   'No. ${imgList.indexOf(item)} image',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 20.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
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
        child: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
        ),
        preferredSize: Size.fromHeight(0),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left:10,right:10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child:CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  ),  
                ),
                Container(
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
                      padding: EdgeInsets.all(8.0),
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
                                height: 18,
                                width: 18,
                              ),
                            ),
                          SizedBox(height:5),
                          Text(MyLocalizations.of(context).getData('api_binding'),style: TextStyle(fontSize: 12,color: Colors.white),)
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
                      padding: EdgeInsets.all(8.0),
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
                                    "lib/assets/img/pin_manage.png"),
                                height: 18,
                                width: 18,
                              ),
                            ),
                            SizedBox(height:5),
                          Text(MyLocalizations.of(context).getData('pin_manage'),style: TextStyle(fontSize: 12,color: Colors.white))
                        ],
                      ),
                    ),
                  ])),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                    FlatButton(
                      onPressed: () => {
                        // _timer.cancel(),
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => RobotPackage(widget.url)),
                        // ).then((value) => startLoop())
                      },
                     padding: EdgeInsets.all(8.0),
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
                                    "lib/assets/img/robot_package.png"),
                                height: 18,
                                width: 18,
                              ),
                            ),
                          SizedBox(height:5),
                          Text(MyLocalizations.of(context).getData('user_guide'),style: TextStyle(fontSize: 12,color: Colors.white))
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
                              builder: (context) => Revenue(widget.url,widget.onChangeLanguage)),
                        ).then((value) => startLoop())
                      },
                      padding: EdgeInsets.all(8.0),
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
                                    "lib/assets/img/revenue.png"),
                                height: 18,
                                width: 18,
                              ),
                            ),
                          SizedBox(height:5),
                          Text(MyLocalizations.of(context).getData('revenue'),style: TextStyle(fontSize: 12,color: Colors.white))
                        ],
                      ),
                    ),
                  ])),
                ]),
            ),
            SizedBox(height:10),
            Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: [
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              
                            });
                          },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Colors.grey)),
                        child:Container(
                          padding: EdgeInsets.only(top:10,bottom: 5),
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(MyLocalizations.of(context).getData('prize_pool'),style: TextStyle(color: Colors.grey),),
                               SizedBox(height: 3,),
                              Text('0.00',style: TextStyle(color: Colors.white,fontSize: 16),),
                              
                          ],),
                        )
                      ),
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              
                            });
                          },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Colors.grey)),
                        child:Container(
                          padding: EdgeInsets.only(top:10,bottom: 5),
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(MyLocalizations.of(context).getData('prize_pool'),style: TextStyle(color: Colors.grey),),
                              SizedBox(height: 3,),
                              Text('0.00',style: TextStyle(color: Colors.white,fontSize: 16),),
                              
                          ],),
                        )
                      ),
                    ],
                  ),
                ),
                ])),
              Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color:Colors.white54)),
                    child: Row(
                      children: [
                        Icon(Icons.announcement,color: Colors.white,),
                        SizedBox(width:5),
                        Expanded(child: Text('ddsddsddsddsddsddsddsddsddsddsddsddsddsdsd',style: TextStyle(color:Colors.white),overflow: TextOverflow.ellipsis,))
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                   onTap: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsList(widget.url)),
                      ).then((value) => startLoop());
                    });
                  },
                  child: Container(child: Icon(Icons.notifications,color: Color(0xfff6fb15),),))
              ],
            ),
              SizedBox(height:10),
              Container(
                height: 40,
                padding: EdgeInsets.all(4),
                decoration: new BoxDecoration(
                  color:Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelStyle: TextStyle(fontSize:10),
                  labelStyle: TextStyle(fontSize:13),
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
                    Container(
                      child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: robotList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                        child: robotList[index]['platform'] == 'huobi'?Container():
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
                                robotList[index]['status'] == 0 && robotList[index]['show_msg'] == 'εεΊζε' && robotList[index]['values_str'] == ''?(Text(MyLocalizations.of(context).getData('sold'),style: TextStyle(color: Colors.white))):
                                robotList[index]['status'] == 0?(Text(MyLocalizations.of(context).getData('robot_pause'),style: TextStyle(color: Colors.white))):Text(MyLocalizations.of(context).getData('robot_running'),style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                        }),
                    ),
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
          )
        ],
      )
    );
  }
}

