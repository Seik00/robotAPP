import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/main.dart';
import 'package:robot/views/LoginPage/loginPage.dart';
import 'package:robot/views/LoginPage/registerPage.dart';
import 'package:robot/views/Part/pageView.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'countryPicker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ForgetPwd extends StatefulWidget {
  final url;
  final onChangeLanguage;
  final emailUsername;

  ForgetPwd(this.url,this.onChangeLanguage,this.emailUsername);
  @override
  _ForgetPwdState createState() => _ForgetPwdState();
}

class _ForgetPwdState extends State<ForgetPwd>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  
  var currentlanguage;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    currentlanguage = prefs.getString('language');
   
  }
  
  bool _validate = false;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    getLanguage();
    print(widget.emailUsername);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Color(0xff212630),
     appBar: PreferredSize(
        child: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0,), 
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,), 
                          onPressed: ()=>Navigator.pop(context, true)
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                    child: Form(
                        key: _key,
                        autovalidate: _validate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                MyLocalizations.of(context).getData('forget_password'),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w900,color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Container(
                              child: Text(MyLocalizations.of(context).getData('new_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            _inputPassword(),
                            SizedBox(height: 30.0),
                            Container(
                              child: Text(MyLocalizations.of(context).getData('confirm_new_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            _inputConfirmPassword(),
                            SizedBox(height: 30.0),
                            Container(
                              child: GestureDetector(
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
                            ),),
                            SizedBox(height: 30.0),
                           
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

  _inputPassword() {
    return new Container(
      child: TextFormField(
        controller: passwordController,
        obscureText: visible,
        validator: validatePassword,
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

  _inputConfirmPassword() {
    return new Container(
      child: TextFormField(
        controller: confirmPasswordController,
        obscureText: visible,
       validator: (confirmation) {
          return confirmation.isEmpty
              ? MyLocalizations.of(context).getData('confirm_password_required')
              : validationEqual(confirmation, passwordController.text)
                  ? null
                  : MyLocalizations.of(context).getData('password_not_match');
        },
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


  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.replaceAll(" ", "").isEmpty) {
      return MyLocalizations.of(context).getData('submit');
    } else if (!regExp.hasMatch(value.replaceAll(" ", ""))) {
      return 'Mobile number must be digits';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return  MyLocalizations.of(context).getData('password_required');
    } else if (value.length < 4) {
      return MyLocalizations.of(context).getData('password_characters');
    }
    return null;
  }

   String validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Confirm password is required';
    } else if (value.length < 4) {
      return 'Confirm password must be at least 4 characters';
    }
    return null;
  }

  bool validationEqual(String currentValue, String checkValue) {
    if (currentValue == checkValue) {
      return true;
    } else {
      return false;
    }
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
        
          tmap['username'] = widget.emailUsername;
          tmap['password'] = passwordController.text;
         
        });
         postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  postData(dynamic data) async {
    var contentData = await Request().postWithoutToken(Config().url + "api/auth/reset-password",data,context);
    print(url + 'api/auth/reset-password');
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
        desc:MyLocalizations.of(context).getData('operation_success'),
        onDissmissCallback: () {
          Navigator.pop(context);
        })
      ..show();
      } else {
        
      }
    }
  }
}
