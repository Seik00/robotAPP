import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Explore/apiBindingForm.dart';
import 'package:robot/views/Explore/investRecord.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllTransactionRecord extends StatefulWidget {
  final url;
  final robotID;

  AllTransactionRecord(this.url, this.robotID);
  @override
  _AllTransactionRecordState createState() => _AllTransactionRecordState();
}

class _AllTransactionRecordState extends State<AllTransactionRecord> {
  final scrollController = ScrollController();
  var type = '';
  var dataList;
  bool loading = true;
  bool beyondPages = false;
  bool startLoading = false;
  var pageParams = {'current_page': 1, 'per_page': 10};

  @override
  void initState() {
    super.initState();
    getRequest();
    scrollController.addListener(() {
      print('qqqqq');
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (beyondPages) {
          setState(() {
            startLoading = true;
            pageParams['current_page'] += 1;
          });
          getRequest();
           print(pageParams['current_page']);
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

  getRequest() async {
    var contentData = await Request().getRequest(Config().url +"api/trade-revenue/tradeOrder?page=" +pageParams['current_page'].toString(),context);
    if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          loading = false;
          if (dataList == null) {
            dataList = contentData['data']['data'];
          } else {
            for (var i = 0; i < contentData['data']['data'].length; i++) {
              dataList.add(contentData['data']['data'][i]);
            }
          }

          print(contentData['data']['current_page']);
        });
        if (contentData['data']['last_page'] > 1) {
          if (pageParams['current_page'] <= contentData['data']['last_page']) {
            beyondPages = true;
            print('123123');
          } else {
            beyondPages = false;
            print('ccccccccccccc');
          }
        }
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
                child: Row(
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
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              MyLocalizations.of(context)
                                  .getData('transaction_details'),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ))),
                  ],
                ),
              ),
              dataList == null
                  ? Container()
                  : Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: dataList.length+1,
                          itemBuilder: (BuildContext ctxt, int index) {
                            if (index < dataList.length) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                  color: Color(0xff595c64),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: ExpansionTile(
                                        title: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  dataList[index]['platform'] ==
                                                          'binance'
                                                      ? Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Image(
                                                            image: AssetImage(
                                                                "lib/assets/img/BNB.png"),
                                                            height: 15,
                                                            width: 15,
                                                          ))
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Image(
                                                            image: AssetImage(
                                                                "lib/assets/img/HT.png"),
                                                            height: 15,
                                                            width: 15,
                                                          )),
                                                  Text(
                                                    dataList[index]['market'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                  double.parse(dataList[index]
                                                          ['price'])
                                                      .toStringAsFixed(5),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18)),
                                              SizedBox(height: 5),
                                              Text(
                                                  MyLocalizations.of(context)
                                                          .getData(
                                                              'deal_price') +
                                                      ' (USDT)',
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          MyLocalizations.of(
                                                                  context)
                                                              .getData(
                                                                  'order_time'),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                      Text(
                                                          dataList[index]
                                                              ['ctime'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                    ],
                                                  )),
                                              SizedBox(height: 5),
                                              Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          MyLocalizations.of(
                                                                  context)
                                                              .getData(
                                                                  'deal_money'),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                      Text(
                                                          double.parse(dataList[
                                                                      index][
                                                                  'deal_money'])
                                                              .toStringAsFixed(
                                                                  8),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                    ],
                                                  )),
                                              SizedBox(height: 5),
                                              Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          MyLocalizations.of(
                                                                  context)
                                                              .getData(
                                                                  'deal_amount'),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                      Text(
                                                          dataList[index]
                                                              ['deal_amount'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                    ],
                                                  )),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xfff6fb15)),
                                            )
                                          : Text(
                                              'No More Data',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                      : null),
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
