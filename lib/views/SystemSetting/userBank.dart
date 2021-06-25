import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/LoginPage/countryPicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:awesome_dialog/awesome_dialog.dart';

class UserBank extends StatefulWidget {
  final url;

  UserBank(this.url);
  @override
  _UserBankState createState() => _UserBankState();
}

class _UserBankState extends State<UserBank> {
  final TextEditingController bankCountryController = new TextEditingController();
  final TextEditingController bankNameController = new TextEditingController();
  final TextEditingController bankUserController = new TextEditingController();
  final TextEditingController bankNumberController = new TextEditingController();
  final TextEditingController bankBranchController = new TextEditingController();
  final TextEditingController swiftCodeController = new TextEditingController();
  final TextEditingController secPwdController = new TextEditingController();

  final GlobalKey<FormState> _key = new GlobalKey();    
  bool _validate = false;
  bool visible = true;

  var selectedCountryID;
  var selectedCountryCode ;
  var countryList;
  List<String> countryName = [];
  String mobile;
  var language;
  var dataList;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
  }

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-bank-info", context);
    if(contentData['data']!=null){
   
      if (contentData['code'] == 0) {
        if (mounted) {
          setState(() {
            selectedCountryCode = contentData['data']['country']['name'];
            bankNameController.text = contentData['data']['bank_name'];
            bankUserController.text = contentData['data']['bank_user'];
            bankNumberController.text = contentData['data']['bank_number'];
            bankBranchController.text = contentData['data']['branch'];
             dataList = contentData['data'];
            
          });
        }
       
      }
    }
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
              selectedCountryCode = language == 'en'?countryList[i]["name_en"]:countryList[i]["name"];
              selectedCountryID = countryList[i]['id'];
            }
            countryName.add(language == 'en'?countryList[i]["name_en"]:countryList[i]["name"]);
          });
        }
      }
    }
    getRequest();
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
    getCountryList();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/member/user-bank", bodyData, token, context);
    
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
      
    }
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
                          dataList == null?MyLocalizations.of(context).getData('enter_bank_detail'):
                          MyLocalizations.of(context).getData('change_bank_detail'),
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
                            child: Text(MyLocalizations.of(context).getData('bank_country'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          countryList == null?Container():
                          _inputBankCountry(),
                          SizedBox(height: 30.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('bank_name'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputBankName(),
                          SizedBox(height: 30.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('bank_user'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputBankUser(),
                          SizedBox(height: 30.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('bank_number'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputBankNumber(),
                        
                          SizedBox(height: 30.0),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('bank_branch'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputBankBranch(),
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
  
  _inputBankCountry() {
    return Row(
      children: [
            Container(
               width: MediaQuery.of(context).size.width/1.2,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
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
                    selectedCountryCode = language =='en'?countryList[index]["name_en"]:countryList[index]["name"];
                    selectedCountryID = countryList[index]["id"];
                  });
                 
                },
              ),
            ),
      ],
    );
  }
  
  // _inputBankCountry() {
  //   return new Container(
  //       width: MediaQuery.of(context).size.width,
  //       decoration: new BoxDecoration(
  //         border: Border.all(color: Colors.grey, width: 1),
  //               shape: BoxShape.rectangle,
  //               borderRadius: BorderRadius.circular(12),
  //               color: Colors.white,
  //       ),
  //     // color: Colors.red,
  //     child: CountryPicker(
  //       name: selectedCountryCode,
  //       lists: countryName,
  //       iconColor: Colors.white,
  //       backgroundColor: Colors.white,
  //       borderRadius: BorderRadius.circular(5),
  //       borderSide: BorderSide(width: 1, color: Colors.white),
  //       onChange: (index) {
  //         setState(() {
  //           selectedCountryID = countryList[index]["id"];
  //         });
  //       },
  //     ),
  //   );
  // }

  _inputBankName() {
    return new Container(
      child: TextFormField(
        controller: bankNameController,
        validator: validatInput,
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

  _inputBankUser() {
    return new Container(
      child: TextFormField(
        controller: bankUserController,
        validator: validatInput,
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

  _inputBankNumber() {
    return new Container(
      child: TextFormField(
        controller: bankNumberController,
        validator: validatInput,
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

  _inputBankBranch() {
    return new Container(
      child: TextFormField(
        controller: bankBranchController,
        validator: validatInput,
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

  _inputSwiftCode() {
    return new Container(
      child: TextFormField(
        controller: swiftCodeController,
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

  _inputSecPassword() {
    return new Container(
      child: TextFormField(
        controller: secPwdController,
        obscureText: visible,
        validator: validatInput,
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
  
  String validatInput(String value) {
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
          tmap['bank_country'] = selectedCountryID.toString();
          tmap['bank_name'] = bankNameController.text;
          tmap['bank_user'] = bankUserController.text;
          tmap['bank_number'] = bankNumberController.text;
          tmap['branch'] = bankBranchController.text;
         
          print(tmap['bank_country']);
          print(tmap['bank_name']);
          print(tmap['bank_user']);
          print(tmap['bank_number']);
        });
      postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
  
  
}
