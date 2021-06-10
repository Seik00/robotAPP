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

class NewsDetails extends StatefulWidget {
  final url;
  final noticId;
  final title;
  final description;
  final banner;
  final time;

  NewsDetails(this.url,this.noticId,this.title,this.description,this.banner,this.time);
  @override
  _NewsDetailsState createState() => _NewsDetailsState();
  
}
  
class _NewsDetailsState extends State<NewsDetails> {
  
  var language;
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
   
  }
  
  @override
  void initState() {
    super.initState();
    getLanguage();
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
                SizedBox(height:20),
                widget.title == null?
                Container():
                Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                  child: Wrap(
                          children:[
                            GestureDetector(
                            child: new DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text( MyLocalizations.of(context).getData('news'),style: TextStyle(color:Colors.black54,fontSize:20,fontWeight:FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child:Text(widget.time,style: TextStyle(color:Colors.grey,fontSize:16,fontWeight:FontWeight.bold)),
                                  ),
                                ],
                              )
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left:10,right:10),
                            child: new DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xff9957ED), Color(0xff7835E5)])
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    
                                    child: Image(
                                       fit: BoxFit.fill,
                                      image: NetworkImage(
                                        widget.banner ==null?
                                        'https://philip.greatwallsolution.com/sae.png':
                                        widget.banner),
                                      height: 250,
                                      width: MediaQuery.of(context).size.width,
                                    )
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(10),
                                    child:Text(widget.title,style: TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold),),
                                  ),
                                   Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(10),
                                    child:Text(widget.description,style: TextStyle(color:Colors.white,fontSize:16,),),
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
