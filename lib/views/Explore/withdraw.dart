import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/withdrawRecord.dart';
import 'package:robot/views/SystemSetting/userBank.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Withdraw extends StatefulWidget {
  final url;

  Withdraw(this.url);
  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
final TextEditingController addressController = new TextEditingController();
final TextEditingController amountController = new TextEditingController();
final TextEditingController secpwdController = new TextEditingController();
final GlobalKey<FormState> _key = new GlobalKey();    
bool _validate = false;
bool visible = true;

var pointOne;
var selectedCountryID;
var selectedCountryCode ;
var countryList;
List<String> countryName = [];
var language;
var bankCountry;
var bankName;
var bankUser;
var bankNumber;
var bankBranch;
var swiftCode;
var dataList;
var buy;
var amount;
var finalAmount;
var totalCurrency;
var total;
var inputValue;
String currency;
var _firstPress = true ;
int _value = 1;
var finalValue;
var price;

getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
}

 getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          pointOne = contentData['point1'];
        });
      }
    }
    print(contentData);
  }

  @override
  void initState() {
    super.initState();
   getRequest();
   getLanguage();
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
                  Container(
                  margin: EdgeInsets.only(right:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context, true)),
                      GestureDetector(
                        onTap: (){
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WithdrawRecord(widget.url)),
                            );
                        },
                        child:Container(
                          alignment: Alignment.bottomRight,
                          child: 
                          Text(MyLocalizations.of(context).getData('withdraw_record'),style: TextStyle(color: Colors.white,fontSize: 16),)),
                      )
                    ],
                  ),
                ),
                  Center(
                      child: Text(
                          MyLocalizations.of(context).getData('withdraw'),
                          style: Theme.of(context).textTheme.headline1)),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xfff9f21a), Color(0xfff9f21a)])
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 8,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom:5),
                          child: Text(
                            MyLocalizations.of(context).getData('my_balance'),
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text('USDT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: pointOne == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                    Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    pointOne,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                      ],
                    )
                  ),
                  SizedBox(height:20),
                  // Container(
                  //   decoration: new BoxDecoration(
                  //   color: Color(0xff595c64),
                  //   borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: ExpansionTile(
                  //     title: Container(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text('bankName',style: TextStyle(color: Colors.white,fontSize: 18),),
                  //           SizedBox(height:5),
                  //           Text('bankUser',style: TextStyle(color: Colors.white,fontSize: 16)),
                  //           SizedBox(height:5),
                  //         ],
                  //       ),
                  //     ),
                  //     children: <Widget>[
                  //       Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           SizedBox(height:10),
                  //           Container(
                  //             alignment: Alignment.bottomLeft,
                  //             padding: EdgeInsets.only(left:15),
                  //             child: Row(
                  //               children: [
                  //                 Text('Order Time : ',style: TextStyle(color: Colors.white70)),
                  //                 Text('bankName',style: TextStyle(color: Colors.white70)),
                  //               ],
                  //             )),
                  //           SizedBox(height:5),
                  //             Container(
                  //             alignment: Alignment.bottomLeft,
                  //             padding: EdgeInsets.only(left:15),
                  //             child: Row(
                  //               children: [
                  //                 Text('First Buy In Amount : ',style: TextStyle(color: Colors.white70)),
                  //                 Text('bankName',style: TextStyle(color: Colors.white70)),
                  //               ],
                  //             )),
                  //             SizedBox(height:5),
                  //             Container(
                  //             alignment: Alignment.bottomLeft,
                  //             padding: EdgeInsets.only(left:15),
                  //             child: Row(
                  //               children: [
                  //                 Text('Numbers of cover up : ',style: TextStyle(color: Colors.white70)),
                  //                 Text('bankName',style: TextStyle(color: Colors.white70)),
                  //               ],
                  //             )),
                  //             SizedBox(height:5),
                  //             Container(
                  //             alignment: Alignment.bottomLeft,
                  //             padding: EdgeInsets.only(left:15),
                  //             child: Row(
                  //               children: [
                  //                 Text('Take profit ratio : ',style: TextStyle(color: Colors.white70)),
                  //                 Text('bankName',style: TextStyle(color: Colors.white70)),
                  //               ],
                  //             )),
                  //             SizedBox(height:5),
                  //             Container(
                  //             alignment: Alignment.bottomLeft,
                  //             padding: EdgeInsets.only(left:15),
                  //             child: Row(
                  //               children: [
                  //                 Text('Earnings callback : ',style: TextStyle(color: Colors.white70)),
                  //                 Text('bankName',style: TextStyle(color: Colors.white70)),
                  //               ],
                  //             )),
                  //             SizedBox(height:5),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                            child: Text(MyLocalizations.of(context).getData('address'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputAddress(),
                          SizedBox(height:20),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('amount')+'(USD)',style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputAmount(),
                          SizedBox(height:20),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('sec_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputPassword(),
                          SizedBox(height: 20.0),

                        // Container(
                        //   child: Text(MyLocalizations.of(context).getData('reached_amount'),style: TextStyle(color: Colors.white,fontSize: 16),),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 20,top: 5),
                        //   child: Stack(
                        //     children: [
                        //       TextFormField(
                        //           readOnly: true,
                        //           textAlign: TextAlign.left,
                        //           keyboardType: TextInputType.number,
                        //           decoration: InputDecoration(
                        //               hintText:  rateController.text,
                        //               contentPadding: const EdgeInsets.only(left:60.0,right:16,top:16,bottom:16),
                        //               border: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(8.0),
                        //                 borderSide: BorderSide(color: Colors.grey, width: 1),
                        //               ),
                        //               filled: true,
                        //               fillColor: Colors.white),
                        //           onSaved: (str) {
                        //           }),
                        //       Container(
                        //         padding: EdgeInsets.only(left: 10,top:18,bottom: 20),
                        //         child: Text(currency == null?'':currency,style: TextStyle(fontWeight: FontWeight.bold),),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                          SizedBox(height: 30.0),

                          AbsorbPointer(
                            absorbing: !_firstPress,
                            child: GestureDetector(
                              onTap: ()async{
                                setState(() {
                                 _sendToServer();
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
                          )
                        ],
                      )),
                ),
               
                  SizedBox(height:20),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

   _inputAddress() {
    return new Container(
      child: TextFormField(
        controller: addressController,
        validator: validateValue,
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

  _inputAmount() {
    return new Container(
      child: TextFormField(
        controller: amountController,
        validator: validateValue,
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
        obscureText: visible,
        validator: validatePassword,
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

  String validateValue(String value) {
    if (value.isEmpty) {
      return  MyLocalizations.of(context).getData('value_fill_in');
    } 
    return null;
  }
  
  String validatePassword(String value) {
    if (value.isEmpty) {
      return  MyLocalizations.of(context).getData('value_fill_in');
    } 
    return null;
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // _key.currentState.save();
      var map = new Map<String, dynamic>();
      if (mounted)
        setState(() {
          map['address'] = addressController.text;
          map['amount'] = amountController.text;
          map['sec_password'] = secpwdController.text;
        });
      postData(map);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/wallet/withdraw", bodyData, token, context);
    
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
      _firstPress = true ;
    });
  }
}
