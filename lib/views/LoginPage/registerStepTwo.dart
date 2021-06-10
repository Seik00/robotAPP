import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/main.dart';
import 'package:robot/views/LoginPage/forgetPassword.dart';
import 'package:robot/views/LoginPage/loginPage.dart';
import 'package:robot/views/LoginPage/registerPage.dart';
import 'package:robot/views/Part/pageView.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'countryPicker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class RegisterStepTwo extends StatefulWidget {
  final url;
  final onChangeLanguage;
  final selectedCountryID;
  final username;
  final mobile;
  final selectedCountryCode;
  final refId;
  final otp;

  RegisterStepTwo(this.url, this.onChangeLanguage,this.selectedCountryID,this.username,this.mobile,this.selectedCountryCode,this.refId,this.otp);
  @override
  _RegisterStepTwoState createState() => _RegisterStepTwoState();
}

class _RegisterStepTwoState extends State<RegisterStepTwo>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController refIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController secPwdController = TextEditingController();

  bool _validate = false;
  bool visible = true;

  getrefId(){
    refIDController.text = widget.refId;
  }
  @override
  void initState() {
    super.initState();
    getrefId();
   print(widget.mobile);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/img/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
            
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context, true)),
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
                                MyLocalizations.of(context)
                                    .getData('register_account'),
                                style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Container(
                              child: Text(MyLocalizations.of(context).getData('ref_id'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            _inputRefID(),
                            SizedBox(height: 20.0),
                            Container(
                              child: Text(MyLocalizations.of(context).getData('new_pwd'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            _inputPassword(),
                            SizedBox(height: 20.0),
                            Container(
                              child: Text(MyLocalizations.of(context).getData('new_confirm_pwd'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            _inputConfirmPassword(),

                            SizedBox(height: 20.0),

                            if(widget.otp == null)
                            Container(
                              child: Text(MyLocalizations.of(context).getData('sec_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            if(widget.otp == null)
                            _inputSecPwd(),
                            SizedBox(height: 5.0),
                            if(widget.otp == null)
                            Text(MyLocalizations.of(context).getData('self_sec_pwd'),style: TextStyle(color: Colors.red),),
                            
                            SizedBox(height: 30.0),
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                      MyLocalizations.of(context).getData('next'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.white)),
                                ),
                                Container(
                                  child: GestureDetector(
                                      onTap: () {
                                        widget.otp !=null?
                                        _sendWithoutSecPwd():
                                        _sendToServer();
                                      },
                                      child:  Container(
                                        margin: EdgeInsets.only(right:20),
                                        width: 80.0,
                                        height: 80.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage("lib/assets/img/arrow.png")
                                          )
                                      )),),
                                )
                              ],
                            )),
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

  _inputRefID() {
    return new Container(
      width: 250,
      child: TextFormField(
        controller: refIDController,
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

  _inputPassword() {
    return new Container(
      width: 250,
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
      width: 250,
      child: TextFormField(
        controller: confirmPasswordController,
        obscureText: visible,
        autofocus: false,
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

  _inputSecPwd() {
    return new Container(
      width: 250,
      child: TextFormField(
        controller: secPwdController,
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

  String validateInput(String value) {
    if (value.isEmpty) {
      return MyLocalizations.of(context).getData('vcode_required');
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

  _sendWithoutSecPwd() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['country_id'] = widget.selectedCountryID.toString();
          tmap['username'] = widget.username;
          tmap['contact_number'] = widget.mobile;
          tmap['ref_id'] = refIDController.text;
          tmap['password'] = passwordController.text;
          tmap['password_confirmation'] = confirmPasswordController.text;
          print(tmap['username']);
          print(tmap['email']);
          print(tmap['contact_number']);
          print(tmap['ref_id']);
          print(tmap['password']);
          print(tmap['password_confirmation']);
          print('===========================================');
        });
       postWithoutSecPwd(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['country_id'] = widget.selectedCountryID.toString();
          tmap['username'] = widget.username;
          tmap['contact_number'] = widget.mobile;
          tmap['ref_id'] = refIDController.text;
          tmap['password'] = passwordController.text;
          tmap['password_confirmation'] = confirmPasswordController.text;
          tmap['sec_password'] = secPwdController.text;
          print(tmap['username']);
          print(tmap['email']);
          print(tmap['contact_number']);
          print(tmap['ref_id']);
          print(tmap['password']);
          print(tmap['password_confirmation']);
          print(tmap['sec_password']);
          print('===========================================');
        });
       postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/member/register-member", bodyData, token, context);
    
    print(contentData);
    if(contentData!=null){
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
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TopViewing(
                      widget.url, widget.onChangeLanguage)));
            })
          ..show();
    } else {
     
    }
    }
  }
  postWithoutSecPwd(dynamic data) async {
    var contentData = await Request().postWithoutToken(Config().url + "api/auth/signup",data,context);
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
           Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                      widget.url, widget.onChangeLanguage)));
        })
      ..show();
      } else {
       
      }
    }
  }
}
