import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:awesome_dialog/awesome_dialog.dart';

class CustomerService extends StatefulWidget {
  final url;

  CustomerService(this.url);
  @override
  _CustomerServiceState createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _bodyController = new TextEditingController();
  
  final GlobalKey<FormState> _key = new GlobalKey();    
  bool _validate = false;
  bool visible = true;
  int _value = 1;
  var finalValue;

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/ticket/create-ticket", bodyData, token, context);
    
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
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        title: MyLocalizations.of(context).getData('error'),
        desc: contentData['message'],
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
    }
    setState(() {
     
    });
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
                          MyLocalizations.of(context).getData('contact_service'),
                          style: Theme.of(context).textTheme.headline1)),
                  SizedBox(height: 50),
                   Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                  child: Form(
                      key: _key,
                      autovalidate: _validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30.0),
                          Container(
                            child: Text(MyLocalizations.of(context).getData('title'),style: TextStyle(color: Colors.white,fontSize: 16),),
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
                                  child: Text(MyLocalizations.of(context).getData('deposit_problem')),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text(MyLocalizations.of(context).getData('withdraw_problem')),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                   child: Text(MyLocalizations.of(context).getData('system_problem')),
                                  value: 3
                                ),
                                DropdownMenuItem(
                                    child: Text(MyLocalizations.of(context).getData('function_problem')),
                                    value: 4
                                ),
                                DropdownMenuItem(
                                    child: Text(MyLocalizations.of(context).getData('others_problem')),
                                    value: 5
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                });
                              }),
                          ),             
                          //_inputTitle(),
                          SizedBox(height: 30.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('content'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputBody(),
                          SizedBox(height: 30.0),

                          GestureDetector(
                            onTap: ()async{
                              setState(() {
                              _sendToServer();
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

  _inputTitle() {
    return new Container(
      child: TextFormField(
        controller: _titleController,
        validator: validatTitle,
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

  _inputBody() {
    return new Container(
      child: TextFormField(
        controller: _bodyController,
        validator: validateBody,
        keyboardType: TextInputType.multiline,
        maxLength: null,
        maxLines: null,
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
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  String validatTitle(String value) {
    if (value.isEmpty) {
      return  MyLocalizations.of(context).getData('value_fill_in');
    }
    return null;
  }

  String validateBody(String value) {
    if (value.isEmpty) {
      return  MyLocalizations.of(context).getData('value_fill_in');
    }
    return null;
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          if(_value == 1){
            finalValue = MyLocalizations.of(context).getData('deposit_problem');
          }
          else if(_value == 2){
            finalValue = MyLocalizations.of(context).getData('withdraw_problem');
          }
          else if(_value == 3){
            finalValue = MyLocalizations.of(context).getData('system_problem');
          }
          else if(_value == 4){
            finalValue = MyLocalizations.of(context).getData('function_problem');
          }
          else if(_value == 5){
            finalValue = MyLocalizations.of(context).getData('others_problem');
          }
          tmap['title'] = finalValue;
          tmap['body'] = _bodyController.text;
          print(tmap['title']);
        });
        postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
  
  
}
