import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RevenueDetails extends StatefulWidget {
   final url;
   final date;

  RevenueDetails(this.url,this.date);
  @override
  _RevenueDetailsState createState() => _RevenueDetailsState();
}

class _RevenueDetailsState extends State<RevenueDetails> {
  
  var dataList;
  var todayRevenue;
  var totalRevenue;
  var specificDay;
  
  bool loading = true;
  bool beyondPages = false;
  bool startLoading = false;
  var pageParams = {'current_page': 1, 'per_page': 10};
  final scrollController = ScrollController();
 
  @override
  void initState() {
    super.initState();
    initializeData();
    revenue();
     scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (beyondPages) {
          setState(() {
            startLoading = true;
            pageParams['current_page'] += 1;
          });
          initializeData();
        } else {
          setState(() {
            startLoading = false;
          });
        }
      }
    });
  }
  
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  revenue() async {
    var contentData = await Request().getRequest(Config().url + "api/trade-revenue/revenueTotal", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          todayRevenue = contentData['data']['today_revenue'];
          totalRevenue = contentData['data']['total_revenue'];
        });
      }
    }
  }

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'page': pageParams['current_page'].toString(),
        'date': widget.date.toString(),
      };
      var uri = Uri.https(Config().url2, 'api/trade-revenue/revenueDay', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      setState(() {
        if (dataList == null) {
          dataList = contentData['data']['data']['data'];
         
        } else {
          for (var i = 0; i < contentData['data']['data']['data'].length; i++) {
            dataList.add(contentData['data']['data']['data'][i]);
          }
        }
        specificDay = contentData['data']['today_revenue'];
      });
      if (contentData['data']['data']['last_page'] > 1) {
          if (pageParams['current_page'] <= contentData['data']['data']['last_page']) {
            beyondPages = true;
          } else {
            beyondPages = false;
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
        child: Container(
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
                        child: Text(widget.date,style: TextStyle(color: Colors.white,fontSize: 20),))),
                    
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            padding: EdgeInsets.all(10),
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/img/yellow_card.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            MyLocalizations.of(context).getData('today_revenue'), 
                            style: TextStyle(
                              color:Colors.black, 
                              fontSize: 13, 
                              fontWeight: FontWeight.w500
                            )
                          ),
                          SizedBox(height: 20),
                          Text(
                            specificDay==null?'0':double.parse(specificDay).toStringAsFixed(8), 
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 15,  
                            )
                          ),
                          specificDay == null?
                          Text('??? ' + '0' +' USD',style: TextStyle(color:Colors.black,fontSize: 15)):
                          Text('??? ' + double.parse(specificDay).toStringAsFixed(5) +' USD',style: TextStyle(color:Colors.black,fontSize: 12)),
                        ],
                      ),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            MyLocalizations.of(context).getData('cumulative_profit'), 
                            style: TextStyle(
                              color:Colors.black, 
                              fontSize: 13, 
                              fontWeight: FontWeight.w500
                            )
                          ),
                          SizedBox(height: 20),
                          Text(
                            totalRevenue==null?'0':double.parse(totalRevenue).toStringAsFixed(8), 
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 15,  
                            )
                          ),
                          totalRevenue==null?
                          Text('??? ' + '0' +' USD',style: TextStyle(color:Colors.black,fontSize: 15)):
                          Text('??? ' + double.parse(totalRevenue).toStringAsFixed(5) +' USD',style: TextStyle(color:Colors.black,fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(MyLocalizations.of(context).getData('data_refresh_per_hour'),style: TextStyle(color:Colors.black,fontSize: 12)),
                        Text(MyLocalizations.of(context).getData('every_day_count'),style: TextStyle(color:Colors.black,fontSize: 12)),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20,bottom:20),
                child: dataList == null || dataList.isEmpty ? Container():
                ListView.builder(
                controller: scrollController,
                primary: false,
                shrinkWrap: true,
                itemCount: dataList.length+1,
                itemBuilder: (BuildContext ctxt, int index) {
                if (index < dataList.length) {
                  return Container(
                  child: 
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      color: Color(0xff595c64),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
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
                                height: 20,
                                width: 20,
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
                                height: 20,
                                width: 20,
                              )
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(dataList[index]['pid'],style: TextStyle(color: Colors.white,fontSize: 12))
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[400],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(MyLocalizations.of(context).getData('exchange'),style: TextStyle(color: Colors.white,fontSize: 14))
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(dataList[index]['platform'],style: TextStyle(color: Colors.white,fontSize: 14)),
                                ],
                              )
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(MyLocalizations.of(context).getData('sell_currency'),style: TextStyle(color: Colors.white,fontSize: 14))
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(dataList[index]['market'],style: TextStyle(color: Colors.white,fontSize: 14)),
                                ],
                              )
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(MyLocalizations.of(context).getData('sell_time'),style: TextStyle(color: Colors.white,fontSize: 14))
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(dataList[index]['ctime'],style: TextStyle(color: Colors.white,fontSize: 14)),
                                ],
                              )
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(MyLocalizations.of(context).getData('profit_amount'),style: TextStyle(color: Colors.white,fontSize: 14))
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  dataList[index]['revenue'].substring(0)=='-'?
                                  Text(dataList[index]['revenue'],style: TextStyle(color: Colors.redAccent,fontSize: 14)):
                                  Text(dataList[index]['revenue'],style: TextStyle(color: Colors.greenAccent,fontSize: 14)),
                                ],
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  );
                } 
                return Container(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      child: Center(
                          child: (beyondPages)
                              ? (startLoading)
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<
                                                  Color>(
                                              Color(0xfff6fb15)),
                                    )
                                  : Text(
                                      '',
                                      style: TextStyle(
                                          color: Colors.white),
                                    )
                              : null,
                            ),
                    );
                  }),
              ),
          ),
          ],
        ),
          ),
      ),
    );
  }
}
