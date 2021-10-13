import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Explore/apiBindingForm.dart';
import 'package:robot/views/Part/pageView.dart';
import 'package:robot/views/Trade/startUp.dart';
import 'package:robot/views/Trade/tradeDetails.dart';
import 'package:robot/views/Trade/transactionRecord.dart';
import 'package:robot/views/widget/loaderForScroll.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Trade extends StatefulWidget {
   final url;
   final onChangeLanguage;
   final type;
   final marketId;
   final marketName;
   final robotID;
   

  Trade(this.url,this.onChangeLanguage,this.type,this.marketId,this.marketName,this.robotID);
  @override
  _TradeState createState() => _TradeState();
}

class _TradeState extends State<Trade> {
  final TextEditingController secPwdController = new TextEditingController();
  final TextEditingController pauseSecPwdController = new TextEditingController();
  var type = '';
  
  var robotList;
  var info;
  var info2;
  double revenue;
  Timer _timer;
  int count= 0;
  var dataList;
  double price;
  var language;
  var result;
  var robotNewId;
  bool _clicked = true; 
  bool isLoading = true;
  var status;

  @override
  void initState() {
    super.initState();
    startLoop();
    getLanguage();
    print(widget.robotID);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  startLoop(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        // if (contentData['status']) {
          var checkApi= await initializeData();
        
          if (this.mounted) {
            setState(() {
              count++;
            });
          }
        

          if(!checkApi){
            timer.cancel();

          }
      },
    );

  }

  startLoop2(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        // if (contentData['status']) {
          var checkApi= await initializeData2();
        
          if (this.mounted) {
            setState(() {
              count++;
            });
          }
        

          if(!checkApi){
            timer.cancel();

          }
      },
    );

  }
  
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
  }

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'robot_id': widget.robotID == ''?robotNewId.toString():widget.robotID.toString(),
      };
      // print(body);
      var uri = Uri.https(Config().url2, 'api/trade-robot/robotInfo', body);
   
     
      
      try {
        var response = await http.get(uri, headers: {
          'Authorization': 'Bearer $token'
        }).timeout(new Duration(seconds: 10));
        var contentData = json.decode(response.body);
        if(contentData != null){
          if (contentData['code'] == 0) {
            if (this.mounted) {
              setState(() {
              robotList = contentData['data'];  
              print(robotList);
              if(robotList!=null){
                  revenue = double.parse(robotList['revenue']);
                  price = double.parse(robotList['price']);
                  status = robotList['status'];
                  print(status);

                  if(robotList['values_str']==null){
                     setState(() {
                      isLoading = false;
                    });
                  }
                  else if(robotList['values_str'].length!=0){
                    info2 = json.decode(robotList['values_str']);
                    
                  }
              }
            });
            }
          }
        } 
        setState(() {
          isLoading = false;
        });
        return true;
      } catch (e) {
        return false;
        
      }
  }

  initializeData2() async {
       print(result);
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'robot_id': result.toString(),
      };
      var uri = Uri.https(Config().url2, 'api/trade-robot/robotInfo', body);
   
     
      print(count);
      try {
        var response = await http.get(uri, headers: {
          'Authorization': 'Bearer $token'
        }).timeout(new Duration(seconds: 10));
        var contentData = json.decode(response.body);
        if(contentData != null){
          if (contentData['code'] == 0) {
            if (this.mounted) {
              setState(() {
              robotList = contentData['data'];  
              if(robotList!=null){
                  revenue = double.parse(robotList['revenue']);
                  price = double.parse(robotList['price']);

                  if(robotList['values_str']==null){
                     setState(() {
                      isLoading = false;
                    });
                  }
                  else if(robotList['values_str'].length!=0){
                    info2 = json.decode(robotList['values_str']);
                    
                  }
              }
            });
            }
          }
        } 
        setState(() {
          isLoading = false;
        });
        return true;
      } catch (e) {
        return false;
        
      }
  }

  _startUpButton() async {
      result = await Navigator.push(context,
        new MaterialPageRoute(builder: (context) =>  StartUp(widget.url,widget.onChangeLanguage,widget.type,widget.marketId)),);
      startLoop2();
      robotNewId = result.toString(); 
  }

  Future<void> play() async {
    bool isPosting =  false;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Color(0xfffFDE323),
            title: Center(
              child: Icon(
              Icons.play_arrow, 
              color: Colors.black,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(MyLocalizations.of(context).getData('start_robot')),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        obscureText: true,
                        controller: secPwdController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: MyLocalizations.of(context).getData('sec_password'),
                            contentPadding: const EdgeInsets.all(14.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                               borderSide: BorderSide(color: Colors.black, width: 1),
                            ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('cancel'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('start_up'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    // onPressed: _clicked ? false :() {
                    //   setState(() {
                    //     var tmap = new Map<String, dynamic>();
                    //     tmap['robot_id'] = robotList['id'].toString();
                    //     tmap['sec_password'] = secPwdController.text;
                    //     playRobot(tmap);
                    //     _clicked=false;
                    //   });
                     
                    // },

                     onPressed: (!isPosting)?() async{
                      setState(() {
                        isPosting = true;
                      });

                      var tmap = new Map<String, dynamic>();
                      tmap['robot_id'] = robotList['id'].toString();
                      tmap['sec_password'] = secPwdController.text;
                      print(tmap);
                      var tmpValue = await playRobot(tmap);

                      setState(() {
                        isPosting = tmpValue;
                      });
                    }:null,

                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  
  Future<void> pause() async {
    bool isPosting= false;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Color(0xfffFDE323),
            title: Center(
              child: Icon(
              Icons.pause, 
              color: Colors.black,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(MyLocalizations.of(context).getData('pause_robot')),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        obscureText: true,
                        controller: pauseSecPwdController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: MyLocalizations.of(context).getData('sec_password'),
                            contentPadding: const EdgeInsets.all(14.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                               borderSide: BorderSide(color: Colors.black, width: 1),
                            ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('cancel'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('pause'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    // onPressed: () {
                    //   setState(() {
                    //     var tmap = new Map<String, dynamic>();
                    //     tmap['robot_id'] = robotList['id'].toString();
                    //     tmap['sec_password'] = pauseSecPwdController.text;
                    //     pauseRobot(tmap);
                    //   });
                     
                    // },

                     onPressed: (!isPosting)?() async{
                            setState(() {
                              isPosting = true;
                            });
                            
                            var tmap = new Map<String, dynamic>();
                            tmap['robot_id'] = robotList['id'].toString();
                            tmap['sec_password'] = pauseSecPwdController.text;
                            print(tmap);
                            var tmpValue = await pauseRobot(tmap);

                            setState(() {
                              isPosting = tmpValue;
                            });
                            
                          }:null
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  playRobot(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/enable", bodyData, token, context);
    
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
              _timer.cancel();
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TopViewing(
                      widget.url, widget.onChangeLanguage)));
            })
          ..show();
    } 
    setState(() {
      secPwdController.text = '';
    });
    return false;
  }

   pauseRobot(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/disable", bodyData, token, context);
    
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
            _timer.cancel();
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TopViewing(
                      widget.url, widget.onChangeLanguage)));
            })
          ..show();
    }  
    setState(() {
      pauseSecPwdController.text = '';
    });
    return false;
  }

   _sendToServer() {
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['robot_id'] = widget.robotID.toString();
          tmap['sec_password'] = secPwdController.text;
        
        });
         postData(tmap);
    
  }

   _sendToServer2() {
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['robot_id'] = widget.robotID.toString();
          tmap['sec_password'] = secPwdController.text;
        
        });
         postData2(tmap);
    
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/changeRecycle", bodyData, token, context);
    
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
              _timer.cancel();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TopViewing(
                        widget.url, widget.onChangeLanguage)));
              })
          ..show();
    } else {
     
    }
    setState(() {
     
    });
  }

  postData2(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/restock", bodyData, token, context);
    
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
              _timer.cancel();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TopViewing(
                        widget.url, widget.onChangeLanguage)));
              })
          ..show();
    } else {
     
    }
    setState(() {
     
    });
  }

  Future<void> delete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Color(0xfffFDE323),
            title: Center(
              child: Icon(
              Icons.delete, 
              color: Colors.black,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(MyLocalizations.of(context).getData('clean_robot')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        obscureText: true,
                        controller: secPwdController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: MyLocalizations.of(context)
                              .getData('sec_password'),
                          contentPadding: const EdgeInsets.all(14.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('cancel'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('clean'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      setState(() {
                        var tmap = new Map<String, dynamic>();
                        tmap['robot_id'] = widget.robotID.toString();
                        tmap['sec_password'] = secPwdController.text;
                        deleteRobot(tmap);
                      });
                     
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  deleteRobot(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/clean", bodyData, token, context);
    
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
            _timer.cancel();
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TopViewing(
                      widget.url, widget.onChangeLanguage)));
            })
          ..show();
    } else {
     
    }
    setState(() {
     
    });
  }

  Future<void> singleStrategy() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Color(0xfffFDE323),
            title: Center(
              child: Icon(
              Icons.play_arrow, 
              color: Colors.black,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: 
                        robotList['recycle_status'] == 0?
                        Text(MyLocalizations.of(context).getData('chg_to_circular')):
                        Text(MyLocalizations.of(context).getData('chg_to_one_shot')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        obscureText: true,
                        controller: secPwdController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: MyLocalizations.of(context)
                              .getData('sec_password'),
                          contentPadding: const EdgeInsets.all(14.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('cancel'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('confirm'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      setState(() {
                        _sendToServer();
                      });
                     
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> reStock() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Color(0xfffFDE323),
            title: Center(
              child: Icon(
              Icons.play_arrow, 
              color: Colors.black,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: 
                        Text(MyLocalizations.of(context).getData('repleshiment')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        obscureText: true,
                        controller: secPwdController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: MyLocalizations.of(context)
                              .getData('sec_password'),
                          contentPadding: const EdgeInsets.all(14.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('cancel'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('confirm'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      setState(() {
                        _sendToServer2();
                      });
                     
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                         
                           GestureDetector(
                             onTap: (){
                                _timer.cancel();
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TransactionRecord(widget.url,widget.robotID)),
                              ).then((value) => startLoop());
                             },
                             child: Container(
                              padding: EdgeInsets.only(right:10),
                              child: 
                              Text(MyLocalizations.of(context).getData('log'),style: TextStyle(color: Colors.white,fontSize: 16),)),
                           ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                 Center(
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Color(0xff595c64),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.withOpacity(0.3),width: 3,)
                      ),
                      margin: EdgeInsets.only(top:20,bottom:10,left: 15,right: 15),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                             Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              margin: EdgeInsets.only(right: 10),
                              child: 
                              widget.type=='binance'?
                              Image(
                                image: AssetImage(
                                    "lib/assets/img/BNB.png"),
                                height: 30,
                                width: 30,
                              ):
                              Image(
                                image: AssetImage(
                                    "lib/assets/img/HT.png"),
                                height: 30,
                                width: 30,
                              )
                            ),
                              Container(
                                child: Text(
                                  widget.marketName,
                                  style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width:5),
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(width:10),
                                    if(robotList!=null)
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:(robotList['status']==1)?Colors.greenAccent:Colors.red,
                                      ),
                                    ),
                                    SizedBox(width:5),
                                    if(robotList!=null)
                                    if(robotList['status']==0&& robotList['values_str']!=null)
                                    (robotList['values_str'].length != 0)?Text(
                                      MyLocalizations.of(context).getData('stopped'),
                                      style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
                                    ):Text(
                                      MyLocalizations.of(context).getData('paused'),
                                      style: TextStyle(color: Colors.red, fontSize: 14),
                                    ),
                                    if(robotList!=null)
                                    if(robotList['status']==0&& robotList['values_str']==null)
                                    Text(
                                      MyLocalizations.of(context).getData('paused'),
                                      style: TextStyle(color: Colors.red, fontSize: 14),
                                    ),
                                    SizedBox(width:15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Container(
                                        child: Text(
                                          info2 == null  || info2 == '' ?'0.00':
                                          info2['deal_money'].toStringAsFixed(5),
                                          style: TextStyle(color: Colors.white,fontSize: 13),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('position_amount')+'\n' +'(USDT)',
                                          style: TextStyle(color: Colors.white,fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Container(
                                        child: Text(
                                          info2 == null  || info2 == '' ?'0.00':
                                          info2['base_price'].toStringAsFixed(5),
                                          style: TextStyle(color: Colors.white,fontSize: 13),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('avg_price'),
                                          style: TextStyle(color: Colors.white,fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Container(
                                        child: Text(
                                          info2 == null  || info2 == '' ?'0':
                                           info2['order_count'].toString(),
                                          style: TextStyle(color: Colors.white,fontSize: 13),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('current_cycle_time'),
                                          style: TextStyle(color: Colors.white,fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Container(
                                        child: Text(
                                          info2 == null  || info2 == '' ?'0.00':
                                          info2['deal_amount'].toStringAsFixed(5),
                                          style: TextStyle(color: Colors.white,fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('position_quantity'),
                                          style: TextStyle(color: Colors.white,fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Container(
                                        child: Text(
                                          price == null ?'0.00':
                                          price.toStringAsFixed(8),
                                          style: TextStyle(color: Colors.white,fontSize: 13),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('current_price'),
                                          style: TextStyle(color: Colors.white,fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Container(
                                        child: Text(
                                          info2 == null  || info2 == '' ?'0.00':
                                          revenue.toStringAsFixed(5) + '%',
                                          style: TextStyle(color: Colors.white,fontSize: 13),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('return_rate'),
                                          style: TextStyle(color: Colors.white,fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.only(left:15,right:15),
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Color(0xff595c64),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.3),width: 3,)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyLocalizations.of(context).getData('estimate_cover_price'),style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13)),
                        SizedBox(height: 6,),
                        Text(robotList == null  || robotList == '' ?'0.00': robotList['estimate_cover_price'].toStringAsFixed(5),style:TextStyle(color: Colors.white,fontSize: 13)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              
                            },
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    info2==null? Container():
                                    singleStrategy();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                     decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white,width: 3, )
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                          "lib/assets/img/trade_one_shot.png"),
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                robotList == null?Container(
                                  child: Text(MyLocalizations.of(context).getData('one_shot'),style: TextStyle(color:Colors.white,fontSize: 13),),
                                ):
                                robotList['recycle_status'] == 0?
                                Text(MyLocalizations.of(context).getData('one_shot'),style: TextStyle(color:Colors.white,fontSize: 13),):
                                Text(MyLocalizations.of(context).getData('circular'),style: TextStyle(color:Colors.white,fontSize: 13),)
                              ],
                            ),
                          ),
                        ])),
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              
                            },
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      info2==null? Container():
                                      delete();
                                    },
                                    child: Container(
                                       padding: EdgeInsets.all(10.0),
                                     decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white,width: 3, )
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                          "lib/assets/img/trade_clearance sale.png"),
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                  ),
                                SizedBox(height: 5,),
                                Text(MyLocalizations.of(context).getData('clearance_sale'),style: TextStyle(color:Colors.white,fontSize: 13),)
                              ],
                            ),
                          ),
                        ])),
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              info2==null || robotList['is_restock'] ==1 ? Container():reStock(),
                            },
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                 Container(
                                  padding: EdgeInsets.all(10.0),
                                   decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white,width: 3, )
                                  ),
                                  child: Image(
                                    image: AssetImage(
                                        "lib/assets/img/trade_replenishment.png"),
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(MyLocalizations.of(context).getData('repleshiment'),style: TextStyle(color:Colors.white,fontSize: 13),)
                              ],
                            ),
                          ),
                        ])),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Color(0xff595c64),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.3),width: 3,)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyLocalizations.of(context).getData('operation_remind'),style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14)),
                        SizedBox(height: 10,),
                        Text(MyLocalizations.of(context).getData('operation_remind_details'),style:TextStyle(color: Colors.white,fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.only(left:15,right:15),
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Color(0xff595c64),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.3),width: 3,)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyLocalizations.of(context).getData('message'),style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13)),
                        SizedBox(height: 6,),
                        Text(robotList==null?'':language=='zh'?robotList['show_msg'].toString():language=='ms'?robotList['show_msg_vn'].toString():robotList['show_msg_en'].toString(),style:TextStyle(color: Colors.white,fontSize: 13)),
                      ],
                    ),
                  ),
                  //  Center(
                  //   child: InkWell(
                  //     onTap: () {
                  //     },
                  //     child: Container(
                  //       decoration: new BoxDecoration(
                  //         color: Color(0xff595c64),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       margin: EdgeInsets.all(10),
                  //       padding: EdgeInsets.all(20),
                  //       child: Row(
                  //         children: <Widget>[
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment:
                  //                   CrossAxisAlignment.start,
                  //               children: <Widget>[
                  //                 Container(
                  //                   child: Text(
                  //                     MyLocalizations.of(context).getData('first_purchase_date'),
                  //                     style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.end,
                  //               children: <Widget>[
                  //                 Container(
                  //                     child: (Icon(
                  //                         Icons.chevron_right_outlined,color: Colors.white,))),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                  margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                    color: Color(0xff595c64),
                    borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.3),width: 3,)
                  ),
                  child: GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff595c64),
                             border: Border(
                              right: BorderSide(width: 1.0,color: Color(0xff212630)),
                              bottom: BorderSide(width: 2.0,color: Color(0xff212630)),
                            ),
                           ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  child:  Image(
                                    image: AssetImage(
                                        "lib/assets/img/first_order_limit.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('first_buy_in_amount'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['first_order_value'].toString(),
                                      style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff595c64),
                            border: Border(
                              left: BorderSide(width: 1.0,color: Color(0xff212630)),
                              bottom: BorderSide(width: 2.0,color: Color(0xff212630)),
                            ),
                           ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  child:  Image(
                                    image: AssetImage(
                                        "lib/assets/img/multi_invesment_limit.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('numbers_of_cover_up'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['max_order_count'].toString(),
                                      style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff595c64),
                            border: Border(
                              right: BorderSide(width: 1.0,color: Color(0xff212630)),
                              bottom: BorderSide(width: 2.0,color: Color(0xff212630)),
                            ),
                           ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  child:  Image(
                                    image: AssetImage(
                                        "lib/assets/img/take_profit_ratio.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('take_profit_ratio'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['stop_profit_rate'].toString() + '%',
                                      style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff595c64),
                            border: Border(
                              left: BorderSide(width: 1.0,color: Color(0xff212630)),
                              bottom: BorderSide(width: 2.0,color: Color(0xff212630)),
                            ),
                           ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  child:  Image(
                                    image: AssetImage(
                                        "lib/assets/img/earning_callback.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('earnings_callback'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['stop_profit_callback_rate'].toString()+ '%',
                                      style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff595c64),
                            border: Border(
                              right: BorderSide(width: 1.0,color: Color(0xff212630)),
                            ),
                           ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  child:  Image(
                                    image: AssetImage(
                                        "lib/assets/img/call_drop.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('margin_call_drop'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['cover_rate'].toString()+ '%',
                                      style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff595c64),
                            border: Border(
                              left: BorderSide(width: 1.0,color: Color(0xff212630)),
                            ),
                           ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  child:  Image(
                                    image: AssetImage(
                                        "lib/assets/img/call_drop.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('buy_in_callback'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['cover_callback_rate'].toString()+ '%',
                                      style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ),
          ),
            if(isLoading)LoaderScroll(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
              child: RaisedButton(
                onPressed: isLoading?null:() {
                  _timer.cancel();
                  if(robotList==null ||robotList.isEmpty)
                   _startUpButton();
                  if(robotList!=null)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TradeDetails(widget.url,widget.onChangeLanguage,robotList['id'],robotList['first_order_value'],robotList['max_order_count'],robotList['stop_profit_rate'],robotList['stop_profit_callback_rate'],robotList['cover_rate'],robotList['cover_callback_rate'],robotList['recycle_status'],robotList['status'],robotList['is_clean'],robotList['show_msg'],robotList['values_str'])),).then((value) => startLoop()
                  );
                },
                color: Colors.yellowAccent,
                textColor: Colors.black,
                child: Text(robotList==null || robotList.isEmpty?MyLocalizations.of(context).getData('robot_setup'):MyLocalizations.of(context).getData('transaction_settings')),
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: isLoading?null:() {
                  if(robotList==null || robotList.isEmpty)
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: MyLocalizations.of(context).getData('error'),
                    desc: MyLocalizations.of(context).getData('please_settings_robot'),
                    btnOkOnPress: () {},
                    btnOkText: MyLocalizations.of(context).getData('close'),
                    btnOkIcon: Icons.cancel,
                    btnOkColor: Colors.red)
                  ..show();
                 
                  else if(robotList['status']==0)
                  play();
                  else if(robotList['status']==1)
                  pause();

                  
                },
                color: Colors.yellowAccent,
                textColor: Colors.black,
                child: robotList == null || robotList.isEmpty || robotList['status']==0?Text(MyLocalizations.of(context).getData('start_up')):Text(MyLocalizations.of(context).getData('pause')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
