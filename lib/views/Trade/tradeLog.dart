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

class TransactionLog extends StatefulWidget {
   final url;
   final robotId;

  TransactionLog(this.url,this.robotId);
  @override
  _TransactionLogState createState() => _TransactionLogState();
}

class _TransactionLogState extends State<TransactionLog> {
  var type = '';
  var dataList =[];
 
  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'robot_id': widget.robotId.toString(),
      };
      print(body);
      var uri = Uri.https(Config().url2, 'api/trade-robot/log', body);
   
      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      print(contentData);
      setState(() {
        dataList = contentData['data']['data'];
      });
  }


  @override
  void initState() {
    super.initState();
    initializeData();
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
        child: Stack(
          children: [
            Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
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
                              child: Text('Log',style: TextStyle(color: Colors.white,fontSize: 28),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: dataList.length,
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
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(dataList[index]['platform'],style: TextStyle(color: Colors.white),),
                                  Text(dataList[index]['ctime'],style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              SizedBox(height:10),
                              Text(dataList[index]['content'],style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                  }),
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
