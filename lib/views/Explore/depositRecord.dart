import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DepositRecord extends StatefulWidget {
  final url;
 

  DepositRecord(this.url);
  @override
  _DepositRecordState createState() => _DepositRecordState();

  
}
  
class _DepositRecordState extends State<DepositRecord> {
  var dataList = [];
  var language;
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
   
  }

   getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/wallet/deposit-record", context);
    if(contentData!= null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          dataList = contentData['data']['data'];
          print(dataList);
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/img/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                        MyLocalizations.of(context).getData('deposit_record'),
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
                        return Container(
                          margin: EdgeInsets.only(bottom:15),
                          child: ConstrainedBox(
                              constraints: new BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height/8,
                                minWidth: MediaQuery.of(context).size.width,
                                maxWidth: MediaQuery.of(context).size.width,
                              ),
                              child: new DecoratedBox(
                                 decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xff9957ED), Color(0xff7835E5)])
                                      ),
                                child: Column(
                                  children: [
                                     Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('status'),style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                          if(dataList[index]['status'] == 0)
                                          Text(MyLocalizations.of(context).getData('pending'),style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),

                                          if(dataList[index]['status'] == 1)
                                          Text(MyLocalizations.of(context).getData('approved'),style: TextStyle(color:Colors.greenAccent,fontSize:16,fontWeight:FontWeight.bold)),

                                          if(dataList[index]['status'] == 2)
                                          Text(MyLocalizations.of(context).getData('rejected'),style: TextStyle(color:Colors.redAccent,fontSize:16,fontWeight:FontWeight.bold)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('amount'),style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                          Text('USD '+dataList[index]['amount'],style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('paid_amount'),style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                          Text(dataList[index]['country']['short_form']+' '+dataList[index]['pay_amount'],style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                        ]
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('date'),style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                          Text(dataList[index]['created_at'],style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                        ]
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
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
