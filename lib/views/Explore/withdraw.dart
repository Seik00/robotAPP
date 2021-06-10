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
final TextEditingController amountController = new TextEditingController();
final TextEditingController rateController = new TextEditingController();
final TextEditingController bankCountryController = new TextEditingController();
final TextEditingController bankNameController = new TextEditingController();
final TextEditingController bankUserController = new TextEditingController();
final TextEditingController bankNumberController = new TextEditingController();
final TextEditingController bankBranchController = new TextEditingController();
final TextEditingController swiftCodeController = new TextEditingController();
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
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          pointOne = contentData['data']['point1'];
          price = contentData['data']['package']['price'];
        });
      }
    }
    }
    print(contentData);
  }

  getHomeInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/member/home-page", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
         totalCurrency = contentData['data']['total_asset_currency'];
        });
      }
    }
    }
  }

  getbankInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-bank-info", context);
    print(contentData);
    print('--------');
    if(contentData['data']!= null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          bankCountry = contentData['data']['bank_country'] ;
          bankName = contentData['data']['bank_name'];
          bankUser = contentData['data']['bank_user'];
          bankNumber = contentData['data']['bank_number'];
          bankBranch = contentData['data']['branch'];
          swiftCode = contentData['data']['swift_code'];
          buy = contentData['data']['country']['buy'];
          currency = contentData['data']['country']["short_form"];
          dataList = contentData['data'];
         
        });
      }
      }
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserBank(widget.url)),
      ).then((value) {
          if (value == null) {
            Navigator.pop(context, true);
          }
        });
    }
  }

  getCountryList() async {
    var contentData = await Request().getRequest(Config().url + "api/global/country_list", context);
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
  }

  @override
  void initState() {
    super.initState();
   getRequest();
   getbankInfo();
   getLanguage();
  getCountryList();
  getHomeInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
                          Text(MyLocalizations.of(context).getData('withdraw_record'),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
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
                        colors: [Color(0xff7CAAD5), Color(0xff8263CE)])
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 6,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom:5),
                          child: Text(
                            MyLocalizations.of(context).getData('my_balance'),
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text('USD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
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
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                         Container(
                                  child:Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                    Text(
                                     '≈',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    totalCurrency == null
                                      ? Container(
                                          child: Row(
                                          children: <Widget>[
                                            Text('')
                                          ],
                                        )):
                                    Text(
                                      totalCurrency,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],)
                                ),
                      ],
                    )
                  ),
                  SizedBox(height:20),
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
                            child: Text(MyLocalizations.of(context).getData('withdraw_way'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            border: Border.all()),
                            child: DropdownButton(
                              isExpanded: true,
                              value: _value,
                              items: [
                                DropdownMenuItem(
                                  child: Text(MyLocalizations.of(context).getData('withdraw_bonus')),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text(MyLocalizations.of(context).getData('withdraw_principal')),
                                  value: 2,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                  if(_value==2){
                                    amountController.text = price;
                                    var totalPrice = double.parse(price);
                                    total = totalPrice * double.parse(buy);
                                    rateController.text = total.toStringAsFixed(2);
                                    print(rateController.text);
                                    
                                  }else{
                                    amountController.text = '';
                                    rateController.text = '';
                                  }
                                });
                              }),
                          ), 
                          SizedBox(height:5),
                          _value==2?
                          Container(
                            child: Text(MyLocalizations.of(context).getData('confirmation'),style: TextStyle(color: Colors.red,fontSize: 16),),
                          ):
                          Container(
                          ), 
                          SizedBox(height:20),
                          Container(
                            child: Text(MyLocalizations.of(context).getData('amount')+'(USD)',style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputAmount(),
                          SizedBox(height:20),
                        Container(
                          child: Text(MyLocalizations.of(context).getData('reached_amount'),style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20,top: 5),
                          child: Stack(
                            children: [
                              TextFormField(
                                  readOnly: true,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText:  rateController.text,
                                      contentPadding: const EdgeInsets.only(left:60.0,right:16,top:16,bottom:16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.grey, width: 1),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white),
                                  onSaved: (str) {
                                  }),
                              Container(
                                padding: EdgeInsets.only(left: 10,top:18,bottom: 20),
                                child: Text(currency == null?'':currency,style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),

                          Container(
                            child: Text(MyLocalizations.of(context).getData('sec_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          SizedBox(height: 5.0),
                          _inputPassword(),
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
                                        colors: [Color(0xff3DC2EA), Color(0xff7C1999)])
                                    ),
                                    margin: EdgeInsets.all(20),
                                    width: MediaQuery.of(context).size.width/2,
                                    height: MediaQuery.of(context).size.height / 15,
                                    alignment: Alignment.center,
                                    child: Text(
                                      MyLocalizations.of(context).getData('submit'),
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    MyLocalizations.of(context).getData('withdraw_description'),style: TextStyle(color: Colors.red),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff7CAAD5), Color(0xff8263CE)])
                    ),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom:5),
                          child: Text(
                            MyLocalizations.of(context).getData('bank_details'),
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(MyLocalizations.of(context).getData('bank_country'),style: TextStyle(fontSize: 16,color: Colors.white),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: bankCountry == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                    Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    language ==  'zh'?
                                    dataList['country']['name']:
                                    dataList['country']['name_en'],
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(MyLocalizations.of(context).getData('bank_name'),style: TextStyle(fontSize: 16,color: Colors.white),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: bankName == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                    Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    bankName,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(MyLocalizations.of(context).getData('bank_user'),style: TextStyle(fontSize: 16,color: Colors.white),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: bankUser == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                    Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    bankUser,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(MyLocalizations.of(context).getData('bank_number'),style: TextStyle(fontSize: 16,color: Colors.white),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: bankNumber == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                    Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    bankNumber,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(MyLocalizations.of(context).getData('bank_branch'),style: TextStyle(fontSize: 16,color: Colors.white),),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                           Container(
                            child: bankBranch == null
                              ? Container(
                                  child: Row(
                                  children: <Widget>[
                                    Text('')
                                  ],
                                ))
                              : Container(
                                  child: Text(
                                    bankBranch,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],),
                      ],
                    )
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

  _inputAmount() {
    return new Container(
      child: TextFormField(
        onChanged: (String values) async {
          if (values == "") {
            total = 0;
            print(total);
          } else {
            inputValue = double.parse(values);
            total = inputValue*double.parse(buy);
            setState(() {
              rateController.text = total.toStringAsFixed(2); 
              print(total);
            });
            
            
          }
        },
        readOnly: _value == 2?true:false,
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
          if(_value == 1){
            finalValue ='withdraw';
          }
          else if(_value == 2){
            finalValue ='cash_out';
          }
          map['withdraw_type'] = finalValue;
          map['amount'] = amountController.text;
          map['bank_country'] = bankCountry;
          map['bank_name'] = bankName;
          map['bank_user'] = bankUser;
          map['bank_number'] = bankNumber;
          map['branch'] = bankBranch;
          map['swift_code'] = swiftCode==null?'':swiftCode;
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
