import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/depositRecord.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;

class UploadRecord extends StatefulWidget {
  final url;
  final onChangeLanguage;

  UploadRecord(this.url, this.onChangeLanguage);

  @override
  _UploadRecordState createState() => _UploadRecordState();
}

class DetailScreen extends StatelessWidget {
  DetailScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          //child: Text('wid'),
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              'https://philip.greatwallsolution.com/uploaded/2020-11-15/IMG-20201114-WA0001.jpg',
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _UploadRecordState extends State<UploadRecord> {
  var dataList = [];

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/project/get-share-record", context);
    if(contentData!=null){
      if (contentData['code'] == 0) {
        print(contentData);
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
    getRequest();
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
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
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
                        onPressed: () => Navigator.pop(context, true)), 
                  Center(
                    child: Container(
                      child: Text(
                        MyLocalizations.of(context).getData('upload'),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.2)
                      ),
                      child: Column(children: [
                          dataList == null ?Text(MyLocalizations.of(context).getData('no_record')):
                  Container(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(bottom:20),
                          child: Text(
                            MyLocalizations.of(context).getData('history_record'),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
                                  color: Color(0xffacb0c1),
                                ),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Navigator.push(context, MaterialPageRoute(builder: (_) {
                                            //   return DetailScreen();
                                            // }));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context).size.width / 4,
                                            height: MediaQuery.of(context).size.height / 8,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(6.0)),
                                                image: new DecorationImage(
                                                    image: NetworkImage(dataList[index]['public_image_path'][0]['public_image_path']),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                        SizedBox(width:20),
                                        Container(
                                          child:
                                            Text(dataList[index]['created_at'],style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                                        ),
                                        
                                        SizedBox(width:20),
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
                      ],),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
