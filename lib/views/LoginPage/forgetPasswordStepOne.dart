import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/main.dart';
import 'package:robot/views/LoginPage/forgetPassword.dart';
import 'package:robot/views/LoginPage/registerPage.dart';
import 'package:robot/views/Part/pageView.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'countryPicker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ForgetPwdStepOne extends StatefulWidget {
  final url;
  final onChangeLanguage;

  ForgetPwdStepOne(this.url, this.onChangeLanguage);
  @override
  _ForgetPwdStepOneState createState() => _ForgetPwdStepOneState();
}

class _ForgetPwdStepOneState extends State<ForgetPwdStepOne>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController usernameController = TextEditingController();
  TextEditingController vcodeController = TextEditingController();

  var selectedCountryID;
  var selectedCountryCode = '+60';
  var countryList;
  var otp;
  List<String> countryName = [];

  bool _validate = false;
  bool visible = true;
  var currentlanguage;
  String mobile, vcode;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    currentlanguage = prefs.getString('language');
   
  }
 
  getCountryList() async {
    var contentData = await Request()
        .getRequest(Config().url + "api/global/country_list", context);

    if (contentData != null) {
      if (contentData['status'] == true) {
        countryList = contentData['data'];
        for (var i = 0; i < countryList.length; i++) {
          setState(() {
            if (countryList[i]["name_en"] == 'Malaysia') {
              selectedCountryCode = countryList[i]["country_code"];
              selectedCountryID = countryList[i]['id'];
            }
            countryName.add(countryList[i]["name_en"] +" " +"(" +countryList[i]["country_code"] +")");
          });
        }
      }
    }
  }

  postOtp(dynamic data) async {
    var contentData = await Request().postWithoutToken(Config().url + "api/auth/request-user-otp", data, context);
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

  @override
  void initState() {
    super.initState();
    getCountryList();
    getLanguage();
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
                                    .getData('forget_password'),
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            
                            _inputUsername(),
                            SizedBox(height: 20.0),
                            
                            _inputVcode(),
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
                            Container(
                              margin: EdgeInsets.only(bottom: 25),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 30),
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Text(
                                            MyLocalizations.of(context)
                                                .getData('sign_in'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white70),
                                          )),
                                    ),
                                  ]),
                            ),
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
  _inputUsername() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 250,
              child: TextFormField(
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  controller: usernameController,
                  validator: validateVcode,
                  decoration: new InputDecoration(
                  hintText: MyLocalizations.of(context).getData('username'),
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
              if(usernameController.text == ''){
                  AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: false,
                  title: MyLocalizations.of(context).getData('error'),
                  desc: MyLocalizations.of(context).getData('enter_username'),
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: Colors.red)
                  ..show();
              }else{
                 setState(() {
                  Map<String, dynamic> map = {};
                  map['lang'] = currentlanguage == 'zh'?'cn':currentlanguage;
                  map['username'] = usernameController.text;
                  print(map['lang']);
                  print(map['username']);
                  postOtp(map);
              });
              }
            },
          child: Icon(Icons.send,color: Colors.white,)
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
        validator: validateVcode,
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

  String validateVcode(String value) {
    if (value.isEmpty) {
      return MyLocalizations.of(context).getData('vcode_required');
    } 
    return null;
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['username'] = usernameController.text;
          tmap['password'] = vcodeController.text;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ForgetPwd(
                      widget.url,
                      widget.onChangeLanguage,usernameController.text,vcodeController.text)),
            ).then((value) {Navigator.pop(context, true);});
        });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
