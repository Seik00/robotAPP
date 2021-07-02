import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/LoginPage/registerStepTwo.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'countryPicker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class RegisterStepOne extends StatefulWidget {
  final url;
  final onChangeLanguage;

  RegisterStepOne(this.url, this.onChangeLanguage);
  @override
  _RegisterStepOneState createState() => _RegisterStepOneState();
}

class _RegisterStepOneState extends State<RegisterStepOne>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController countryController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController comfirmPasswordController = TextEditingController();
  TextEditingController refIDController = TextEditingController();
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

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
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
                                    .getData('sign_up'),
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white),
                              ),
                            ),
                              SizedBox(height: 20.0),
                           
                            countryList == null?Container():
                            _inputBankCountry(),
                            SizedBox(height: 20.0),
                           
                            
                            _inputUsername(),
                              SizedBox(height: 20.0),
                            
                            _inputMobile(),
                              SizedBox(height: 20.0),

                             _inputEmail(),
                              SizedBox(height: 20.0),

                             _inputPassword(),
                              SizedBox(height: 20.0),

                             _inputConfirmPassword(),
                              SizedBox(height: 20.0),

                             _inputRefID(),
                              SizedBox(height: 20.0),

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
               width:350,
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

  _inputUsername() {
    return new Container(
      child: TextFormField(
        controller: usernameController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        hintText: MyLocalizations.of(context).getData('username'),
        contentPadding: const EdgeInsets.all(14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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

  _inputMobile() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 350,
              child: TextFormField(
                controller: mobileController,
                validator: validateMobile,
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: new InputDecoration(
                hintText: MyLocalizations.of(context).getData('phone'),
                contentPadding: const EdgeInsets.only(top:14.0,bottom: 14,left: 70,right: 8),
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
              padding: EdgeInsets.only(top:3.0,left:8),
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
    return new Container(
      child: TextFormField(
        controller: emailController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        hintText: MyLocalizations.of(context).getData('email'),
        contentPadding: const EdgeInsets.all(14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
      child: TextFormField(
        controller: passwordController,
        obscureText: visible,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        hintText: MyLocalizations.of(context).getData('password'),
        contentPadding: const EdgeInsets.all(14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
        controller: comfirmPasswordController,
        obscureText: visible,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        hintText: MyLocalizations.of(context).getData('confirm_password'),
        contentPadding: const EdgeInsets.all(14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
   _inputRefID() {
    return new Container(
      child: TextFormField(
        controller: refIDController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        hintText: MyLocalizations.of(context).getData('ref_id'),
        contentPadding: const EdgeInsets.all(14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
  // _inputMobile() {
  //   return new Container(
  //     width: 250,
  //     child: Row(
  //       children: [
  //         Container(
  //           child: 
  //           Text('123'),
  //         ),
  //         TextFormField(
  //           controller: mobileController,
  //           validator: validateMobile,
  //           autofocus: false,
  //           autovalidateMode: AutovalidateMode.onUserInteraction,
  //           decoration: new InputDecoration(
  //           contentPadding: const EdgeInsets.all(8.0),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8.0),
  //             borderSide: BorderSide(color: Colors.grey, width: 1),
  //           ),
  //           filled: true,
  //           fillColor: Colors.white,
  //         ),
  //           keyboardType: TextInputType.number,
  //           onSaved: (str) {
  //             print(str);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // _inputSavedMobile() {
  //   return new Container(
  //     width: 250,
  //     child: TextFormField(
  //       controller: mobileController,
  //       autofocus: false,
  //       readOnly: true,
  //       autovalidateMode: AutovalidateMode.onUserInteraction,
  //       decoration: new InputDecoration(
  //         hintText: widget.mobileNumber,
  //       contentPadding: const EdgeInsets.all(8.0),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8.0),
  //         borderSide: BorderSide(color: Colors.grey, width: 1),
  //       ),
  //       filled: true,
  //       fillColor: Colors.white,
  //     ),
  //       keyboardType: TextInputType.number,
  //       onSaved: (str) {
  //         print(str);
  //       },
  //     ),
  //   );
  // }

  _inputVcode() {
    return new Container(
      width: 250,
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

   _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['country_id'] = selectedCountryID.toString();
          tmap['user_group'] = '1';
          tmap['username'] = usernameController.text;
          tmap['email'] = emailController.text;
          tmap['contact_number'] = mobileController.text;
          tmap['password'] = passwordController.text;
          tmap['password_confirmation'] = comfirmPasswordController.text;
          tmap['ref_id'] = refIDController.text;
          tmap['pay_type'] = 'point1';
           print('===========================================');
          print(tmap['username']);
          print(tmap['user_group']);
          print(tmap['country_id']);
          print(tmap['email']);
          print(tmap['contact_number']);
          print(tmap['ref_id']);
          print(tmap['password']);
          print(tmap['password_confirmation']);
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
             Navigator.pop(context);
            })
          ..show();
    } else {
     
    }
    }
  }
}
