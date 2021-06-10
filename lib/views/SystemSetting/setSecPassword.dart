import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/main.dart';
import 'package:robot/views/LoginPage/loginPage.dart';
import 'package:robot/views/Part/pageView.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SetSecPassword extends StatefulWidget {
  final url;
  final onChangeLanguage;

  SetSecPassword(this.url,this.onChangeLanguage);
  @override
  _SetSecPasswordState createState() => _SetSecPasswordState();
}

class _SetSecPasswordState extends State<SetSecPassword>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _validate = false;
  bool visible = true;


  @override
  void initState() {
    super.initState();
 
  }

   postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/member/set-secpassword", bodyData, token, context);
    
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
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TopViewing(
                widget.url,
                widget.onChangeLanguage)),
        );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [
             Container(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/img/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height,
                    child:Container(
                      child: Form(
                          key: _key,
                          autovalidate: _validate,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Spacer(flex: 2,),
                              Container(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  MyLocalizations.of(context).getData('set_secpwd'),
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w900,color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: Text(MyLocalizations.of(context).getData('new_secpwd'),style: TextStyle(color: Colors.white,fontSize: 16),),
                              ),
                              SizedBox(height: 5.0),
                              _inputPassword(),
                              SizedBox(height: 30.0),
                              Container(
                                child: Text(MyLocalizations.of(context).getData('confirm_new_secpwd'),style: TextStyle(color: Colors.white,fontSize: 16),),
                              ),
                              SizedBox(height: 5.0),
                              _inputConfirmPassword(),
                              SizedBox(height: 30.0),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                        MyLocalizations.of(context).getData('submit'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white)),
                                  ),
                                  Container(
                                  child: GestureDetector(
                                  onTap: () {
                                    _sendToServer();
                                  },
                                  child: Container(
                                        margin: EdgeInsets.only(right:20),
                                        width: 80.0,
                                        height: 80.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage("lib/assets/img/arrow.png")
                                          )
                                      ))),
                            )
                                ],
                              )),
                              Spacer(),
                              SizedBox(height: 30.0),
                              Container(
                                margin: EdgeInsets.only(bottom: 25),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(right: 30),
                                        child: GestureDetector(
                                             onTap: () {
                                               Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => LoginPage(
                                                        widget.url,
                                                        widget.onChangeLanguage)),
                                              );
                                            },
                                            child: Text(
                                              MyLocalizations.of(context)
                                                  .getData('sign_in'),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,color: Colors.white70),
                                            )),
                                      ),
                                    ]),
                              ),
                            ],
                          )),
                    ),
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
          tmap['password'] = passwordController.text;
          tmap['password_confirmation'] = confirmPasswordController.text;
        });
      postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
