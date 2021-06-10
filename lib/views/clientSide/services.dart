import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
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


  initializeData() async {
      var body = {
        'currency': 'CNY',
      };
      
      var uri = Uri.https(Config().url2, 'api/market/lists', body);
       print(uri);
      var response = await http.get(uri, headers: {
      
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      print(contentData);
        setState(() {
          //dataList = contentData['data'];
        });
     
  }
  
  
 TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    initializeData();
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
                    image: AssetImage('lib/assets/img/assetsbg.png'),
                    fit: BoxFit.cover
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color:Colors.white54)),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                Text("签到")
                              ],
                            ),
                          ),
                        ])),
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                Text("签到")
                              ],
                            ),
                          ),
                        ])),
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                Text("签到")
                              ],
                            ),
                          ),
                        ])),
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                Text("签到")
                              ],
                            ),
                          ),
                        ])),
                      ]),
                )
              ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      child:Text('Recommend',style: TextStyle(color: Colors.white),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: GridView.count(
                        primary: false,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xff361c60),
                                  border: Border.all(width:1,color:Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      MyLocalizations.of(context).getData('today_income'),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            'USD',
                                            style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    
                                      ])
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xff361c60),
                                  border: Border.all(width:1,color:Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      MyLocalizations.of(context).getData('total_income'),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,color: Colors.white,),
                                    ),
                                  ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            'USD',
                                            style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      
                                      ])
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ])),

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
                  text: 'Binance',
                ),
                Tab(
                  text: 'Huobi',
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            ),
            
            Expanded(
              child: TabBarView(
                children: [
                  Container(child: Center(child: Text('Binance',style: TextStyle(color: Colors.white),))),
                  Container(child: Center(child: Text('Huobi',style: TextStyle(color: Colors.white)))),
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
