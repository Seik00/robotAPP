import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:robot/views/Explore/newsList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticDetails extends StatefulWidget {
  final url;
  final noticId;
  final rebody;

  NoticDetails(this.url,this.noticId,this.rebody);
  @override
  _NoticDetailsState createState() => _NoticDetailsState();
  
}
  
class _NoticDetailsState extends State<NoticDetails> {
  var title;
  var body;
  var time;
  var rebody;
  var retime;
  var language;
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
   
  }
   
   initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var bodyData = {
        'id': widget.noticId.toString(),
      };
      var uri = Uri.https(Config().url2, '/api/ticket/read-ticket', bodyData);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
    
      setState(() {
        title = contentData['data']['ticket']['title'];
        body = contentData['data']['ticket']['body'];
        time = contentData['data']['ticket']['created_at'];
        rebody = contentData['data']['ticket']['rebody'];
        retime = contentData['data']['ticket']['re_time'];
        print(title);
        print(body);
        print(time);
        print('--------');
        print(contentData);
    });
  }
  
  @override
  void initState() {
    super.initState();
    getLanguage();
    initializeData();
    print(widget.noticId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        MyLocalizations.of(context).getData('notification'),
                        style: Theme.of(context).textTheme.headline1)),
                SizedBox(height:20),
                title == null?
                Container():
                Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                  child: Wrap(
                          children:[
                            GestureDetector(
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
                                    child:Text(time,style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                   
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(10),
                                    child:Text(title,style: TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold),),
                                  ),
                                   Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(10),
                                    child:Text(body,style: TextStyle(color:Colors.white,fontSize:16,),),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(10),
                                    child:Text(MyLocalizations.of(context).getData('reply'),style: TextStyle(color:Colors.white,fontSize:16,),),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(10),
                                    child:Text(rebody,style: TextStyle(color:Colors.white,fontSize:16,),),
                                  ),
                                   Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.all(10),
                                    child:Text(retime,style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                  ),
                                ],
                              )
                            ),
                          ),
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
