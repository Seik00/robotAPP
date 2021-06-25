
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class RobotPackage extends StatefulWidget {
  final url;
  RobotPackage(this.url);
  
  @override
  _RobotPackageState createState() => _RobotPackageState();
}

class _RobotPackageState extends State<RobotPackage> {
  final TextEditingController secPwdController = new TextEditingController();
  var version = ['1', '2', '3', '4'];
  var agent;
  List v = [];
  double vip;
  var market;
  var total;
  var selectedVersion;
  var selectedName;
  var selectedPrice;
  var selectedTimes;
  String token;
  var currentlanguage;
  var dataList =[];
  var usdt;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    currentlanguage = prefs.getString('language');
    print(currentlanguage);
  }

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          print(contentData);
          usdt = contentData['point1'];
        });
      }
    }
  }

  getPackageList() async {
    var contentData = await Request().getRequest(Config().url + "api/robot-package/getRobotPackage", context);
    print(contentData);
    if(contentData != null){
      if (contentData['code'] == 0) {
          setState(() {
             dataList = contentData['data'];
             print(dataList);
          });
      }
    }
  }

  // getAgentInfo(dynamic data) async {
  //   var contentData = await Request(context).postRequest(Config().url+"/web/index/getAgentInfo/", data);
  //   print(contentData);
  //   if (contentData!=null) {
  //     if (contentData['SUCCEED'] > 0) {
  //       if (mounted) setState(() {
  //           v = contentData['DATA']['pool'].entries.toList();
  //           market =contentData['DATA']['market'];
  //           cu =contentData['DATA']['cu'];
  //           selectedVersion= v[0].value;
  //           total = selectedVersion - market;
  //           for(int i= 0; i<contentData.length; i++){
  //             print(v[i].key);
  //             print(v[i].value);
  //           }
  //           print(cu);
  //           //print(v);      
  //       });
  //     } 
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getLanguage();
    getPackageList();
    getRequest();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212630),
      appBar: AppBar(
        backgroundColor: Color(0xff595c64),
        elevation: 0,
        title: Text(MyLocalizations.of(context).getData('robot_package'),style: TextStyle(color: Colors.white),),
        centerTitle: true,
        // actions: <Widget>[
        //   Container(
        //     margin: EdgeInsets.only(right:15),
        //     height: 15,
        //     width: 15,
        //     decoration: BoxDecoration(
        //       image: DecorationImage(image: AssetImage("lib/assets/img/clipboard.png"))
        //     ),
        //   ),
        // ],
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      // height: MediaQuery.of(context).size.height/4.5,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.8,
                      aspectRatio: 2.5,
                      onPageChanged: (index, reason) {
                        setState(() {
                          selectedVersion = dataList[index]['id'];
                          selectedName = dataList[index]['package_name'];
                          selectedPrice = dataList[index]['price'];
                          selectedTimes = dataList[index]['robot_times'];
                          // selectedName = index+1;
                          print(selectedVersion);
                        });
                      }
                    ),
                    items: dataList.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("lib/assets/img/assetsbg.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  i['package_name'], 
                                  style: TextStyle(
                                    color:Colors.white, 
                                    fontSize: 20, 
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                                
                                Text(
                                  i['price'] + ' USDT', 
                                  style: TextStyle(
                                    color:Colors.white, 
                                  )
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      i['robot_times'].toString()+' ' + MyLocalizations.of(context).getData('times'), 
                                      style: TextStyle(
                                        color:Colors.white, 
                                      )
                                    ),
                                    Image.asset('lib/assets/img/assetsbg.png', height: 20, width: 30,),
                                    
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(left: 20,right:20),
                  decoration: new BoxDecoration(
                    color: Color(0xff595c64),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(MyLocalizations.of(context).getData('usdt_balance'),style: TextStyle(color: Colors.white),),
                      SizedBox(width:10),
                      Text(usdt==null?'0.00':usdt,style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: new BoxDecoration(
                    color: Color(0xff595c64),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(MyLocalizations.of(context).getData('package_details'),
                        style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height:30),
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Image(
                                image:
                                    AssetImage("lib/assets/img/assetsbg.png"),
                                height: 40,
                                width: 40,
                              )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    MyLocalizations.of(context).getData('package_name'),
                                    style: TextStyle(
                                        fontSize: 18, 
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                      )
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    selectedName.toString(),
                                    style: TextStyle(
                                      fontSize: 16, 
                                      color: Colors.white,
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Image(
                                image:
                                    AssetImage("lib/assets/img/assetsbg.png"),
                                height: 40,
                                width: 40,
                              )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    MyLocalizations.of(context).getData('package_price'),
                                    style: TextStyle(
                                        fontSize: 18, 
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                      )
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    selectedPrice.toString() + ' USDT',
                                    style: TextStyle(
                                      fontSize: 16, 
                                      color: Colors.white,
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Image(
                                image:
                                    AssetImage("lib/assets/img/assetsbg.png"),
                                height: 40,
                                width: 40,
                              )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    MyLocalizations.of(context).getData('package_times'),
                                    style: TextStyle(
                                        fontSize: 18, 
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                      )
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    selectedTimes.toString(),
                                    style: TextStyle(
                                      fontSize: 16, 
                                      color: Colors.white,
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: GestureDetector(
                        onTap: ()async{
                          setState(() {
                            var tmap = new Map<String, dynamic>();
                            tmap['package_id'] = selectedVersion.toString();
                            tmap['pay_type'] = 'point1';
                        
                            submit(tmap);
                          });
                        }, 
                        child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xfffaef1d), Color(0xfff9f21a)])
                              ),
                              height: MediaQuery.of(context).size.height / 15,
                              alignment: Alignment.center,
                              child: Text(
                                MyLocalizations.of(context).getData('submit'),
                                style: TextStyle(color: Colors.black),
                              )),
                        ),
                      ),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  submit(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/robot-package/purchaseRobotPackage", bodyData, token, context);
    
    print(contentData);
    if (contentData['code'] == 0) {
           AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            autoHide: Duration(seconds: 2),
            title: MyLocalizations.of(context).getData('success'),
            desc:MyLocalizations.of(context).getData('operation_success'),
            onDissmissCallback: () {
             Navigator.pop(context);
            })
          ..show();
    } else {
     
    }
    setState(() {
     
    });
  }
}