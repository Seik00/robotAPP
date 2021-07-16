import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/transferRecord.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Transfer extends StatefulWidget {
  final url;

  Transfer(this.url);
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
final TextEditingController usernameController =
    new TextEditingController();
final TextEditingController amountController =
    new TextEditingController();
final TextEditingController secpwdController =
    new TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vcodeController = TextEditingController();

final GlobalKey<FormState> _key = new GlobalKey();    
bool _validate = false;
bool visible = true;
int _value = 1;
var finalValue;

 var pointOne;
 var pointTwo;
 var pointThree;
 var _firstPress = true ;
 var otp;
var userEmail;
Timer _timer;
int _start = 60;
var _firstPressTwo = true ;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 60;
            _firstPressTwo = true ;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

 getRequest() async {
    var contentData = await Request()
        .getRequest(Config().url + "api/member/get-member-info", context);
      if (mounted) {
        setState(() {
          pointOne = contentData['point1'];
          pointTwo = contentData['point2'];
          pointThree = contentData['point3'];
          emailController.text = contentData['email'];
        });
      }

    print(contentData);
  }

  
  @override
  void initState() {
    super.initState();
   getRequest();
  }

  @override
  void dispose() {
    super.dispose();
     _timer.cancel();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
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
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TransferRecord(widget.url)),
                            );
                        },
                        child:Container(
                          alignment: Alignment.bottomRight,
                          child: 
                          Text(MyLocalizations.of(context).getData('transfer_record'),style: TextStyle(color: Colors.white,fontSize: 16),)),
                      )
                    ],
                  ),
                  Center(
                      child: Text(
                          MyLocalizations.of(context).getData('transfer'),
                          style: Theme.of(context).textTheme.headline1)),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xfff9f21a), Color(0xfff9f21a)])
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 8,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom:5),
                          child: Text(
                            MyLocalizations.of(context).getData('my_balance'),
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                        ),
                        if(_value ==1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text('USDT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: pointOne == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                   Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    pointOne,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                        if(_value ==2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(MyLocalizations.of(context).getData('gas'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: pointTwo == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                   Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    pointTwo,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                        if(_value ==3)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(MyLocalizations.of(context).getData('gas_pingyi'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: pointThree == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                   Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    pointThree,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],)
                      ],
                    )
                  ),
                  SizedBox(height:20),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                  child: Form(
                      key: _key,
                      autovalidate: _validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           SizedBox(height: 20.0),
                          Container(
                            child: Text(MyLocalizations.of(context).getData('username'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputUsername(),
                           SizedBox(height: 20.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('amount'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputAmount(),
                           SizedBox(height: 20.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('wallet_type'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              border: Border.all()),
                              child: DropdownButton(
                                isExpanded: true,
                                value: _value,
                                items: [
                                  DropdownMenuItem(
                                    child: Text('USDT'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(MyLocalizations.of(context).getData('gas')),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(MyLocalizations.of(context).getData('gas_pingyi')),
                                    value: 3,
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                }),
                          ),
                           SizedBox(height: 20.0),
                          
                          Container(
                            child: Text(MyLocalizations.of(context).getData('email'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputEmail(),
                          SizedBox(height: 20.0),
                          
                          Container(
                            child: Text(MyLocalizations.of(context).getData('vcode'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputVcode(),
                          SizedBox(height: 20.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('sec_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputPassword(),
                          SizedBox(height: 20.0),

                          AbsorbPointer(
                            absorbing: !_firstPress,
                            child: GestureDetector(
                              onTap: ()async{
                                var tmap = new Map<String, dynamic>();
                                setState(() {
                                  tmap['otp'] =vcodeController.text;
                                  checkOtp(tmap);
                                  _firstPress = false ;
                                  print(tmap['otp']);
                                });
                              }, 
                              child: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Color(0xfff9f21a), Color(0xfff9f21a)])
                                    ),
                                    height: MediaQuery.of(context).size.height / 15,
                                    alignment: Alignment.center,
                                    child: Text(
                                      MyLocalizations.of(context).getData('submit'),
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      )),
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

   _inputEmail() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 250,
              child: TextFormField(
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  enabled: false,
                  controller: emailController,
                  validator: validateInput,
                  decoration: new InputDecoration(
                  contentPadding: const EdgeInsets.all(8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                  onSaved: (str) {
                  }),
            ),
          ],
        ),
        Expanded(
          child: AbsorbPointer(
            absorbing: !_firstPressTwo,
            child: GestureDetector(
              onTap: (){
                if(emailController.text == ''){
                    AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: MyLocalizations.of(context).getData('error'),
                    desc: MyLocalizations.of(context).getData('enter_email'),
                    btnOkOnPress: () {},
                    btnOkIcon: Icons.cancel,
                    btnOkColor: Colors.red)
                    ..show();
                }else{
                   setState(() {
                    var tmap = new Map<String, dynamic>();
                    tmap['otp_type'] = 'email';
                    postOtp(tmap);
                    startTimer();
                    _firstPressTwo = false ;
                });
                }
              },
            child: 
            _start ==60?
            Icon(Icons.send,color: Color(0xfff6fb15),):
            Container(
              margin: EdgeInsets.only(left:20),
              child: Text("$_start",style: TextStyle(color: Colors.white,fontSize: 20),))
            ),
          )
        )
      ],
    );
  }

 

  _inputVcode() {
    return new Container(
      child: TextFormField(
        controller: vcodeController,
        validator: validateInput,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
        keyboardType: TextInputType.text,
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  _inputUsername() {
    return new Container(
      child: TextFormField(
        controller: usernameController,
        validator: validateUsername,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
              contentPadding: const EdgeInsets.all(14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey, width: 10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
        keyboardType: TextInputType.text,
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  _inputAmount() {
    return new Container(
      child: TextFormField(
        controller: amountController,
        validator: validateAmount,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
              contentPadding: const EdgeInsets.all(14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey, width: 10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
        keyboardType: TextInputType.number,
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  _inputPassword() {
    return new Container(
      child: TextFormField(
        controller: secpwdController,
        obscureText: visible,
        validator: validatePassword,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
              contentPadding: const EdgeInsets.all(14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey, width: 10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
        keyboardType: TextInputType.text,
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  String validateInput(String value) {
    if (value.isEmpty) {
      return MyLocalizations.of(context).getData('value_fill_in');
    } 
    return null;
  }

  String validateUsername(String value) {
    if (value.isEmpty) {
      return  MyLocalizations.of(context).getData('value_fill_in');
    } 
    return null;
  }

    String validateAmount(String value) {
    if (value.isEmpty) {
      return  MyLocalizations.of(context).getData('value_fill_in');
    } 
    return null;
  }
  
  String validatePassword(String value) {
    if (value.isEmpty) {
      return  MyLocalizations.of(context).getData('value_fill_in');
    } 
    return null;
  }

  postOtp(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/member/requestUserOTP", bodyData, token, context);

    print(contentData);
    if (contentData != null) {
      if (contentData['code'] == 0) {
        AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        autoHide: Duration(seconds: 2),
        title: MyLocalizations.of(context).getData('success'),
        desc:MyLocalizations.of(context).getData('otp_sent'),
        onDissmissCallback: () {
         otp = contentData['data'];
         print(otp);
        })
      ..show();
    } else {
     
    }
    }
  }

  checkOtp(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/member/checkUserOTP", bodyData, token, context);

    print(contentData);
    if (contentData != null) {
      if (contentData['code'] == 0) {
       _sendToServer();
    } else {
     
    }
    setState(() {
      _firstPress = true ;
    });
    }
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/wallet/wallet-transafer", bodyData, token, context);
    
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
      _firstPress = true ;
    });
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          if(_value == 1){
            finalValue = '1';
          }
          else if(_value == 2){
            finalValue = '2';
          }
          else if(_value == 3){
            finalValue = '3';
          }
          tmap['username'] = usernameController.text;
          tmap['amount'] = amountController.text;
          tmap['transfer_type'] = finalValue;
          tmap['sec_password'] = secpwdController.text;
        });
      postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
