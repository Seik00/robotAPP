import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
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

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'currency': 'CNY',
      };
      var uri = Uri.https(Config().url2, 'api/market/lists', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
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
              ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: 10,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(10),
                              child: Image(
                                image: AssetImage(
                                    "lib/assets/img/me_team.png"),
                                height: 30,
                                width: 40,
                              )
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: new BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text('0%'),
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
                                Container(child: Text('Quantity')), 
                                SizedBox(width: 10),
                                Container(child: Text('0.0000')),
                              ],
                            ),
                            Row(
                              children: [
                                Container(child: Text('Income')),
                                 SizedBox(width: 10),
                                Container(child: Text('0.000')),
                              ],
                            ),
                          ],
                        ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(child: Text('Quantity')),
                                SizedBox(width: 10),
                                Container(child: Text('0.0000')),
                              ],
                            ),
                            Row(
                              children: [
                                Container(child: Text('Income')),
                                SizedBox(width: 10),
                                Container(child: Text('0.000')),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
              }),
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
