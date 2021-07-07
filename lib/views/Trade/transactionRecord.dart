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

  TransactionRecord(this.url,this.robotID);
  @override
  _TransactionRecordState createState() => _TransactionRecordState();
}

class _TransactionRecordState extends State<TransactionRecord> {
  var type = '';
  var dataList;
  var language;
  
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    print(language);
  }

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'robot_id': widget.robotID.toString(),
      };
      print(body);
      var uri = Uri.https(Config().url2, 'api/trade-robot/log', body);
   
      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
        print(contentData);
      if (contentData['code'] == 0) {
        setState(() {
           dataList = contentData['data']['data'];
      
        });
      }
      
  }


  @override
  void initState() {
    super.initState();
    initializeData();
    getLanguage();
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
                              child: Text(MyLocalizations.of(context).getData('log'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                dataList==null?Container():
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
                          child: ExpansionTile(
                            title: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dataList[index]['platform'],style: TextStyle(color: Colors.white,fontSize: 18),),
                                  SizedBox(height:5),
                                  Text(
                                    language=='zh'?
                                    dataList[index]['content']:
                                    dataList[index]['conteant_log']
                                    ,style: TextStyle(color: Colors.white,fontSize: 14)),
                                  SizedBox(height:5),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height:10),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('order_time'),style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['ctime'],style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                  SizedBox(height:5),
                                ],
                              ),
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
