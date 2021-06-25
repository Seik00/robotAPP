import 'dart:convert';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Market extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Market(this.url, this.onChangeLanguage);
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market>
    with SingleTickerProviderStateMixin {

  Timer _timer;
  int count= 0;
  var dataList;

  startLoop(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        // if (contentData['status']) {
          if (this.mounted) {
            var checkApi= await getAllInfo();
         
            setState(() {
              count++;
            });
         

          if(!checkApi){
            timer.cancel();

          }
          }
      },
    );

  }

  getAllInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/market/all", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
          setState(() {
           dataList = contentData['data']['list'][0]['ticker_list']['list'];
           print(dataList);
          
          });
      }
    }
    try {
        if (this.mounted) {
            setState(() {
            });
            return true;
        }
      } catch (e) {
       
        return false;
        
      }
  }


  

  @override
  void initState() {
    super.initState();
    startLoop();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff212630),
        appBar: AppBar(
          backgroundColor: Color(0xff474c56),
        ),
        body: dataList == null || dataList.isEmpty ?Center(child: CircularProgressIndicator()):
            Container(
              child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: dataList.length,
              itemBuilder: (BuildContext ctxt, int index) {
              return GestureDetector(
                 onTap: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Trade(widget.url)),
                    // );
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(right: 5),
                                    padding: EdgeInsets.all(10),
                                    child:  Image(
                                      image: NetworkImage(
                                        dataList[index]['img_url']
                                        ),
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  Container(
                                    child: Text(dataList[index]['coin'],style: TextStyle(color: Colors.grey)),
                                  )
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(dataList[index]['change']),
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
                                  Container(child: Text('Price',style: TextStyle(color: Colors.grey),)), 
                                  SizedBox(width: 10),
                                  Container(child: Text(dataList[index]['price'],style: TextStyle(color: Colors.grey),)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(child: Text('Quantity',style: TextStyle(color: Colors.grey),)),
                                   SizedBox(width: 10),
                                  Container(child: Text(dataList[index]['volume'],style: TextStyle(color: Colors.grey),)),
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
      ),
    );
  }
}
