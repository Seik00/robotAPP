import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/main.dart';
import 'package:robot/views/Explore/investRecord.dart';
import 'package:robot/views/Explore/pinRecord.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyPin extends StatefulWidget {
   final url;

  BuyPin(this.url);
  @override
  _BuyPinState createState() => _BuyPinState();
}

class _BuyPinState extends State<BuyPin> {
  
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController amountController = TextEditingController();
  TextEditingController usdtController = TextEditingController();
  TextEditingController pingyiController = TextEditingController();
  TextEditingController secpwdController = TextEditingController();
  
  bool _validate = false;
  var body;
  var usdt;
  int _pinValue = 1;
  int _payValue = 1;
  var finalPinValue;
  var finalPayValue;
 
  @override
  void initState() {
    super.initState();
    getMemberInfo();
  }

  getMemberInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    print(contentData);
    if(contentData != null){
      setState(() {
      usdtController.text = contentData['point1'];
      pingyiController.text = contentData['point3'];
    });
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
                children: <Widget>[
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                             alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context, true)),
                          ),
                           Expanded(
                            child: 
                            Container(
                               alignment: Alignment.centerLeft,
                              child: Text(MyLocalizations.of(context).getData('buy_pin'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          GestureDetector(
                            onTap: (){
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PinRecord(widget.url)),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(right:5),
                              child: Text(
                                MyLocalizations.of(context).getData('pin_record'),style: TextStyle(color: Colors.white,fontSize: 16)
                              ),
                            ),
                          )
                          
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                    child: Form(
                        key: _key,
                        autovalidate: _validate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            
                             SizedBox(height: 20.0),
                            
                            Container(
                              child: Text('USDT '+ MyLocalizations.of(context).getData('balance'),style: TextStyle(color:Colors.white),),
                            ),
                             SizedBox(height: 5),
                            info(),
                            SizedBox(height: 20.0),
                            Container(
                              child: Text(MyLocalizations.of(context).getData('gas_ping_yi_balance'),style: TextStyle(color:Colors.white),),
                            ),
                             SizedBox(height: 5),
                            pingyi_info(),

                            SizedBox(height: 20.0),
                             Container(
                              child: Text(MyLocalizations.of(context).getData('pin_type'),style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(height: 5),
                            Container(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                border: Border.all()),
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: _pinValue,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('100'),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('250'),
                                      value: 2,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _pinValue = value;
                                    });
                                  }),
                            ),
                            SizedBox(height: 20.0),
                             Container(
                              child: Text(MyLocalizations.of(context).getData('pay_type'),style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(height: 5),
                            Container(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                border: Border.all()),
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: _payValue,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('USDT'),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Text(MyLocalizations.of(context).getData('gas_pingyi')),
                                      value: 3,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _payValue = value;
                                    });
                                  }),
                            ),
                            SizedBox(height: 20.0),

                            Container(
                              child: Text(MyLocalizations.of(context).getData('sec_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                            SizedBox(height: 5.0),
                            _inputPassword(),
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
 
  info() {
    return new Container(
      child: TextFormField(
        controller: usdtController,
        enabled: false, 
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
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

  pingyi_info() {
    return new Container(
      child: TextFormField(
        controller: pingyiController,
        enabled: false, 
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
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

  _inputAmount() {
    return new Container(
      child: TextFormField(
        controller: amountController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        contentPadding: const EdgeInsets.all(14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
        keyboardType: TextInputType.number,
        onSaved: (str) {
          print(str);
        },
      ),
    );
  }

  _inputPassword() {
    return new Container(
      child: TextFormField(
        controller: secpwdController,
        obscureText: true,
        validator: validateInput,
        autofocus: false,
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

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/pin/buyPin", bodyData, token, context);
    
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
    setState(() {
     
    });
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          if(_pinValue == 1){
              finalPinValue = '1';
          }
          else if(_pinValue == 2){
            finalPinValue = '2';
          }

          if(_payValue == 1){
              finalPayValue = '1';
          }
          else if(_payValue == 3){
            finalPayValue = '3';
          }
          tmap['pin_type'] = finalPinValue.toString();
          tmap['pay_type'] = finalPayValue.toString();
          tmap['sec_password'] = secpwdController.text;
          print(tmap['amount']);
        });
         postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
