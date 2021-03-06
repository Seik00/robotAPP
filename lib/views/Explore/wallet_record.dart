import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';

class WalletRecord extends StatefulWidget {
  final url;

  WalletRecord(this.url);
  @override
  _WalletRecordState createState() => _WalletRecordState();

  
}
  
class _WalletRecordState extends State<WalletRecord> {
  var dataList = [];
  var language;
  var pointOne;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    if(language =='ms'){
      language = 'vn';
    }else if(language == 'id'){
      language = 'in';
    }
  }

  getRequest() async {
    var contentData = await Request()
        .getRequest(Config().url + "api/member/get-member-info", context);
    if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          pointOne = contentData['data']['point1'];
        });
      }
    }

    print(contentData);
  }

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'wallet': '1',
      };
      var uri = Uri.https(Config().url2, 'api/record/wallet-record', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
    
      setState(() {
        dataList = contentData['data']['data'];
        print(dataList);
        print('--------');
    });
  }
  
  @override
  void initState() {
    super.initState();
   initializeData();
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
                        MyLocalizations.of(context).getData('wallet_record'),
                        style: Theme.of(context).textTheme.headline1)),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                       borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff7CAAD5), Color(0xff8263CE)])
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 8,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom:5),
                        child: Text(
                          MyLocalizations.of(context).getData('my_balance'),
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text('USD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                        Padding(padding: EdgeInsets.only(left: 10.0)),
                        Container(
                          child: pointOne == null
                            ? Container(
                                child: Row(
                                children: <Widget>[
                                  SkeletonAnimation(
                                    child: Container(
                                      width: 100.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                            : Container(
                                child: Text(
                                  pointOne,
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                      ],)
                    ],
                  )
                ),
                SizedBox(height:20),
                Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(MyLocalizations.of(context).getData('wallet_record'),style: TextStyle(color: Colors.white,fontSize: 16),),
                      SizedBox(height:20),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                          margin: EdgeInsets.only(bottom:5),
                          child: ConstrainedBox(
                              constraints: new BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height/8,
                                minWidth: MediaQuery.of(context).size.width,
                                maxWidth: MediaQuery.of(context).size.width,
                              ),
                              child: new DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color(0xff5a5472),
                                ),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      child: Row(
                                        children: [
                                        dataList[index]['action'] == '-'?
                                        Container(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/withdraw.png"),
                                            height: 50,
                                            width: 50,
                                          )
                                        ):
                                        Container(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/deposit.png"),
                                            height: 50,
                                            width: 50,
                                          )
                                        ),
                                        Expanded(
                                          child:Column(
                                            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                            crossAxisAlignment: CrossAxisAlignment.start, //Center Row contents vertically,
                                            children: [
                                              Text(language == 'zh'?dataList[index]['detail']:dataList[index]['detail'+language],style: TextStyle(color:Colors.white,fontSize:14,fontWeight:FontWeight.bold),),
                                              SizedBox(height:5),
                                              Text(dataList[index]['created_at'],style: TextStyle(color:Colors.grey,fontSize:14,fontWeight:FontWeight.bold),)
                                          ],)
                                        ),
                                        SizedBox(width:20),
                                        Container(
                                          child: dataList[index]['action'] == '-'?
                                            Text(dataList[index]['action'],style: TextStyle(color:Colors.red,fontSize:20,fontWeight:FontWeight.bold)):
                                            Text(dataList[index]['action'],style: TextStyle(color:Colors.green,fontSize:20,fontWeight:FontWeight.bold)),
                                        ),
                                        Container(
                                          child:
                                            dataList[index]['action'] == '-'?
                                            Text(dataList[index]['found'],style: TextStyle(color:Colors.red,fontSize:20,fontWeight:FontWeight.bold)):
                                            Text(dataList[index]['found'],style: TextStyle(color:Colors.green,fontSize:20,fontWeight:FontWeight.bold))
                                        ),
                                        SizedBox(width:20),
                                        GestureDetector(
                                          onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                      title: Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              child:Row(children: [
                                                                  dataList[index]['action'] == '-'?
                                                                    Text(dataList[index]['action'],style: TextStyle(color:Colors.red,fontSize:20,fontWeight:FontWeight.bold)):
                                                                    Text(dataList[index]['action'],style: TextStyle(color:Colors.green,fontSize:20,fontWeight:FontWeight.bold)),
                                                                    SizedBox(width:10),
                                                                    dataList[index]['action'] == '-'?
                                                                    Text(dataList[index]['found'],style: TextStyle(color:Colors.red,fontSize:20,fontWeight:FontWeight.bold)):
                                                                    Text(dataList[index]['found'],style: TextStyle(color:Colors.green,fontSize:20,fontWeight:FontWeight.bold)),
                                                              ],)
                                                            ),
                                                            GestureDetector(
                                                              onTap: (){
                                                                Navigator.pop(context);
                                                              },
                                                              child: Icon(Icons.close))
                                                          ],
                                                        ),
                                                      ),
                                                      
                                                      content: new Wrap(
                                                        children:[
                                                          Column(
                                                            children: [
                                                             
                                                              Container(
                                                                child:Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                  Text(MyLocalizations.of(context).getData('date')),
                                                                  Text(dataList[index]['created_at']),
                                                                ],)
                                                              ),
                                                              SizedBox(height:5),
                                                              Divider(
                                                                height: 1,
                                                                color: Colors.black,
                                                              ),
                                                              SizedBox(height:5),
                                                              Container(
                                                                child:Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(child: Text(MyLocalizations.of(context).getData('previous_balance')),),
                                                                    Container(
                                                                      child: Text(dataList[index]['previous'])),
                                                                ],)
                                                              ),
                                                              SizedBox(height:5),
                                                              Divider(
                                                                height: 1,
                                                                color: Colors.black,
                                                              ),
                                                              SizedBox(height:5),
                                                              Container(
                                                                child:Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                  Text(MyLocalizations.of(context).getData('current_balance')),
                                                                  Text(dataList[index]['current'],style: TextStyle(fontWeight: FontWeight.bold),),
                                                                ],)
                                                              ),
                                                              SizedBox(height:5),
                                                              Divider(
                                                                height: 1,
                                                                color: Colors.black,
                                                              ),
                                                              SizedBox(height:5),
                                                              dataList[index]['remark'] !=null?
                                                              Container(
                                                                child:Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                  Text(MyLocalizations.of(context).getData('remark')),
                                                                  Text(dataList[index]['remark']),
                                                                ],)
                                                              ):Container(),
                                                             
                                                            ],
                                                          ),
                                                        ]
                                                      )
                                                  )
                                              );
                                          },
                                          child: Container(
                                            child:Icon(Icons.add_box_outlined,)
                                          ),
                                        )
                                        ],
                                      ),
                                    ),
                                  )
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