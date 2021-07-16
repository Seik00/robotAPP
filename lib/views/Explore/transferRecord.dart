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

class TransferRecord extends StatefulWidget {
   final url;

  TransferRecord(this.url);
  @override
  _TransferRecordState createState() => _TransferRecordState();
}

class _TransferRecordState extends State<TransferRecord> {
  var type = '';
  var dataList =[];
 
  getRecord() async {
    var contentData = await Request().getRequest(Config().url + "api/wallet/wallet-tranfer-record", context);
    print(contentData);
    if(contentData != null){
      if (contentData['code'] == 0) {
          setState(() {
             dataList = contentData['data']['data'].toList();
            print(dataList);
          });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    getRecord();
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
                              child: Text(MyLocalizations.of(context).getData('transfer_record'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          
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
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Container(
                                              child: Text(
                                                MyLocalizations.of(context).getData('transfer_pin_to'),
                                                style: TextStyle(color: Colors.white,fontSize:16),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                dataList[index]['to_user']['username'],
                                                style: TextStyle(color: Colors.white,fontSize:14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Container(
                                              child: Text(
                                                MyLocalizations.of(context).getData('amount')+':',
                                                style: TextStyle(color: Colors.white,fontSize:16),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                dataList[index]['founds'].toString(),
                                                style: TextStyle(color: Colors.white,fontSize:14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Container(
                                              child: Text(
                                                MyLocalizations.of(context).getData('wallet_type')+':',
                                                style: TextStyle(color: Colors.white,fontSize:16),
                                              ),
                                            ),
                                            Container(
                                              child: 
                                              Text(
                                                dataList[index]['wallet']=='point1'?'USDT':dataList[index]['wallet']=='point2'?MyLocalizations.of(context).getData('gas'):MyLocalizations.of(context).getData('gas_pingyi'),
                                                style: TextStyle(color: Colors.white,fontSize:14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Container(
                                              child: Text(
                                                MyLocalizations.of(context).getData('time'),
                                                style: TextStyle(color: Colors.white,fontSize:16),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                dataList[index]['to_user']['created_at'],
                                                style: TextStyle(color: Colors.white,fontSize:14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
