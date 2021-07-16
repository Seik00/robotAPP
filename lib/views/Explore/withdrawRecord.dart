import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawRecord extends StatefulWidget {
  final url;
 

  WithdrawRecord(this.url);
  @override
  _WithdrawRecordState createState() => _WithdrawRecordState();

  
}
  
class _WithdrawRecordState extends State<WithdrawRecord> {
  var dataList = [];
  var language;
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
   
  }

   getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/wallet/withdraw-record", context);
    if(contentData!= null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          dataList = contentData['data']['data'];
          print(dataList);
          print('------------------------------');
        });
      }
    }
    }
  }

 
  
  @override
  void initState() {
    super.initState();
    getLanguage();
    getRequest();
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
      body: Stack(
        children: [
          Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                onPressed: () => Navigator.pop(context)),
                Center(
                    child: Text(
                        MyLocalizations.of(context).getData('withdraw_record'),
                        style: Theme.of(context).textTheme.headline1)),
                SizedBox(height:20),
                dataList.isEmpty?
                Container(
                  margin: EdgeInsets.only(top:40),
                  child: Center(
                    child: Column(children: [
                      Icon(Icons.content_paste_outlined,size: 50,color: Colors.white,),
                      Text(MyLocalizations.of(context).getData('no_record'),style:TextStyle(color: Colors.white,fontSize: 20)),
                    ],)
                   
                  ),
                ):
                Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xfffFDE323), Color(0xfffF6FB15)])
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(MyLocalizations.of(context).getData('withdraw_usdt'),style: TextStyle(color:Colors.black,fontSize:16)),
                                      ),
                                      Container(
                                        child: Text(dataList[index]['created_at'],style: TextStyle(color:Colors.black,fontSize:14)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text('-'+dataList[index]['amount'] + ' USDT',style: TextStyle(color:Colors.black,fontSize:20,fontWeight:FontWeight.bold)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              margin: EdgeInsets.only(bottom:30),
                          child: ConstrainedBox(
                              constraints: new BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height/8,
                                minWidth: MediaQuery.of(context).size.width,
                                maxWidth: MediaQuery.of(context).size.width,
                              ),
                              child: new DecoratedBox(
                                 decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xfffFDE323), Color(0xfffF6FB15)])
                                      ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('amount'),style: TextStyle(color:Colors.black,fontSize:16,fontWeight:FontWeight.bold)),
                                          Text('-'+dataList[index]['amount']+' USDT',style: TextStyle(color:Colors.black,fontSize:16,fontWeight:FontWeight.bold)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                     Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('status'),style: TextStyle(color:Colors.black,fontSize:16,)),
                                          if(dataList[index]['status'] == 0)
                                          Text(MyLocalizations.of(context).getData('pending'),style: TextStyle(color:Colors.black,fontSize:16,fontWeight:FontWeight.bold)),

                                          if(dataList[index]['status'] == 1)
                                          Text(MyLocalizations.of(context).getData('approved'),style: TextStyle(color:Colors.lightBlue,fontSize:16,fontWeight:FontWeight.bold)),

                                          if(dataList[index]['status'] == 2)
                                          Text(MyLocalizations.of(context).getData('success'),style: TextStyle(color:Colors.greenAccent,fontSize:16,fontWeight:FontWeight.bold)),

                                           if(dataList[index]['status'] == 3)
                                          Text(MyLocalizations.of(context).getData('rejected'),style: TextStyle(color:Colors.redAccent,fontSize:16,fontWeight:FontWeight.bold)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('link_name'),style: TextStyle(color:Colors.black,fontSize:16)),
                                          SizedBox(width:10),
                                          Flexible(child: Text('TRC20',style: TextStyle(color:Colors.black,fontSize:16),textAlign: TextAlign.right,)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('address'),style: TextStyle(color:Colors.black,fontSize:16)),
                                          SizedBox(width:10),
                                          Flexible(child: Text(dataList[index]['address'],style: TextStyle(color:Colors.black,fontSize:16,),textAlign: TextAlign.right,)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('fees'),style: TextStyle(color:Colors.black,fontSize:16)),
                                          SizedBox(width:10),
                                          Flexible(child: Text(dataList[index]['fee']+' USDT',style: TextStyle(color:Colors.black,fontSize:16,),textAlign: TextAlign.right,)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('reached_amount'),style: TextStyle(color:Colors.black,fontSize:16)),
                                          Text(dataList[index]['get_amount']+' USDT',style: TextStyle(color:Colors.black,fontSize:16)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('date'),style: TextStyle(color:Colors.black,fontSize:16)),
                                          Text(dataList[index]['created_at'],style: TextStyle(color:Colors.black,fontSize:16)),
                                        ]
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                            )
                          ],
                        );
                        }),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}
