import 'dart:async';
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
class ChgUsername extends StatefulWidget {
  final url;
  final onChangeLanguage;

  ChgUsername(this.url,this.onChangeLanguage);
  @override
  _ChgUsernameState createState() => _ChgUsernameState();
}

class _ChgUsernameState extends State<ChgUsername>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController vcodeController = TextEditingController();
  bool _validate = false;
  bool visible = true;
  
  Timer _timer;
  int _start = 60;
  var _firstPressTwo = true ;
  var _firstPress = true ;
  var otp;

  @override
  void initState() {
    super.initState();
 
  }

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

   postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/member/update-member-info", bodyData, token, context);
    
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
      
    }
  }

  Future<void> confirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Color(0xfffFDE323),
            title: Center(
              child: Icon(
              Icons.warning, 
              color: Colors.black,
              size: 60,
            ),),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom:10),
                      child: Text(MyLocalizations.of(context).getData('are_you_sure'),style: TextStyle(fontSize: 18,color: Colors.black),)),
                  ),
                 
                  Center(
                    child: Text(MyLocalizations.of(context).getData('username_as'),style: TextStyle(fontSize: 15,color: Colors.black),),
                  ),
                  
                  Center(
                    child: Text(emailController.text.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,color: Colors.black)),
                  ),
                  
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('cancel'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: Text(MyLocalizations.of(context).getData('confirm'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    onPressed: () {
                      setState(() {
                        _sendToServer();
                      });
                     
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                      widget.url,
                                      widget.onChangeLanguage)),
                            )),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                      height: MediaQuery.of(context).size.height,
                        child:Container(
                          child: Form(
                              key: _key,
                              autovalidate: _validate,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 50),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      MyLocalizations.of(context).getData('set_username'),
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.w900,color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    child: Text(MyLocalizations.of(context).getData('email'),style: TextStyle(color: Colors.white,fontSize: 16),),
                                  ),
                                  SizedBox(height: 5.0),
                                  _inputEmail(),
                                  SizedBox(height: 20.0),

                                  Container(
                                    child: Text(MyLocalizations.of(context).getData('vcode'),style: TextStyle(color: Colors.white,fontSize: 16),),
                                  ),
                                  SizedBox(height: 5.0),
                                  _inputVcode(),
                                  SizedBox(height: 20.0),
                                
                                  SizedBox(height: 20.0),
                              

                                  AbsorbPointer(
                                    absorbing: !_firstPress,
                                    child: GestureDetector(
                                      onTap: ()async{
                                        var tmap = new Map<String, dynamic>();
                                        setState(() {
                                          tmap['otp'] =vcodeController.text;
                                          checkOtp(tmap);
                                          _firstPress = false ;
                                          print(tmap['otp']);
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

                                  Spacer(),
                                  SizedBox(height: 30.0),
                                ],
                              )),
                        ),
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
                  controller: emailController,
                  validator: validateInput,
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
                  }),
            ),
          ],
        ),
        Expanded(
          child: AbsorbPointer(
            absorbing: !_firstPressTwo,
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

  _inputVcode() {
    return new Container(
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

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          tmap['email'] = emailController.text;
        });
      postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
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

  checkOtp(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/member/checkUserOTP", bodyData, token, context);

    print(contentData);
    if (contentData != null) {
      if (contentData['code'] == 0) {
       confirmation();
    } else {
     
    }
    setState(() {
      _firstPress = true ;
    });
    }
  }

}
