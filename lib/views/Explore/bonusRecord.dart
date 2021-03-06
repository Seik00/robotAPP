import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BonusRecord extends StatefulWidget {
  final url;
  String type;
 

  BonusRecord(this.url,this.type);
  @override
  _BonusRecordState createState() => _BonusRecordState();

  
}
  
class _BonusRecordState extends State<BonusRecord> {
  var dataList = [];
  var total;
  var language;
  bool loading = true;
  bool beyondPages = false;
  bool startLoading = false;
  var pageParams = {'current_page': 1, 'per_page': 10};
  final scrollController = ScrollController();

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
  }

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'page': pageParams['current_page'].toString(),
        'bonus': widget.type,
      };
      print(body);
      var uri = Uri.https(Config().url2, 'api/record/bonus-record', body);
      print(uri);
      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
    
      setState(() {
        loading = false;
        if (dataList == null) {
          dataList = contentData['data']['record']['data'];
        } else {
          for (var i = 0; i < contentData['data']['record']['data'].length; i++) {
            dataList.add(contentData['data']['record']['data'][i]);
          }
        }
        total = contentData['data']['total'];
        print(dataList);
        print('--------');
      });
      if (contentData['data']['record']['last_page'] > 1) {
        if (pageParams['current_page'] <= contentData['data']['record']['last_page']) {
          beyondPages = true;
          print('123123');
        } else {
          beyondPages = false;
          print('ccccccccccccc');
        }
      }
  }
  
  @override
  void initState() {
    super.initState();
   initializeData();
   getLanguage();
   scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (beyondPages) {
          setState(() {
            startLoading = true;
            pageParams['current_page'] += 1;
          });
          initializeData();
          // print(pageParams['current_page']);
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
      body: Container(
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
                  MyLocalizations.of(context).getData(widget.type),
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
                colors: [Color(0xfff9f21a), Color(0xfff9f21a)])
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 8,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(widget.type == 'sponsor_bonus')
                Container(
                  padding: EdgeInsets.only(bottom:5),
                  child: Text(
                    MyLocalizations.of(context).getData('sponsor_bonus_balance'),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                )
                else if(widget.type == 'dynamic_bonus')
                Container(
                  padding: EdgeInsets.only(bottom:5),
                  child: Text(
                    MyLocalizations.of(context).getData('dynamic_bonus_balance'),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                )
                else if(widget.type == 'global_bonus')
                Container(
                  padding: EdgeInsets.only(bottom:5),
                  child: Text(
                    MyLocalizations.of(context).getData('global_bonus_balance'),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                )
                else
                Container(
                  padding: EdgeInsets.only(bottom:5),
                  child: Text(
                    MyLocalizations.of(context).getData('special_bonus_balance'),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('USD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  total == null
                  ? Container(
                      child: Row(
                      children: <Widget>[
                        Text('')
                      ],
                    ))
                  : Container(
                      child: Text(
                        total.toString(),
                        style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ],)
              ],
            )
          ),
          SizedBox(height:20),
          dataList == null?
          Container(
            margin: EdgeInsets.only(top:40),
            child: Center(
              child: Column(children: [
                Icon(Icons.content_paste_outlined,size: 50,color: Colors.white,),
                Text(MyLocalizations.of(context).getData('no_record'),style:TextStyle(color: Colors.white,fontSize: 20)),
              ],)
             
            ),
          ):
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              primary: false,
              shrinkWrap: true,
              itemCount: dataList.length+1,
              itemBuilder: (BuildContext ctxt, int index) {
              if (index < dataList.length) {
                return Container(
                margin: EdgeInsets.only(bottom:5),
                padding: EdgeInsets.only(left:10,right:10),
                child: ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height/8,
                      minWidth: MediaQuery.of(context).size.width,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: new DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xff595c64),
                      ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left:10,right: 10),
                            child: Row(
                              children: [
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
                                child:Text(dataList[index]['current'],style: TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold)),
                              ),
                              ],
                            ),
                          ),
                        )
                      ],
                      )
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
                                    AlwaysStoppedAnimation<Color>(
                                        Color(0xfff6fb15)),
                              )
                            : Text(
                                '',
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
    );
  }
}
