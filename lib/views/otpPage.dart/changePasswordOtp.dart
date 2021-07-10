import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Explore/apiBindingForm.dart';
import 'package:robot/views/LoginPage/countryPicker.dart';
import 'package:robot/views/LoginPage/freeRegister.dart';
import 'package:robot/views/SystemSetting/changePwd.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

class ChangePasswordOtp extends StatefulWidget {
  final url;

  ChangePasswordOtp(this.url);
  @override
  _ChangePasswordOtpState createState() => _ChangePasswordOtpState();
}

class _ChangePasswordOtpState extends State<ChangePasswordOtp>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController vcodeController = TextEditingController();

 

  bool _validate = false;
  bool visible = true;
  var username,email,mobile;

  var language;
  var token;
  var otp;
  var userEmail;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    token = prefs.getString('token');
  }

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          print(contentData);
          emailController.text = contentData['email'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
    getRequest();
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
                 color: Color(0xff212630),
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
                                    .getData('get_vcode'),
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 20.0),
                           
                           _inputEmail(),
                            SizedBox(height: 20.0),
                          
                            _inputVcode(),
                              SizedBox(height: 20.0),

                            Container(
                            child: GestureDetector(
                            onTap: ()async{
                              var tmap = new Map<String, dynamic>();
                              setState(() {
                                tmap['otp'] = otp.toString();
                                postData(tmap);
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
                  hintText: MyLocalizations.of(context).getData('email'),
                  contentPadding: const EdgeInsets.all(8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                  onSaved: (str) {
                    mobile = str;
                  }),
            ),
          ],
        ),
        Expanded(
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
              });
              }
            },
          child: Icon(Icons.send,color: Color(0xfff6fb15),)
          )
        )
      ],
    );
  }

 

  _inputVcode() {
    return new Container(
      width: 250,
      child: TextFormField(
        controller: vcodeController,
        validator: validateInput,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        hintText: MyLocalizations.of(context).getData('vcode'),
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
      return MyLocalizations.of(context).getData('value_fill_in');
    } 
    return null;
  }

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.replaceAll(" ", "").isEmpty) {
      return MyLocalizations.of(context).getData('mobile_required');
    } else if (!regExp.hasMatch(value.replaceAll(" ", ""))) {
      return MyLocalizations.of(context).getData('mobile_digits');
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
        desc:MyLocalizations.of(context).getData('operation_success'),
        onDissmissCallback: () {
         otp = contentData['data'];
         print(otp);
        })
      ..show();
    } else {
     
    }
    }
  }
  
  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/member/checkUserOTP", bodyData, token, context);

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
                  builder: (context) => ChangePwd( widget.url)));
        })
      ..show();
    } else {
     
    }
    }
  }
}
