import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangeWallet extends StatefulWidget {
  final url;

  ChangeWallet(this.url);
  @override
  _ChangeWalletState createState() => _ChangeWalletState();
}

class _ChangeWalletState extends State<ChangeWallet> {
final TextEditingController usernameController =
    new TextEditingController();
final TextEditingController amountController =
    new TextEditingController();
final TextEditingController secpwdController =
    new TextEditingController();
final GlobalKey<FormState> _key = new GlobalKey();    
bool _validate = false;
bool visible = true;

 var pointOne;
 var _firstPress = true ;
 getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          print(contentData);
          pointOne = contentData['point1'];
        });
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
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    ),
                  onPressed: () => Navigator.pop(context)),
                  Center(
                      child: Text(
                          MyLocalizations.of(context).getData('change_wallet'),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text('USDT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
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
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Colors.black),
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
                            child: Text(MyLocalizations.of(context).getData('amount')+' UDST',style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputAmount(),
                          SizedBox(height: 20.0),
                          
                          Container(
                            child: Text(MyLocalizations.of(context).getData('from'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputFrom(),
                          SizedBox(height: 20.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('to'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputTo(),
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
                                setState(() {
                                  _sendToServer();
                                  _firstPress = false ;
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
                            ),
                          )
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

  _inputFrom() {
    return new Container(
      child: TextFormField(
        autofocus: false,
        enabled: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              hintText: 'USDT',
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

  _inputTo() {
    return new Container(
      child: TextFormField(
        autofocus: false,
        enabled: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              hintText: MyLocalizations.of(context).getData('gas'),
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
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey, width: 1),
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

  
  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/wallet/changeWallet", bodyData, token, context);
    
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
          tmap['amount'] = amountController.text;
          tmap['transfer_type'] = 'point1';
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
