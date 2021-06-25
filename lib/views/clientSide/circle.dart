import 'dart:convert';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Circle extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Circle(this.url, this.onChangeLanguage);
  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle>
    with SingleTickerProviderStateMixin {
      var dataList;
  getAllInfo() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'platform': 'binance',
        'type': 'spot',
      };
      var uri = Uri.https(Config().url2, 'api/trade-robot/marketList', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      print('----------------------');
      print(contentData);
      print('----------------------');
        setState(() {
          dataList = contentData['data'];
        });
     
  }

  

  @override
  void initState() {
    super.initState();
    getAllInfo();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              dataList==null?Container():
              Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.only(top: 5,left: 20,right: 20),
                      child: new GridView.builder(
                          itemCount: dataList.length,
                          primary: false,
                          shrinkWrap: true,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return FlatButton(
                                onPressed: () {
                                  setState(() {
                                   
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                        color: Colors.deepPurpleAccent)),
                                child:Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(dataList[index]['market_name'],style: TextStyle(color: Colors.grey),)
                                  ],),
                                )
                                    
                              );
                          })
                      ),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
