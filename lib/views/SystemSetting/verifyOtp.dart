import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/LoginPage/countryPicker.dart';
import 'package:robot/views/LoginPage/freeRegister.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

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

  TextEditingController countryController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vcodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  var selectedCountryID;
  var selectedCountryCode = '+60';
  var selectedPhoneCode;
  var countryList;
  List<String> countryName = [];

  bool _validate = false;
  bool visible = true;
  var username,email,mobile;

  var language;
  var token;
  var otp;
  Timer _timer;
  int _start = 60;
  var _firstPress = true ;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 60;
            _firstPress = true ;
          });
        } else {
          setState(() {
            _start--;
            print(_start);
          });
        }
      },
    );
  }

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    setState(() {
       if(language=='zh'){
        language='cn';
    }
    });
   
    print(language);
    token = prefs.getString('token');
  }

  getCountryList() async {
    var contentData = await Request().getWithoutRequest(Config().url + "api/global/country_list", context);
    print(contentData);
    if (contentData != null) {
      if (contentData['status'] == true) {
        countryList = contentData['data'];
        for (var i = 0; i < countryList.length; i++) {
          setState(() {
            if (countryList[i]["name_en"] == 'Malaysia') {
              selectedCountryCode = language == 'zh'?countryList[i]["name"]:countryList[i]["name_en"];
              selectedCountryID = countryList[i]['id'];
              phoneController.text = countryList[i]["country_code"];
            }
            countryName.add(language == 'zh'?countryList[i]["name"]:countryList[i]["name_en"]);
          });
        }
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
    _timer.cancel();
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

                            countryList == null?Container():
                            _inputBankCountry(),
                            SizedBox(height: 20.0),
                            
                            // _inputMobile(),
                            //   SizedBox(height: 20.0),

                            _inputVcode(),
                              SizedBox(height: 20.0),

                            Container(
                            child: GestureDetector(
                            onTap: ()async{
                              setState(() {
                                postData();
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
                            // Container(
                            //   margin: EdgeInsets.only(bottom: 25),
                            //   child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Container(
                            //           padding: EdgeInsets.only(right: 30),
                            //           child: GestureDetector(
                            //               onTap: () {
                            //                 Navigator.pop(context, true);
                            //               },
                            //               child: Text(
                            //                 MyLocalizations.of(context)
                            //                     .getData('sign_in'),
                            //                 style: TextStyle(
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 20,
                            //                     color: Colors.white70),
                            //               )),
                            //         ),
                            //       ]),
                            // ),
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

 _inputBankCountry() {
    return Row(
      children: [
            Container(
               width:250,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
             
              child: CountryPicker(
                name: selectedCountryCode,
                lists: countryName,
                iconColor: Colors.white,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.white),
                onChange: (index) {
                     setState(() {
                    selectedCountryCode = language =='zh'?countryList[index]["name"]:countryList[index]["name_en"];
                    selectedCountryID = countryList[index]["id"];
                    phoneController.text = countryList[index]["country_code"];
                    print(selectedPhoneCode);
                  });
                 
                },
              ),
            ),
      ],
    );
  }

  _inputMobile() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 250,
              child: TextFormField(
                controller: mobileController,
                validator: validateMobile,
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: new InputDecoration(
                hintText: MyLocalizations.of(context).getData('phone'),
                contentPadding: const EdgeInsets.only(top:16.0,bottom: 16,left: 70,right: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
            ),
            Container(
              padding: EdgeInsets.only(top:2.0,left:8),
              width: 80,
              // color: Colors.red,
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    selectedPhoneCode = text;
                    print(selectedPhoneCode);
                  });
                 
                },
                controller: phoneController,
                enabled: false,
              ),
            ),
          ],
        ),
      ],
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
          child: AbsorbPointer(
            absorbing: !_firstPress,
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
                    tmap['country_id'] = selectedCountryID.toString();
                    tmap['email'] = emailController.text;
                    tmap['lang'] = language;
                    //tmap['contact_number'] = mobileController.text;
                    print('===========================================');
                    print(tmap['country_id']);
                    print(tmap['email']);
                    print(tmap['lang']);
                    print('===========================================');
                    postOtp(tmap);
                    startTimer();
                    _firstPress = false ;
                });
                }
              },
            child: 
            _start ==60?
            Icon(Icons.send,color: Color(0xfff6fb15),):
            Container(
              margin: EdgeInsets.only(left:20),
              child: Text("$_start",style: TextStyle(color: Color(0xfff6fb15),fontSize: 20),))
            ),
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

  postOtp(dynamic data) async {
    var contentData = await Request().postWithoutToken(Config().url + "api/global/sent-otp", data, context);
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
  
  postData() async {
      if (_key.currentState.validate()) {
      _key.currentState.save();
        var body = {
          'contact': emailController.text,
          'otp': vcodeController.text,
        };
        print(body);
        var uri = Uri.https(Config().url2, 'api/global/check-otp', body);

        var response = await http.get(uri, headers: {
          'Authorization': 'Bearer $token'
        }).timeout(new Duration(seconds: 10));
        var contentData = json.decode(response.body);
        print(contentData);
        if(contentData!=null){
          if (contentData['code'] == 0) {
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FreeRegister( widget.url, widget.onChangeLanguage)));
          } else if(contentData['message']=='INCORRECT_OTP'){
             AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: false,
              title: MyLocalizations.of(context).getData('error'),
              desc: MyLocalizations.of(context).getData('incorrect_otp'),
              btnOkOnPress: () {},
              btnOkIcon: Icons.cancel,
              btnOkColor: Colors.red)
              ..show();
          }
        }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
