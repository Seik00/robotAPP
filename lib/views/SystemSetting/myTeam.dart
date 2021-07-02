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

  @override
  void initState() {
    super.initState();
    teamInfo();
  }

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
  }

  teamInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/team/robotTeam", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
         print(contentData);
            results = contentData['data']['team_list']['data'];
           
            directActive = contentData['data']['direct_active'];
            directNoActive = contentData['data']['direct_noactive'];
            teamActive = contentData['data']['team_active'];
            teamNoActive = contentData['data']['team_noactive'];

           
        });
      }
    }
  }

  DataRow _getDataRow(result) {
    dataList = result.cast<String,dynamic>();
    return  DataRow(
      cells:
      <DataCell>[
        language=='zh'?
        DataCell(Center(child: Text(dataList['package']["package_name"]))):
        DataCell(Center(child: Text(dataList['package']["package_name_en"]))),
        DataCell(Center(child: Text(dataList["username"]))),
        DataCell(Center(child: Text(dataList["total_sponsor"].toString()))),
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
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.all(10),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/img/assetsbg.png"),
                      fit: BoxFit.fill,
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
                                      Text(directActive.toString(),style: TextStyle(color: Colors.white),),
                                      Text(MyLocalizations.of(context).getData('not_active'),style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                  VerticalDivider(color: Colors.white,),
                                  Column(
                                    children: [
                                      Text(directNoActive.toString(),style: TextStyle(color: Colors.white),),
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
                Container(
                  width: 200,
                  decoration:
                      ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), color: Color(0xfff6fb15)),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(),
                      ),
                      child: Center(child: Text(MyLocalizations.of(context).getData('direct_referrals'))),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Expanded(child: Text(MyLocalizations.of(context).getData('level'),textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text(MyLocalizations.of(context).getData('account'),textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text(MyLocalizations.of(context).getData('team_amount'),textAlign: TextAlign.center,))),
                        //DataColumn(label: Flexible(child: Text(MyLocalizations.of(context).getData('register_date')))),
                      ],
                      rows:List.generate(
                          results.length, (index) => _getDataRow(results[index])), 
                    ),
                  )
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
