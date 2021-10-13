import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyTeam extends StatefulWidget {
   final url;
   final onChangeLanguage;

  MyTeam(this.url,this.onChangeLanguage);
  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  
  var dataList;
  var directActive;
  var directNoActive;
  var teamActive;
  var teamNoActive;
  List results=[] ;
  var language;
  bool loading = true;
  bool beyondPages = false;
  bool startLoading = false;
  var pageParams = {'current_page': 1, 'per_page': 10};
  
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    teamInfo();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (beyondPages) {
          print('pages is true');
          setState(() {
            startLoading = true;
            pageParams['current_page'] += 1;
          });
          teamInfo();
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

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
  }

  teamInfo() async {
    var contentData = await Request()
        .getRequest(Config().url + "api/team/robotTeam?page=" + pageParams['current_page'].toString(), context);
    if (contentData != null) {
      if (mounted) {
        setState(() {
          print(contentData);
          if (results == null) {
            results = contentData['data']['team_list']['data'];
          } else {
            for (var i = 0; i < contentData['data']['team_list']['data'].length; i++) {
              results.add(contentData['data']['team_list']['data'][i]);
            }
          }
          
          if (contentData['data']['team_list']['last_page'] > 1) {
            if (pageParams['current_page'] <= contentData['data']['team_list']['last_page']) {
              print('beyond is true');
              beyondPages = true;
            } else {
              beyondPages = false;
            }
          }

          directActive = contentData['data']['direct_active'];
          directNoActive = contentData['data']['direct_noactive'];
          teamActive = contentData['data']['team_active'];
          teamNoActive = contentData['data']['team_noactive'];
        });
      }
    }
  }

  // DataRow _getDataRow(result) {
  //   dataList = result.cast<String,dynamic>();
  //   return  DataRow(
  //     cells:
  //     <DataCell>[
  //       language=='zh'?
  //       DataCell(Center(child: Text(dataList['package']["package_name"]))):
  //       DataCell(Center(child: Text(dataList['package']["package_name_en"]))),
  //       DataCell(Center(child: Text(dataList["username"]))),
  //       DataCell(Center(child: Text(dataList["total_sponsor"].toString()))),
  //       //DataCell(Text(dataList["created_at"])),
  //     ],
  //   );
    
  // }

  DataRow _getDataRow(result) {
    dataList = result.cast<String, dynamic>();
    return DataRow(
      cells: <DataCell>[
        language == 'zh'
            ? DataCell(Center(
                child: Text(dataList['package']["package_name"],
                    style: TextStyle(color: Colors.black))))
            : DataCell(Center(
                child: Text(dataList['package']["package_name_en"],
                    style: TextStyle(color: Colors.black)))),
        DataCell(Container(
            width: MediaQuery.of(context).size.width / 3 - 30,
            child: Text(
              dataList["username"],
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ))),
        DataCell(Center(
            child: Text(dataList["total_sponsor"].toString(),
                style: TextStyle(color: Colors.black)))),
        //DataCell(Text(dataList["created_at"])),
      ],
    );
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
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [
            Container(
            child: SingleChildScrollView(
               controller: scrollController,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                             alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context, true)),
                          ),
                           Expanded(
                            child: 
                            Container(
                               alignment: Alignment.centerLeft,
                              child: Text(MyLocalizations.of(context).getData('my_team'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20),
                  child: Text(MyLocalizations.of(context).getData('quantitative_investment'),style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/img/team_bg.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50 / 2.0),
                        child: Container(
                          height: 150,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 200,
                            height: 50,
                            decoration:
                                ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), color: Color(0xfff6fb15)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(),
                                ),
                                child: Center(child: Text(MyLocalizations.of(context).getData('direct_quantification'))),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.only(top:20,bottom:20,left:10,right:10),
                            width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                              color: Color(0xff595c64),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(directNoActive.toString(),style: TextStyle(color: Colors.white),),
                                      Text(MyLocalizations.of(context).getData('not_active'),style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                  VerticalDivider(color: Colors.white,),
                                  Column(
                                    children: [
                                      Text(directActive.toString(),style: TextStyle(color: Colors.white),),
                                      Text(MyLocalizations.of(context).getData('active'),style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                ],
                              ),
                            ),)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50 / 2.0),
                        child: Container(
                          height: 150,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 200,
                            height: 50,
                            decoration:
                                ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), color: Color(0xfff6fb15)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(),
                                ),
                                child: Center(child: Text(MyLocalizations.of(context).getData('team_quantification'))),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.only(top:20,bottom:20,left:10,right:10),
                            width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                              color: Color(0xff595c64),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(teamNoActive.toString(),style: TextStyle(color: Colors.white),),
                                      Text(MyLocalizations.of(context).getData('not_active'),style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                  VerticalDivider(color: Colors.white,),
                                  Column(
                                    children: [
                                      Text(teamActive.toString(),style: TextStyle(color: Colors.white),),
                                      Text(MyLocalizations.of(context).getData('active'),style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                ],
                              ),
                            ),)
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                // Container(
                //   width: 200,
                //   decoration:
                //       ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), color: Color(0xfff6fb15)),
                //   child: Padding(
                //     padding: EdgeInsets.all(15),
                //     child: DecoratedBox(
                //       decoration: ShapeDecoration(
                //       shape: RoundedRectangleBorder(),
                //       ),
                //       child: Center(child: Text(MyLocalizations.of(context).getData('direct_referrals'))),
                //     ),
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.all(10),
                //   decoration: new BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child:  Container(
                //     child: DataTable(
                //       columns: [
                //         DataColumn(label: Expanded(child: Text(MyLocalizations.of(context).getData('level'),textAlign: TextAlign.center,))),
                //         DataColumn(label: Expanded(child: Text(MyLocalizations.of(context).getData('account'),textAlign: TextAlign.center,))),
                //         DataColumn(label: Expanded(child: Text(MyLocalizations.of(context).getData('team_amount'),textAlign: TextAlign.center,))),
                //         DataColumn(label: Flexible(child: Text(MyLocalizations.of(context).getData('register_date')))),
                //       ],
                //       rows:List.generate(
                //           results.length, (index) => _getDataRow(results[index])), 
                //     ),
                //   )
                // ),
                Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 10, top: 30, right: 10, left: 10),
                              padding: EdgeInsets.only(top: 15, bottom: 5),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              MyLocalizations.of(context)
                                                  .getData('level'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              MyLocalizations.of(context)
                                                  .getData('account'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              MyLocalizations.of(context)
                                                  .getData('team_amount'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              MyLocalizations.of(context)
                                                  .getData('team_sales'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: results.length+1,
                                       
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                              if (index < results.length) {
                                                return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language == 'zh'
                                                        ? results[index]
                                                                ['package']
                                                            ["package_name"]
                                                        : results[index]
                                                                ['package']
                                                            ["package_name_en"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                    child: Text(
                                                      results[index]["username"],
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    results[index]
                                                            ["total_sponsor"]
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    results[index]
                                                            ["team_sales"]
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
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
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors.black),
                                                          )
                                                        : Text(
                                                            'No More Data',
                                                            style: TextStyle(
                                                                color: Colors.white),
                                                          )
                                                    : null,
                                                  ),
                                          );
                                        })
                                  ],
                                ),
                                // child: DataTable(
                                //   columns: [
                                //     DataColumn(label: Container(child: Text(MyLocalizations.of(context).getData('level'),textAlign: TextAlign.center, style: TextStyle(color: Colors.white),))),
                                //     DataColumn(label: Container(
                                //       width: MediaQuery.of(context).size.width/3-30,
                                //       child: Text(
                                //         MyLocalizations.of(context).getData('account'),textAlign: TextAlign.center, style: TextStyle(color: Colors.white)))),
                                //     DataColumn(label: Container(child: Text(MyLocalizations.of(context).getData('team_amount'),textAlign: TextAlign.center, style: TextStyle(color: Colors.white)))),
                                //     //DataColumn(label: Flexible(child: Text(MyLocalizations.of(context).getData('register_date')))),
                                //   ],
                                //   rows:List.generate(
                                //       results.length, (index) => _getDataRow(results[index])),
                                // ),
                              )),
                          Center(
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color(0xfff6fb15)
                              ),
                              child: Center(
                                  child: Text(MyLocalizations.of(context)
                                      .getData('direct_referrals'))),
                            ),
                          ),
                        ],
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
