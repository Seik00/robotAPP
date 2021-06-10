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
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    if(language =='ms'){
      language = 'vn';
    }else if(language == 'id'){
      language = 'in';
    }
  }

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'bonus': widget.type,
      };
      print(body);
      var uri = Uri.https(Config().url2, 'api/record/bonus-record', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
    
      setState(() {
        dataList = contentData['data']['record']['data'];
        total = contentData['data']['total'];
        print(dataList);
        print('--------');
    });
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
                      colors: [Color(0xff7CAAD5), Color(0xff8263CE)])
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 8,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(widget.type == 'static_bonus')
                      Container(
                        padding: EdgeInsets.only(bottom:5),
                        child: Text(
                          MyLocalizations.of(context).getData('static_bonus_balance'),
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                        ),
                      )
                      else if(widget.type == 'dynamic_bonus')
                      Container(
                        padding: EdgeInsets.only(bottom:5),
                        child: Text(
                          MyLocalizations.of(context).getData('dynamic_bonus_balance'),
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                        ),
                      )
                      else
                      Container(
                        padding: EdgeInsets.only(bottom:5),
                        child: Text(
                          MyLocalizations.of(context).getData('special_bonus_balance'),
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text('USD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
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
                              style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),
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
