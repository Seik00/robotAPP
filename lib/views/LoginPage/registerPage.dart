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
import 'package:fluttertoast/fluttertoast.dart';
import 'countryPicker.dart';

class RegisterPage extends StatefulWidget {
  final url;
  final onChangeLanguage;

  RegisterPage(this.url,this.onChangeLanguage);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  var selectedCountryCode = '+60';
  var countryList;
  List<String> countryName = [];
  
  bool _validate = false;
  bool visible = true;

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
            }
            countryName.add(countryList[i]["name_en"] +
                " " +
                "(" +
                countryList[i]["country_code"] +
                ")");
          });
        }
      }
    }
  }

  // postData(dynamic data) async {
  //   print('4556');
  //   var contentData = await Request()
  //       .postWithoutToken(Config().url + "api/auth/login", data, context);
  //   print(contentData);
  //   print(url);
  //   if (contentData != null) {
  //     if (contentData['code'] != 0) {
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString("token", contentData['token']);

  //       Fluttertoast.showToast(
  //         msg: 'Welcome',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Color(0xFFDCDCDC),
  //         textColor: Colors.black,
  //       );

  //       Timer(
  //           Duration(seconds: 0),
  //           () => Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => TopViewing(
  //                       widget.url,
  //                       widget.onChangeLanguage))));
      
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: 'Login Failed',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Color(0xFFDCDCDC),
  //         textColor: Colors.black,
  //       );
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
 
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     appBar: PreferredSize(
        child: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0,), 
        preferredSize: Size.fromHeight(0)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/img/background.png"),
            fit: BoxFit.cover,
          ),
        ),
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
                          MyLocalizations.of(context).getData('register'),
                          style: TextStyle(
                              fontSize: 48, fontWeight: FontWeight.w900,color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _inputUserName(),
                      SizedBox(height: 30.0),
                      _inputPassword(),
                      SizedBox(height: 30.0),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                                MyLocalizations.of(context).getData('register'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white)),
                          ),
                          Container(
                            child: GestureDetector(
                                onTap: () {
                                  _sendToServer();
                                },
                                child:Container(
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
                                      ).then((value) {Navigator.pop(context, true);});
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
          ],
        ),
      ),
    );
  }

  _inputUserName() {
    return new Container(
      width: 250,
      child: TextFormField(
        controller: nameController,
        validator: validateUsername,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          isDense: true,
          hintText: MyLocalizations.of(context).getData('username'),
          hintStyle: TextStyle(color: Colors.white70),
          suffixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
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
        decoration: InputDecoration(
          isDense: true,
          hintText: MyLocalizations.of(context).getData('password'),
          hintStyle: TextStyle(color: Colors.white70),
          suffixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
        ),
        keyboardType: TextInputType.text,
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  // _inputUserName() {
  //   return Stack(
  //     children: [
  //       new TextFormField(
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         textAlign: TextAlign.left,
  //         controller: nameController,
  //         validator: validateMobile,
  //         decoration: new InputDecoration(
  //           prefixText: 'Prefix',
  //           prefixStyle: TextStyle(color: Colors.white),
  //           contentPadding: const EdgeInsets.all(16.0),
  //           hintText: MyLocalizations.of(context).getData('username'),
  //           filled: true,
  //           fillColor: Colors.white,
  //         ),
  //         //validator: UIData.validateEmail,
  //         // onSaved: (str) {
  //         //   userName = str;
  //         // },
  //       ),
  //     ],
  //   );
  // }

  // _inputPassword() {
  //   return TextFormField(
  //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //       textAlign: TextAlign.center,
  //       controller: passwordController,
  //       obscureText: visible,
  //       validator: validatePassword,
  //       decoration: InputDecoration(
  //           contentPadding: const EdgeInsets.all(16.0),
  //           hintText: MyLocalizations.of(context).getData('password'),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(16.0),
  //             borderSide: BorderSide(color: Colors.grey[700], width: 1),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(16.0),
  //             borderSide: BorderSide(color: Colors.grey[700], width: 1),
  //           ),
  //           filled: true,
  //           fillColor: Colors.white,
  //           suffix: InkWell(
  //             child: visible
  //                 ? Icon(
  //                     Icons.visibility_off,
  //                     size: 18,
  //                     color: Colors.blueAccent[800],
  //                   )
  //                 : Icon(
  //                     Icons.visibility,
  //                     size: 18,
  //                     color: Colors.blueAccent[800],
  //                   ),
  //             onTap: () {
  //               setState(() {
  //                 visible = !visible;
  //               });
  //             },
  //           )),
  //       onSaved: (str) {
  //         // password = str;
  //       });
  // }

  String validateUsername(String value) {
    String pattern = r'(^[a-zA-Z0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Username is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Username must be a-z and A-Z';
    }
    return null;
  }

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.replaceAll(" ", "").isEmpty) {
      return 'Mobile is required';
    } else if (!regExp.hasMatch(value.replaceAll(" ", ""))) {
      return 'Mobile number must be digits';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  _sendToServer() {
    print('123');
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['username'] = nameController.text;
          tmap['password'] = passwordController.text;
        });
      // postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
