import 'dart:async';
import 'dart:convert';
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
import 'package:http/http.dart' as http;

class FreeRegister extends StatefulWidget {
  final url;
  final onChangeLanguage;

  FreeRegister(this.url, this.onChangeLanguage);
  @override
  _FreeRegisterState createState() => _FreeRegisterState();
}

class _FreeRegisterState extends State<FreeRegister>
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
  String _selectedLocationCN; 
  String _selectedLocationEN; 

  bool _validate = false;
  bool visible = true;
  var username,email,mobile;

  var language;
  var token;
  var otp;
  
  Timer _timer;
  int _start = 60;
  var _firstPressTwo = true ;
  var _firstPress = true ;
  int _value = 1;
  var cid;
  var fcid;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 60;
            _firstPressTwo = true ;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    token = prefs.getString('token');
  }

  getCountryList() async {
    var contentData = await Request().getWithoutRequest(Config().url + "api/global/country_list", context);
  
    if (contentData != null) {
      if (contentData['status'] == true) {
        countryList = contentData['data'];
          print(countryList);
        for (var i = 0; i < countryList.length; i++) {
          setState(() {
            if (countryList[i]["name_en"] == 'India') {
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

  select(_selectedLocationCN) async{
     var contentData = await Request().getWithoutRequest(Config().url + "api/global/country_list", context);
     cid = contentData['data'].toList();
      fcid = cid.singleWhere((element) =>
          element['name'] ==_selectedLocationCN, orElse: () {
            return null;
        });  
  }
  selectEN(_selectedLocationEN) async{
     var contentData = await Request().getWithoutRequest(Config().url + "api/global/country_list", context);
     cid = contentData['data'].toList();
      fcid = cid.singleWhere((element) =>
          element['name_en'] ==_selectedLocationEN, orElse: () {
            return null;
        });
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
                                    .getData('sign_up'),
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 20.0),
                           
                            
                            countryList == null?Container():
                            language == 'zh'?
                            Container(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              border: Border.all()),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text(MyLocalizations.of(context).getData('country')),
                                value: _selectedLocationCN,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedLocationCN = newValue;
                                    select(_selectedLocationCN);
                                  });
                                },
                                items: countryName.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                            ):
                            Container(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              border: Border.all()),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text(MyLocalizations.of(context).getData('country')),
                                value: _selectedLocationEN,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedLocationEN = newValue;
                                    selectEN(_selectedLocationEN);
                                  });
                                },
                                items: countryName.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                            ),
                           SizedBox(height: 20.0),
                            
                            _inputUsername(),
                            SizedBox(height: 20.0),

                            _inputVcode(),
                            SizedBox(height: 20.0),
                            
                            // _inputMobile(),
                            // SizedBox(height: 30.0),

                            //  _inputEmail(),
                            // SizedBox(height: 30.0),

                             _inputPassword(),
                            SizedBox(height: 20.0),

                             _inputConfirmPassword(),
                            SizedBox(height: 20.0),

                             _inputRefID(),
                            SizedBox(height: 20.0),

                          //   Container(
                          //   child: GestureDetector(
                          //   onTap: ()async{
                          //     setState(() {
                          //       _sendToServer();
                          //     });
                          //   }, 
                          //   child: Center(
                          //     child: Container(
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(10),
                          //             gradient: LinearGradient(
                          //             begin: Alignment.topCenter,
                          //             end: Alignment.bottomCenter,
                          //             colors: [Color(0xfffaef1d), Color(0xfff9f21a)])
                          //         ),
                          //         height: MediaQuery.of(context).size.height / 15,
                          //         alignment: Alignment.center,
                          //         child: Text(
                          //           MyLocalizations.of(context).getData('submit'),
                          //           style: TextStyle(color: Colors.black),
                          //         )),
                          //   ),
                          // ),),

                          AbsorbPointer(
                            absorbing: !_firstPress,
                            child: GestureDetector(
                              onTap: ()async{
                                setState(() {
                                  checkOtp();
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
                          ),

                            SizedBox(height: 30.0),
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

//  _inputBankCountry() {
//     return Row(
//       children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(
//                     color: Colors.grey,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
               
//                 child: CountryPicker(
//                   name: selectedCountryCode,
//                   lists: countryName,
//                   iconColor: Colors.white,
//                   backgroundColor: Colors.white,
//                   borderRadius: BorderRadius.circular(5),
//                   borderSide: BorderSide(width: 1, color: Colors.white),
//                   onChange: (index) {
//                        setState(() {
//                       selectedCountryCode = language =='zh'?countryList[index]["name"]:countryList[index]["name_en"];
//                       selectedCountryID = countryList[index]["id"];
//                       phoneController.text = countryList[index]["country_code"];
//                       print(selectedPhoneCode);
//                     });
                   
//                   },
//                 ),
//               ),
//             ),
//       ],
//     );
//   }

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
                  }),
            ),
          ],
        ),
        Expanded(
          child: AbsorbPointer(
            absorbing: !_firstPressTwo,
            child: GestureDetector(
              onTap: (){
                if(usernameController.text == ''){
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
                    tmap['email'] = usernameController.text;
                    tmap['lang'] = language;
                    postOtp(tmap);
                    startTimer();
                    _firstPressTwo = false ;
                });
                }
              },
            child: 
            _start ==60?
            Icon(Icons.send,color: Color(0xfff6fb15),):
            Container(
              margin: EdgeInsets.only(left:20),
              child: Text("$_start",style: TextStyle(color: Colors.white,fontSize: 20),))
            ),
          )
        )
      ],
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
                contentPadding: const EdgeInsets.only(top:18.0,bottom: 18,left: 70,right: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
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
        contentPadding: const EdgeInsets.all(18.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
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
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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

   _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['country_id'] = fcid['id'].toString();
          tmap['username'] = usernameController.text;
          tmap['email'] = usernameController.text;
          // tmap['contact_number'] = mobileController.text;
          tmap['password'] = passwordController.text;
          tmap['password_confirmation'] = comfirmPasswordController.text;
          tmap['ref_id'] = refIDController.text;
           print('===========================================');
          print(tmap['username']);
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
    var contentData = await Request().postWithoutToken(Config().url+"api/auth/signup", bodyData, context);
    
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

  checkOtp() async {
      if (_key.currentState.validate()) {
      _key.currentState.save();
        var body = {
          'contact': usernameController.text,
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
             _sendToServer();
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
          setState(() {
            _firstPress = true ;
          });
        }
    } else {
      setState(() {
        _validate = true;
      });
    }
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
        desc:MyLocalizations.of(context).getData('otp_sent'),
        onDissmissCallback: () {
         otp = contentData['data'];
         print(otp);
        })
      ..show();
    } else {
     
    }
    }
  }

}
