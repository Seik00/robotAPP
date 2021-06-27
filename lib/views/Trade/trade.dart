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
  var type = '';
  
  var robotList;
  var info;
  var info2;
  double revenue;
  Timer _timer;
  int count= 0;
  var dataList;
  double price;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    startLoop();
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
  
  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'robot_id': widget.robotID.toString(),
      };
      // print(body);
      var uri = Uri.https(Config().url2, 'api/trade-robot/robotInfo', body);
   
     
      print(count);
      try {
        var response = await http.get(uri, headers: {
          'Authorization': 'Bearer $token'
        }).timeout(new Duration(seconds: 10));
        var contentData = json.decode(response.body);
        print(contentData);
        if(contentData != null){
          if (contentData['code'] == 0) {
            if (this.mounted) {
              setState(() {
              robotList = contentData['data'];  
              if(robotList!=null){
                  revenue = double.parse(robotList['revenue']);
                  price = double.parse(robotList['price']);
                  if(robotList['values_str'].length!=0){
                    info2 = json.decode(robotList['values_str']);
                    print(info2);
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

  Future<void> play() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.blue[100],
            title: Center(
              child: Icon(
              Icons.play_arrow, 
              color: Colors.white,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text('Play Robot'),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text('Cancel',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text('Play',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      setState(() {
                        var tmap = new Map<String, dynamic>();
                        tmap['robot_id'] = robotList['id'].toString();
                        print(tmap);
                        playRobot(tmap);
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

  
  Future<void> pause() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.blue[100],
            title: Center(
              child: Icon(
              Icons.pause, 
              color: Colors.white,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text('Pause Robot'),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text('Cancel',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text('Pause',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      setState(() {
                        var tmap = new Map<String, dynamic>();
                        tmap['robot_id'] = robotList['id'].toString();
                        print(tmap);
                        pauseRobot(tmap);
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

  playRobot(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/enable", bodyData, token, context);
    
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

   pauseRobot(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/disable", bodyData, token, context);
    
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

   _sendToServer() {
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['robot_id'] = widget.robotID.toString();
          tmap['first_order_value'] = robotList['first_order_value'].toString();
          tmap['max_order_count'] = robotList['max_order_count'].toString();
          tmap['stop_profit_rate'] = robotList['stop_profit_rate'].toString();
          tmap['stop_profit_callback_rate'] = robotList['stop_profit_callback_rate'].toString();
          tmap['cover_rate'] = robotList['cover_rate'].toString();
          tmap['cover_callback_rate'] = robotList['cover_callback_rate'].toString();
          tmap['recycle_status'] = '0';
        
        });
         postData(tmap);
    
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/edit", bodyData, token, context);
    
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
            backgroundColor: Colors.blue[100],
            title: Center(
              child: Icon(
              Icons.delete, 
              color: Colors.white,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text('Clean Robot'),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text('Cancel',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text('Clean',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      setState(() {
                        var tmap = new Map<String, dynamic>();
                        tmap['robot_id'] = widget.robotID.toString();
                        print(tmap);
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
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/clean", bodyData, token, context);
    
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
            backgroundColor: Colors.blue[100],
            title: Center(
              child: Icon(
              Icons.looks_one, 
              color: Colors.white,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text('Single Strategy'),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text('Cancel',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text('Confirm',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
                      ),
                      margin: EdgeInsets.only(top:20,bottom:10,left: 10,right: 10),
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
                              Expanded(
                                child: Container(
                                  child: Text(
                                    widget.marketName,
                                    style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
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
                                          style: TextStyle(color: Colors.white,fontSize: 14),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('position_amount')+'\n' +'(USDT)',
                                          style: TextStyle(color: Colors.white,fontSize: 14),
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
                                          style: TextStyle(color: Colors.white,fontSize: 14),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('avg_price'),
                                          style: TextStyle(color: Colors.white,fontSize: 14),
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
                                          style: TextStyle(color: Colors.white,fontSize: 14),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('current_cycle_time'),
                                          style: TextStyle(color: Colors.white,fontSize: 14),
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
                                          style: TextStyle(color: Colors.white,fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('position_quantity'),
                                          style: TextStyle(color: Colors.white,fontSize: 14),
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
                                          style: TextStyle(color: Colors.white,fontSize: 14),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('current_price'),
                                          style: TextStyle(color: Colors.white,fontSize: 14),
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
                                          style: TextStyle(color: Colors.white,fontSize: 14),
                                        ),
                                      ),
                                    ),
                                     Container(
                                      child: Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('return_rate'),
                                          style: TextStyle(color: Colors.white,fontSize: 14),
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
                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    if(robotList['is_clean']==0)
                                    info2==null? Container():
                                    singleStrategy();
                                    if(robotList['is_clean']==1)
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.ERROR,
                                      animType: AnimType.RIGHSLIDE,
                                      headerAnimationLoop: false,
                                      title: MyLocalizations.of(context).getData('error'),
                                      desc: MyLocalizations.of(context).getData('robot_clean'),
                                      btnOkOnPress: () {},
                                      btnOkText: MyLocalizations.of(context).getData('close'),
                                      btnOkIcon: Icons.cancel,
                                      btnOkColor: Colors.red)
                                    ..show();
                                    if(robotList['is_clean']==0 && robotList['show_msg'] == '卖出成功' && robotList['values_str'] == '' )
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.ERROR,
                                      animType: AnimType.RIGHSLIDE,
                                      headerAnimationLoop: false,
                                      title: MyLocalizations.of(context).getData('error'),
                                      desc: MyLocalizations.of(context).getData('sold'),
                                      btnOkOnPress: () {},
                                      btnOkText: MyLocalizations.of(context).getData('close'),
                                      btnOkIcon: Icons.cancel,
                                      btnOkColor: Colors.red)
                                    ..show();
                                  },
                                  child: Container(
                                     decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white,width: 3, )
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                          "lib/assets/img/trade_one_shot.png"),
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(MyLocalizations.of(context).getData('one_shot'),style: TextStyle(color:Colors.white),)
                              ],
                            ),
                          ),
                        ])),
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      if(robotList['is_clean']==0)
                                      info2==null? Container():
                                      delete();
                                        if(robotList['is_clean']==1)
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title: MyLocalizations.of(context).getData('error'),
                                          desc: MyLocalizations.of(context).getData('robot_clean'),
                                          btnOkOnPress: () {},
                                          btnOkText: MyLocalizations.of(context).getData('close'),
                                          btnOkIcon: Icons.cancel,
                                          btnOkColor: Colors.red)
                                        ..show();
                                        if(robotList['is_clean']==0 && robotList['show_msg'] == '卖出成功' && robotList['values_str'] == '' )
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title: MyLocalizations.of(context).getData('error'),
                                          desc: MyLocalizations.of(context).getData('sold'),
                                          btnOkOnPress: () {},
                                          btnOkText: MyLocalizations.of(context).getData('close'),
                                          btnOkIcon: Icons.cancel,
                                          btnOkColor: Colors.red)
                                        ..show();
                                    },
                                    child: Container(
                                     decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white,width: 3, )
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                          "lib/assets/img/trade_clearance sale.png"),
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                  ),
                                SizedBox(height: 5,),
                                Text(MyLocalizations.of(context).getData('clearance_sale'),style: TextStyle(color:Colors.white),)
                              ],
                            ),
                          ),
                        ])),
                        Container(
                          child: Column(children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                animType: AnimType.RIGHSLIDE,
                                headerAnimationLoop: false,
                                title: MyLocalizations.of(context).getData('coming_soon'),
                                desc: MyLocalizations.of(context).getData('please_be_patient'),
                                btnOkOnPress: () {},
                                btnOkText: MyLocalizations.of(context).getData('close'),
                                btnOkIcon: Icons.cancel,
                                btnOkColor: Colors.orangeAccent)
                              ..show()
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                 Container(
                                   decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white,width: 3, )
                                  ),
                                  child: Image(
                                    image: AssetImage(
                                        "lib/assets/img/trade_replenishment.png"),
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(MyLocalizations.of(context).getData('repleshiment'),style: TextStyle(color:Colors.white),)
                              ],
                            ),
                          ),
                        ])),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Color(0xff595c64),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyLocalizations.of(context).getData('message'),style:TextStyle(color: Colors.white)),
                        Text(robotList==null?'':robotList['show_msg'],style:TextStyle(color: Colors.grey)),
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
                  margin: EdgeInsets.all(10),
                  child: GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff595c64),
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
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('first_buy_in_amount'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['first_order_value'].toString(),
                                      style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
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
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('numbers_of_cover_up'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['max_order_count'].toString(),
                                      style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
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
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('take_profit_ratio'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['stop_profit_rate'].toString() + '%',
                                      style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
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
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('earnings_callback'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['stop_profit_callback_rate'].toString()+ '%',
                                      style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
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
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('margin_call_drop'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['cover_rate'].toString()+ '%',
                                      style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
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
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    MyLocalizations.of(context).getData('buy_in_callback'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                                SizedBox(width:15),
                                Container(
                                    child: Text(
                                      robotList==null || robotList.isEmpty ? '':robotList['cover_callback_rate'].toString()+ '%',
                                      style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => robotList==null ||robotList.isEmpty? StartUp(widget.url,widget.onChangeLanguage,widget.type,widget.marketId): TradeDetails(widget.url,widget.onChangeLanguage,robotList['id'],robotList['first_order_value'],robotList['max_order_count'],robotList['stop_profit_rate'],robotList['stop_profit_callback_rate'],robotList['cover_rate'],robotList['cover_callback_rate'],robotList['recycle_status'],robotList['status'],robotList['is_clean'],robotList['show_msg'],robotList['values_str'])),).then((value) => startLoop()
                  );
                },
                color: Colors.yellowAccent,
                textColor: Colors.black,
                child: Text(MyLocalizations.of(context).getData('transaction_settings')),
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
                  else if(robotList['is_clean']==0 && robotList['show_msg'] == '卖出成功' && robotList['values_str'] == '' )
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: MyLocalizations.of(context).getData('error'),
                    desc: MyLocalizations.of(context).getData('sold'),
                    btnOkOnPress: () {},
                    btnOkText: MyLocalizations.of(context).getData('close'),
                    btnOkIcon: Icons.cancel,
                    btnOkColor: Colors.red)
                  ..show();
                  else if(robotList['status']==0 && robotList['is_clean']==0)
                  play();
                  else if(robotList['status']==1 && robotList['is_clean']==0)
                  pause();

                  else if(robotList['is_clean']==1)
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: MyLocalizations.of(context).getData('error'),
                    desc: MyLocalizations.of(context).getData('robot_clean'),
                    btnOkOnPress: () {},
                    btnOkText: MyLocalizations.of(context).getData('close'),
                    btnOkIcon: Icons.cancel,
                    btnOkColor: Colors.red)
                  ..show();
                },
                color: Colors.yellowAccent,
                textColor: Colors.black,
                child: robotList == null || robotList.isEmpty || robotList['status']==0?Text('Start Up'):Text('Pause'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
