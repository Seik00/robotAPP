import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:robot/views/Explore/guideDetails.dart';
import 'package:robot/views/Explore/newsDetails.dart';
import 'package:robot/views/Explore/xinwenDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';


class XinwenList extends StatefulWidget {
  @override
  _XinwenListState createState() => _XinwenListState();
}

class _XinwenListState extends State<XinwenList> {
  var dataList = [];
  var language;
  var annouceNumber;

  getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    if (language == 'zh') {
      language = 'cn';
    }
    if (language == 'vi') {
      language = 'vn';
    }
    print(language);
  }

  initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var body = {
      'language': language.toString(),
      'news_type': 5.toString(),
    };
    var uri = Uri.https(Config().url2, 'api/news/news-list', body);

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token'
    }).timeout(new Duration(seconds: 10));
    try {
      var contentData = json.decode(response.body);
      if (this.mounted) {
        setState(() {
          dataList = contentData['data']['data'];
          print(dataList);
          print('--------');
        });
      }
      print(contentData);
    } on Exception catch (e) {
      // TODO
    }
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
      extendBodyBehindAppBar: true, 
      backgroundColor: Color(0xff212630),
      appBar: PreferredSize(
          child: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Theme.of(context).primaryColor,
                                  size: 35,
                                ),
                                onPressed: () => Navigator.pop(context, true)),
                          ),
                        ),
                        Container(
                            child: Text(
                          MyLocalizations.of(context).getData('xinwen'),
                          style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                        Spacer()
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  dataList.isEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Center(
                              child: Column(
                            children: [
                              Icon(
                                Icons.content_paste_outlined,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                  MyLocalizations.of(context)
                                      .getData('no_record'),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20)),
                            ],
                          )),
                        )
                      : MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: dataList.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          child: ConstrainedBox(
                                            constraints: new BoxConstraints(
                                              minHeight: MediaQuery.of(context).size.height / 10,
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          XinwenDetails(
                                                              dataList[index]
                                                                  ['id'],
                                                              dataList[index]
                                                                  ['title'],
                                                              dataList[index][
                                                                  'description'],
                                                              dataList[index][
                                                                  'public_path'],
                                                              dataList[index][
                                                                  'created_at'])),
                                                );
                                              },
                                              child: new DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Color(0xfffFDE323), Color(0xfffF6FB15)]),
                                                      borderRadius:BorderRadius.circular(10),),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            15),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                ),
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      'lib/assets/img/icon.png'),
                                                                  height: 60,
                                                                  width: 60,
                                                                ),
                                                                // child: Image(
                                                                //   image: NetworkImage(
                                                                //     dataList[index]['public_path'] ==null?
                                                                //     'https://philip.greatwallsolution.com/sae.png':
                                                                //     dataList[index]['public_path']),
                                                                //   height: 60,
                                                                //   width: 60,
                                                                // )
                                                              ),
                                                              Expanded(
                                                                  child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    dataList[
                                                                            index]
                                                                        [
                                                                        'title'],
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Text(
                                                                      dataList[
                                                                              index]
                                                                          [
                                                                          'created_at'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black87,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ],
                                                              ))
                                                            ],
                                                          )),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        );
                                      }),
                                ]),
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
