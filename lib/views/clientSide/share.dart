import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/deposit.dart';
import 'package:robot/views/SystemSetting/countryRate.dart';
import 'package:robot/views/clientSide/createService.dart';
import 'package:intl/intl.dart';
import 'package:robot/views/videoPlayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_text/skeleton_text.dart';

class Share extends StatefulWidget {
  final url;

  Share(this.url);
  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  bool moreRequest = false;
  bool loading = true;
  var dataList = [];
  String path;
  String title;
  String videoTag;
  var info;
  var language;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    if(language =='ms'){
      language = 'vn';
    }
  }

  getInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/project/shareStatus", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          info = contentData['data'];
          print(contentData);
        });
      }
    }
    }
  }

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/news/video-list", context);
    print(contentData);
    if(contentData!=null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          dataList = contentData['data']['data'];
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
    getInfo();
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
          padding: EdgeInsets.only(left: 10, right: 10, top: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 32.0),
                                child: Text(
                                  MyLocalizations.of(context).getData('share'),
                                  style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GestureDetector(
                               onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CountryRate()),
                                  );
                              },
                              child: Text(MyLocalizations.of(context).getData('package_earn'),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),)
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            child:
                            Row(children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 55,),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: Color(0xff361c60),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(children: [
                                      Text(
                                        MyLocalizations.of(context)
                                            .getData('user_level'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      info == null
                                        ? Text('')
                                        : Container(
                                            child: Text(
                                              language == 'zh'?info['package_name']:info['package_name_en'],
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                    ]),
                                  ),
                              ),
                                Expanded(
                                  child: Container(
                                    constraints: BoxConstraints(
                                    minHeight: 55,),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: Color(0xff361c60),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(children: [
                                      Text(
                                        MyLocalizations.of(context)
                                            .getData('earn_share'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      info == null
                                        ? Text('')
                                        : Container(
                                            child: Text(
                                              info['static_bonus'],
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                    ]),
                                  ),
                                ),
                            ],)
                          ),
                          Container(
                            child:
                            Row(children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 55,),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                       border: Border.all(color: Colors.white),
                                        color: Color(0xff361c60),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(children: [
                                      Text(
                                        MyLocalizations.of(context)
                                            .getData('task_status'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      info==null?Text(''):
                                      Text(
                                        info['share_complete']==0? MyLocalizations.of(context).getData('not_complete'): MyLocalizations.of(context).getData('complete'),
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
                                      ),
                                    ]),
                                  ),
                              ),
                                Expanded(
                                  child: Container(
                                    constraints: BoxConstraints(
                                    minHeight: 55,),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                       border: Border.all(color: Colors.white),
                                        color: Color(0xff361c60),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(children: [
                                      Text(
                                        MyLocalizations.of(context)
                                            .getData('share_times'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        info==null?'':info['share_today'].toString(),
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                  ),
                                ),
                            ],)
                          ),
                        

                          SizedBox(height: 20),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: new GridView.builder(
                                  itemCount: dataList.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:  1,
                                    childAspectRatio: 1.4,
                                    
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return new GestureDetector(
                                      child: new Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        elevation: 5.0,
                                        child: new Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width /1,
                                                height: MediaQuery.of(context).size.height /4,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(16),topLeft: Radius.circular(16) ),
                                                    image: new DecorationImage(
                                                        image: NetworkImage(
                                                            dataList[index]['public_image_path'] ==null?
                                                            'https://philip.greatwallsolution.com/sae.png':
                                                            dataList[index]['public_image_path']),
                                                        fit: BoxFit.fill)),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left:10,right:10,top:10),
                                                child: Align(
                                                   alignment: Alignment.centerLeft,
                                                   child: Text(dataList[index]['video_name'+'_'+language] == null?dataList[index]['video_name_en']:dataList[index]['video_name'+'_'+language],style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                                )
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10),
                                                child: Align(
                                                   alignment: Alignment.centerLeft,
                                                   child: Text(dataList[index]['video_tag'+'_'+language] == null?dataList[index]['video_tag_en']:dataList[index]['video_tag'+'_'+language],style: TextStyle(color: Colors.black45),overflow: TextOverflow.ellipsis,),
                                                )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        print(dataList[index]['path']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => VideoAppPlayer(widget.url,path = dataList[index]['public_path'],dataList[index]['video_name'+'_'+language] == null?title = dataList[index]['video_name_en']:title = dataList[index]['video_name'+'_'+language],dataList[index]['video_tag'+'_'+language] == null?videoTag = dataList[index]['video_tag_en']:videoTag = dataList[index]['video_tag'+'_'+language],)),
                                        );
                                      },
                                    );
                                  })),
                        ])),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}
