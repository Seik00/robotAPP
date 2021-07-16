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
import 'package:robot/views/SystemSetting/invitation.dart';
import 'package:robot/views/Trade/trade.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final List<String> imgList = [
  'https://philip.greatwallsolution.com/banner1.png',
  'https://philip.greatwallsolution.com/banner2.png',
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
  var mip;
  var pip;
  double revenue; 
  var language;
  var newsList;
  var bannerList;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    if(language == 'zh'){
      language = 'cn';
    }
    initializeData();
    banner();
  }

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

  lookUp() async {
    var contentData = await Request().getWithoutRequest(Config().url + "api/global/lookup", context);
   
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          mip = contentData['data']['system']['MIP_POOL'];
          pip = contentData['data']['system']['PIP_POOL'];
           print(mip);
           print(pip);
        });
      }
    }
    }
  }

   initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'language': language.toString(),
      };
      var uri = Uri.https(Config().url2, 'api/news/news-list', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      setState(() {
        newsList = contentData['data']['data'];
    });
  }

  banner() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'language': language.toString(),
      };
      var uri = Uri.https(Config().url2, 'api/news/banner-list', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      print(contentData);
      setState(() {
        bannerList = contentData['data'];
        // print(bannerList);
        // print('--------');
    });
  }
  
 TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    // initializeData();
    startLoop();
    getLanguage();
    lookUp();
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
              gradient: LinearGradient(
                      colors: [Color(0xfffFDE323), Color(0xfffF6FB15)]),
              borderRadius: BorderRadius.circular(10),
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
                          Text('API',style: TextStyle(fontSize: 12,color: Colors.black),overflow: TextOverflow.ellipsis,)
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
                          Text('PIN',style: TextStyle(fontSize: 12,color: Colors.black),overflow: TextOverflow.ellipsis,)
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
                              builder: (context) => Invitation(widget.url,widget.onChangeLanguage)),
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
                                    "lib/assets/img/inv_friend.png"),
                                height: 18,
                                width: 18,
                              ),
                            ),
                            SizedBox(height:5),
                          Text(MyLocalizations.of(context).getData('invite_friend'),style: TextStyle(fontSize: 12,color: Colors.black),overflow: TextOverflow.ellipsis,)
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
                          Text(MyLocalizations.of(context).getData('user_guide'),style: TextStyle(fontSize: 12,color: Colors.black),overflow: TextOverflow.ellipsis,)
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
                          Text(MyLocalizations.of(context).getData('revenue'),style: TextStyle(fontSize: 12,color: Colors.black),overflow: TextOverflow.ellipsis,)
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
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: [
                      Container(
                         decoration: BoxDecoration(  
                            color: Color(0xff5dbb95), 
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xff68dbac),width: 3,)
                          ),
                        padding: EdgeInsets.only(left:10,right:10,top:5),
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MIP '+MyLocalizations.of(context).getData('prize_pool'),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                            SizedBox(height: 3,),
                            mip==null?
                            Text('0.000',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),):
                            Text(mip.toString(),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                            
                        ],),
                      ),
                      Container(
                        decoration: BoxDecoration(  
                          color: Color(0xffa2c6ff), 
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color(0xff7aabf7),width: 3,)
                        ),
                        padding: EdgeInsets.only(left:10,right:10,top:5),
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PIP '+MyLocalizations.of(context).getData('prize_pool'),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                            SizedBox(height: 3,),
                            pip==null?
                            Text('0.000',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),):
                            Text(pip,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                            
                        ],),
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
                        Expanded(child: Text(newsList==null?'':newsList[0]['title'],style: TextStyle(color:Colors.white),overflow: TextOverflow.ellipsis,))
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

