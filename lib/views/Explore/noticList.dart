import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:robot/views/Explore/newsList.dart';
import 'package:robot/views/Explore/noticDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticList extends StatefulWidget {
  final url;

  NoticList(this.url);
  @override
  _NoticListState createState() => _NoticListState();
  
}
  
class _NoticListState extends State<NoticList> {
  var dataList = [];
  var language;
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    print(language);
  }
   
  getNotic() async {
    var contentData = await Request().getRequest(Config().url + "api/ticket/get-ticket", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          dataList = contentData['data']['ticket'];
          print(contentData);
        });
      }
    }
    }
  }
  
  @override
  void initState() {
    super.initState();
    getLanguage();
    getNotic();
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
                Container(
                    margin: EdgeInsets.only(right:20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context, true)),
                      ],
                    ),
                  ),
                Center(
                    child: Text(
                        MyLocalizations.of(context).getData('notification_list'),
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
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => NoticDetails(
                                            widget.url,dataList[index]['id'],dataList[index]['rebody'])),
                                  );
                                },
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
                                        alignment: Alignment.topRight,
                                        padding: EdgeInsets.all(10),
                                        child:Text(dataList[index]['created_at'],style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                       
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.all(10),
                                          child:
                                            Text(dataList[index]['title'],style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                      ),
                                    ],
                                  )
                                ),
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
