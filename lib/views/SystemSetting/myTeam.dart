import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/LoginPage/registerStepOne.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:http/http.dart' as http;
import 'package:robot/views/SystemSetting/Node.dart';


class MyTeam extends StatefulWidget {
  final url;
  final onChangeLanguage;
  String refId;

  MyTeam(this.url, this.onChangeLanguage,this.refId);
  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {

  var dataList;
  var userId;
  var otherUserId;
  var language;
  var package;
  var username;
  var totalSponsor;
  var active;
  var team;
  var userInfo;
  var otp;
  var mobileNumber;
  var usernametop;
  
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
   
  }

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          print(contentData);
          
          userId = contentData['data']['id'].toString();
          usernametop = contentData['data']['id'].toString();
          username = contentData['data']['username'];
          totalSponsor = contentData['data']['total_sponsor'].toString();
          active = contentData['data']['active_downline'].toString();
          team = contentData['data']['team'].toString();
          package = contentData['data']['package'];
        });
        initializeData();
      }
    }
    }
  }

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'parent': userId.toString(),
      };
      var uri = Uri.https(Config().url2, 'api/team/downline-new', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      print('----------------------');
      print(contentData);
      print('----------------------');
        setState(() {
          dataList = contentData['data'];
        });
     
  }

  checkDetails(otherUserId){
    setState(() {
       userId = otherUserId.toString();
       print(otherUserId);
       print('=====2');
    });
    initializeData();
  }

  @override
  void initState() {
    super.initState();
    getRequest();
    getLanguage();
    print(otherUserId);
  }


  TextEditingController usernameController = TextEditingController();
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
              child:SingleChildScrollView(
                child: Column(
                  children: [
                  Container(
                    padding: EdgeInsets.only(top:10,right:20),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                            ),
                          onPressed: () => Navigator.pop(context)),
                         GestureDetector(
                          onTap: (){
                            setState(() {
                              otherUserId = null;
                              getRequest();
                            });
                          },
                          child:Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                            color: Color(0xff361c60),
                            border: Border.all(width:1,color:Colors.white),
                            borderRadius: BorderRadius.circular(6)),
                            alignment: Alignment.bottomRight,
                            child: 
                            Text(MyLocalizations.of(context).getData('top'),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                        )
                      ],
                    ),
                  ),
                  Center(
                      child: Text(
                          MyLocalizations.of(context).getData('my_team'),
                          style: Theme.of(context).textTheme.headline1)),
                  SizedBox(height:20),
                    userId == null?Container():
                      Container(
                            margin: EdgeInsets.only(bottom:5),
                            child: ConstrainedBox(
                                constraints: new BoxConstraints(
                                  minHeight: MediaQuery.of(context).size.height/8,
                                  minWidth: MediaQuery.of(context).size.width,
                                  maxWidth: MediaQuery.of(context).size.width,
                                ),
                                child: new DecoratedBox(
                                  decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10),
                                      // gradient: LinearGradient(
                                      // begin: Alignment.topCenter,
                                      // end: Alignment.bottomCenter,
                                      // colors: [Color(0xff9957ED), Color(0xff7835E5)])
                                  ),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    otherUserId == null?
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left:10,right: 10),
                                        child: Row(
                                          children: [
                                          Container(
                                            margin: EdgeInsets.only(right:10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Colors.white.withOpacity(0.2)
                                            ),
                                            child: Image(
                                              image: NetworkImage(
                                                package ==null?
                                                'https://philip.greatwallsolution.com/sae.png':
                                                package['public_image_path']),
                                              height: 60,
                                              width: 60,
                                            )
                                          ),
                                          Expanded(
                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                              crossAxisAlignment: CrossAxisAlignment.start, //Center Row contents vertically,
                                              children: [
                                                username == null ?Container():
                                                Text(username,style: TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.bold),),
                                                SizedBox(height:5),
                                                language == 'zh'?
                                                Text(package['package_name'],style: TextStyle(color:Colors.grey,fontSize:14,fontWeight:FontWeight.bold),):
                                                Text(package['package_name_en'],style: TextStyle(color:Colors.grey,fontSize:14,fontWeight:FontWeight.bold),)
                                            ],)
                                          ),
                                          SizedBox(width:20),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(MyLocalizations.of(context).getData('sponsor_amount'),style: TextStyle(color: Colors.white),),
                                                  SizedBox(width:10),
                                                  totalSponsor == null?Container():
                                                  Text(totalSponsor,style: TextStyle(color:Colors.greenAccent,fontSize:20,fontWeight:FontWeight.bold)),
                                                  SizedBox(width:20),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(MyLocalizations.of(context).getData('team_amount'),style: TextStyle(color: Colors.white),),
                                                  SizedBox(width:10),
                                                  team == null?Container():
                                                  Text(team,style: TextStyle(color:Colors.greenAccent,fontSize:20,fontWeight:FontWeight.bold)),
                                                  SizedBox(width:20),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(MyLocalizations.of(context).getData('active_amount'),style: TextStyle(color: Colors.white),),
                                                  SizedBox(width:10),
                                                  active == null?Container():
                                                  Text(active,style: TextStyle(color:Colors.greenAccent,fontSize:20,fontWeight:FontWeight.bold)),
                                                  SizedBox(width:20),
                                                ],
                                              ),
                                            ],
                                          ),
                                         
                                          ],
                                        ),
                                      ),
                                    ):
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left:10,right: 10),
                                        child: Row(
                                          children: [
                                          Container(
                                            margin: EdgeInsets.only(right:10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Colors.white.withOpacity(0.2)
                                            ),
                                            child: Image(
                                              image: NetworkImage(
                                                userInfo[3]
                                              ),
                                              height: 60,
                                              width: 60,
                                            )
                                          ),
                                          Expanded(
                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                              crossAxisAlignment: CrossAxisAlignment.start, //Center Row contents vertically,
                                              children: [
                                                userInfo == null ?Container():
                                                Text(userInfo[0],style: TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.bold),),
                                                SizedBox(height:5),
                                                Text(userInfo[1],style: TextStyle(color:Colors.grey,fontSize:14,fontWeight:FontWeight.bold),)
                                            ],)
                                          ),
                                           Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(MyLocalizations.of(context).getData('sponsor_amount'),style: TextStyle(color: Colors.white),),
                                                  SizedBox(width:10),
                                                  userInfo == null?Container():
                                                  Text(userInfo[2].toString(),style: TextStyle(color:Colors.greenAccent,fontSize:20,fontWeight:FontWeight.bold)),
                                                  SizedBox(width:20),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(MyLocalizations.of(context).getData('team_amount'),style: TextStyle(color: Colors.white),),
                                                  SizedBox(width:10),
                                                  userInfo == null?Container():
                                                  Text(userInfo[4].toString(),style: TextStyle(color:Colors.greenAccent,fontSize:20,fontWeight:FontWeight.bold)),
                                                  SizedBox(width:20),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(MyLocalizations.of(context).getData('active_amount'),style: TextStyle(color: Colors.white),),
                                                  SizedBox(width:10),
                                                  userInfo == null?Container():
                                                  Text(userInfo[5].toString(),style: TextStyle(color:Colors.greenAccent,fontSize:20,fontWeight:FontWeight.bold)),
                                                  SizedBox(width:20),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                  )
                                ),
                              ),
                          ),
                  dataList == null?Container():
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
                                      // borderRadius: BorderRadius.circular(10),
                                      // gradient: LinearGradient(
                                      // begin: Alignment.topCenter,
                                      // end: Alignment.bottomCenter,
                                      // colors: [Color(0xff9957ED), Color(0xff7835E5)])
                                  ),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    dataList[0]==null?Container(child:Text(''),color: Colors.white,):
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left:10,right: 10),
                                        child: Row(
                                          children: [
                                          Container(
                                            margin: EdgeInsets.only(right:10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Colors.white.withOpacity(0.2)
                                            ),
                                            child: Image(
                                              image: NetworkImage(
                                                dataList ==null?
                                                'https://philip.greatwallsolution.com/sae.png':
                                                dataList[index]['package_icon']),
                                              height: 60,
                                              width: 60,
                                            )
                                          ),
                                          Expanded(
                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                              crossAxisAlignment: CrossAxisAlignment.start, //Center Row contents vertically,
                                              children: [
                                                Text(dataList[index]['username'],style: TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                                SizedBox(height:5),
                                                Text(language=='zh'?dataList[index]['package']:dataList[index]['package_en'],style: TextStyle(color:Colors.grey,fontSize:14,fontWeight:FontWeight.bold),overflow: TextOverflow.ellipsis,)
                                            ],)
                                          ),
                                          SizedBox(width:20),
                                          Container(
                                            child:Row(children: [
                                              Container(
                                                margin: EdgeInsets.only(right:10),
                                                child: Text(MyLocalizations.of(context).getData('sales'),style: TextStyle(color:Colors.white,fontSize:14),overflow: TextOverflow.ellipsis,)),
                                              Text(dataList[index]['sales']==null?'0':dataList[index]['sales'].toString(),style: TextStyle(color:Colors.greenAccent,fontSize:14,fontWeight:FontWeight.bold),),
                                            ],)
                                              
                                          ),
                                          SizedBox(width:20),
                                          GestureDetector(
                                            onTap: () {
                                                 showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                        backgroundColor: Color(0xff9957ED),
                                                        title: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          child: Column(children: [
                                                            Center(
                                                              child: 
                                                                Text(dataList[index]['username'],
                                                                style: TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold))),
                                                            Container(
                                                              margin: EdgeInsets.only(top:40,bottom:10,left:10,right:10),
                                                              child:Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                Text(MyLocalizations.of(context).getData('sales'),style: TextStyle(color: Colors.white)),
                                                                Text(dataList[index]['sales']==null?'0':dataList[index]['sales'].toString(),
                                                                style: TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold))
                                                              ],)
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(bottom:30,left:10,right:10),
                                                              child:Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                Flexible(child: Text(MyLocalizations.of(context).getData('sponsor_amount'),style: TextStyle(color: Colors.white))),
                                                                Flexible(
                                                                  child: Text(dataList[index]['total_sponsor'].toString(),
                                                                  style: TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold)),
                                                                )
                                                              ],)
                                                            ),
                                                            Container(
                                                              child:Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                GestureDetector(
                                                                onTap: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(MyLocalizations.of(context).getData('cancel'),style: TextStyle(color: Colors.white60),)),
                                                                dataList[index]['total_sponsor'] >0?
                                                                GestureDetector(
                                                                onTap: (){
                                                                  setState(() {
                                                                    otherUserId = dataList[index]['id'];
                                                                    checkDetails(otherUserId);
                                                                    userInfo = [dataList[index]['username'],dataList[index]['package'],dataList[index]['total_sponsor'],dataList[index]['package_icon'],dataList[index]['team'],dataList[index]['active']];
                                                                    print(userInfo);
                                                                    Navigator.pop(context);
                                                                  });
                                                                },
                                                                child: Text(MyLocalizations.of(context).getData('check'),style: TextStyle(color: Colors.greenAccent))):
                                                                GestureDetector(
                                                                 onTap: (){
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => RegisterStepOne(widget.url,widget.onChangeLanguage,widget.refId= dataList[index]['username'].toString(),otp,mobileNumber)),
                                                                  );
                                                                },
                                                                child: Text(MyLocalizations.of(context).getData('register'),style: TextStyle(color: Colors.greenAccent)))
                                                              ],)
                                                            )
                                                          ],)
                                                        ),
                                                    )
                                                );
                                            },
                                            child: Container(
                                              child:Icon(Icons.add_box_outlined,color: Colors.white,)
                                            ),
                                          )
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
                  ]),
              ),
            ),  
           ],
        ),   
    );
  }
}