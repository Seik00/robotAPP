import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:robot/views/Explore/newsDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsList extends StatefulWidget {
  final url;

  NewsList(this.url);
  @override
  _NewsListState createState() => _NewsListState();
  
}
  
class _NewsListState extends State<NewsList> {
  var dataList = [];
  var language;
  var annouceNumber;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    if(language=='zh'){
      language = 'cn';
    }
    print(language);
  }
   
   initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'language': language.toString(),
        'news_type': 1.toString(),
      };
      var uri = Uri.https(Config().url2, 'api/news/news-list', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      print(contentData);
      setState(() {
        dataList = contentData['data']['data'];
        print(dataList);
        print('--------');
    });
  }
  @override
  void initState() {
    super.initState();
    getLanguage();
    initializeData();
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
                        MyLocalizations.of(context).getData('news_list'),
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
                                        builder: (context) => NewsDetails(
                                            widget.url,dataList[index]['id'],dataList[index]['title'],dataList[index]['description'],dataList[index]['public_path'],dataList[index]['created_at'])),
                                  );
                                },
                                child: new DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xff595c64), Color(0xff595c64)])
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                          child:Row(
                                            children: [
                                                Container(
                                                margin: EdgeInsets.only(right:10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Image(
                                                  image: NetworkImage(
                                                    dataList[index]['public_path'] ==null?
                                                    'https://philip.greatwallsolution.com/sae.png':
                                                    dataList[index]['public_path']),
                                                  height: 60,
                                                  width: 60,
                                                )
                                              ),
                                              Expanded(
                                                child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text(dataList[index]['title'],style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                                  Text(dataList[index]['created_at'],style: TextStyle(color:Colors.white70,fontSize:14,fontWeight:FontWeight.bold)),
                                                ],)
                                              )
                                              
                                            ],
                                          )
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
