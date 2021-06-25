import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/main.dart';
import 'package:robot/views/LoginPage/countryPicker.dart';
import 'package:robot/views/LoginPage/forgetPassword.dart';
import 'package:robot/views/LoginPage/registerPage.dart';
import 'package:robot/views/LoginPage/registerStepOne.dart';
import 'package:robot/views/Part/pageView.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';

class VerifyOtp extends StatefulWidget {
  final url;
  final onChangeLanguage;

  VerifyOtp(this.url, this.onChangeLanguage);
  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController mobileController = TextEditingController();
  TextEditingController vcodeController = TextEditingController();

  var selectedCountryID;
  var selectedCountryCode = '+60';
  var countryList;
  List<String> countryName = [];
  var otp;
  var refId;
  var mobileNumber;

  bool _validate = false;
  bool visible = true;
  var currentlanguage;
  String mobile, vcode;

  int _counter = 0;
  AnimationController _controller;
  int levelClock = 180;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
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
            countryName.add(currentlanguage=='zh'?countryList[i]["name"] +" " +"(" +countryList[i]["country_code"] +")":countryList[i]["name_en"] +" " +"(" +countryList[i]["country_code"] +")");
          });
        }
      }
    }
  }

  postData(dynamic data) async {
    var contentData = await Request().postWithoutToken(Config().url + "api/auth/check-otp", data, context);
    print(contentData);
    print(url +'api/auth/check-otp');
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) =>  RegisterStepOne(widget.url,widget.onChangeLanguage,refId,otp,mobileNumber)),
          // );
        })
      ..show();
    } else {
      
    }
    }
  }

  postOtp(dynamic data) async {
    var contentData = await Request().postWithoutToken(Config().url + "api/auth/request-otp", data, context);
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
         mobileNumber = mobileController.text;
         otp = contentData['data'];
         print(mobileNumber);
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
    
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
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
                                    .getData('verify_number'),
                                style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Container(
                              child: Text(MyLocalizations.of(context).getData('mobile'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            _inputMobile2(),
                            SizedBox(height: 20.0),
                            Container(
                              child: Text(MyLocalizations.of(context).getData('vcode'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            _inputVcode(),
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
  _inputMobile2() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 250,
              child: TextFormField(
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: mobileController,
                  validator: validateMobile,
                  decoration: new InputDecoration(
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
            Container(
              width: 80,
              // color: Colors.red,
              child: CountryPicker(
                name: selectedCountryCode,
                lists: countryName,
                iconColor: Colors.white,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.white),
                onChange: (index) {
                  setState(() {
                    selectedCountryCode = countryList[index]["country_code"];
                    selectedCountryID = countryList[index]["id"];
                  });
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: GestureDetector(
            onTap: (){
              if(mobileController.text == ''){
                  AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: false,
                  title: MyLocalizations.of(context).getData('error'),
                  desc: MyLocalizations.of(context).getData('enter_mobile'),
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: Colors.red)
                  ..show();
              }else{
                 setState(() {
                  Map<String, dynamic> map = {};
                  map['country_id'] = selectedCountryID.toString();
                  map['lang'] = currentlanguage == 'zh'?'cn':currentlanguage;
                  map['mobile_no'] = mobileController.text;
                  print(map['country_id']);
                  print(map['lang']);
                  print(map['mobile_no']);
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
  _inputMobile() {
    return Stack(
      children: [
        Container(
          width: 250,
          child: TextFormField(
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: mobileController,
              validator: validateMobile,
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
                mobile = str;
              }),
        ),
        Container(
          width: 80,
          // color: Colors.red,
          child: CountryPicker(
            name: selectedCountryCode,
            lists: countryName,
            iconColor: Colors.white,
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 1, color: Colors.white),
            onChange: (index) {
              setState(() {
                selectedCountryCode = countryList[index]["country_code"];
                selectedCountryID = countryList[index]["id"];
              });
            },
          ),
        ),
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

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['mobile_no'] = mobileController.text;
          tmap['otp'] = vcodeController.text;
          print('====================');
          print(tmap['mobile_no']);
          print(tmap['otp']);
          postData(tmap);
        });
      
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
