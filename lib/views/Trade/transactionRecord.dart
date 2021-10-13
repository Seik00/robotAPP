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

class TransactionRecord extends StatefulWidget {
  final url;
  final robotID;

  TransactionRecord(this.url, this.robotID);
  @override
  _TransactionRecordState createState() => _TransactionRecordState();
}

class _TransactionRecordState extends State<TransactionRecord> {
  var type = '';
  var dataList;
  var language;
  bool beyondPages = false;
  bool startLoading = false;
  var pageParams = {'current_page': 1, 'per_page': 10};
  final scrollController = ScrollController();

  getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    print(language);
  }

  initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var body = {
      'robot_id': widget.robotID.toString(),
      'page': pageParams['current_page'].toString(),
    };
    print(body);
    var uri = Uri.https(Config().url2, 'api/trade-robot/log' , body);

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token'
    }).timeout(new Duration(seconds: 10));
    var contentData = json.decode(response.body);
    if (contentData['code'] == 0) {
      setState(() {
        if (dataList == null) {
          dataList = contentData['data']['data'];
        } else {
          for (var i = 0; i < contentData['data']['data'].length; i++) {
            dataList.add(contentData['data']['data'][i]);
          }
        }
        
        if (contentData['data']['last_page'] > 1) {
          if (pageParams['current_page'] <= contentData['data']['last_page']) {
            beyondPages = true;
          } else {
            beyondPages = false;
          }
        }
      });
    }
    print('test:$beyondPages');
  }

  @override
  void initState() {
    super.initState();
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
    initializeData();
    getLanguage();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212630),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          child: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: Theme.of(context).primaryColor,
                                        size: 35,
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context, true)),
                                ),
                              ),
                              Container(
                                  child: Text(
                                MyLocalizations.of(context).getData('log'),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              )),
                              Spacer()
                            ],
                          ),
                        ],
                      ),
                    ),
                    dataList == null
                        ? Container()
                        : MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: dataList.length+1,
                            itemBuilder: (BuildContext ctxt, int index) {
                              if(index < dataList.length){
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
                                                Text(
                                                  dataList[index]['platform'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                    language == 'zh'
                                                        ? dataList[index]
                                                            ['content']
                                                        : dataList[index]
                                                            ['content_log'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14)),
                                                SizedBox(height: 5),
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
                                                                    .white)),
                                                        Text(
                                                            dataList[index]
                                                                ['ctime'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
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
                            },
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
