import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/main.dart';
import 'package:robot/views/Explore/investRecord.dart';
import 'package:robot/views/Part/pageView.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUp extends StatefulWidget {
   final url;
   final onChangeLanguage;
   final type;
   final marketId;

  StartUp(this.url,this.onChangeLanguage,this.type,this.marketId);
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController firstOrderController = TextEditingController();
  TextEditingController maxOrderController = TextEditingController();
  TextEditingController stopProfitRateController = TextEditingController();
  TextEditingController stopProfitCallbackController = TextEditingController();
  TextEditingController coverRateController = TextEditingController();
  TextEditingController coverCallBackRateController = TextEditingController();
  TextEditingController recycleStatusController = TextEditingController();
  TextEditingController pointTwoController = TextEditingController();
  TextEditingController pointThreeController = TextEditingController();
  TextEditingController secpwdController = TextEditingController();
  
  bool _validate = false;
  var body;
  int _radioValue = 0;
  bool _hasBeenPressed = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;
  bool _hasBeenPressed4 = false;
  var robotList = [];
  bool checkApiBinding = true;
  var load = true;
  int _value = 1;
  var finalValue;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }


  @override
  void initState() {
    super.initState();

    body = {
      'platform': widget.type,
    };
    getAPIInfo(body);
    getRequest();
  }

  // getAPIInfo(bodyData) async {
  //   print(bodyData);
  //   print('----------');
  //   final prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token');
  //   var contentData = await Request().postRequest(Config().url+"api/trade-account/accountBalance", bodyData, token, context);
    
  //   print(contentData);
  //   setState(() {
     
  //   });
  // }

  getAPIInfo(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/trade-account/accountInfo", bodyData, token, context);
    if(contentData != null){
      if (contentData['code'] != 0) {
          setState(() {
          checkApiBinding = contentData['data'];
          print(contentData['data']);
          });
          
      }
    }
  }

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          print(contentData);
          pointTwoController.text = contentData['point2'];
          pointThreeController.text = contentData['point3'];
        });
      }
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
                              child: Text(MyLocalizations.of(context).getData('robot_setup'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                        ),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.warning),
                            SizedBox(width:5),
                            Flexible(child: Text(MyLocalizations.of(context).getData('start_up_details'),style: TextStyle(fontSize: 12),)),
                          ],
                        ),
                      ),
                    Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                          child: new Text(MyLocalizations.of(context).getData('radical'),style: TextStyle(fontSize: 12),),
                          textColor: Colors.grey,
                          // 2
                          color: _hasBeenPressed ? Colors.yellowAccent : Colors.black,
                          // 3
                          onPressed: () => {
                            setState(() {
                              _hasBeenPressed = true;
                              _hasBeenPressed2 = false;
                              _hasBeenPressed3 = false;
                              _hasBeenPressed4 = false;
                              firstOrderController.text = '100';
                              maxOrderController.text = '6';
                              stopProfitRateController.text = '1';
                              stopProfitCallbackController.text = '0.3';
                              coverRateController.text = '1.8';
                              coverCallBackRateController.text = '0.3';
                            })
                          },
                      ),
                        ),
                      Expanded(
                        child: RaisedButton(
                          child: new Text(MyLocalizations.of(context).getData('conserve'),style: TextStyle(fontSize: 12)),
                          textColor: Colors.grey,
                          // 2
                          color: _hasBeenPressed2 ? Colors.yellowAccent : Colors.black,
                          // 3
                          onPressed: () => {
                            setState(() {
                              _hasBeenPressed = false;
                              _hasBeenPressed2 = true;
                              _hasBeenPressed3 = false;
                              _hasBeenPressed4 = false;
                              firstOrderController.text = '100';
                              maxOrderController.text = '6';
                              stopProfitRateController.text = '1.3';
                              stopProfitCallbackController.text = '0.3';
                              coverRateController.text = '1.5';
                              coverCallBackRateController.text = '0.3';
                            })
                          },
                        ),
                      ),
                        Expanded(
                          child: RaisedButton(
                          child: new Text(MyLocalizations.of(context).getData('stable'),style: TextStyle(fontSize: 12)),
                          textColor: Colors.grey,
                          // 2
                          color: _hasBeenPressed3 ? Colors.yellowAccent : Colors.black,
                          // 3
                          onPressed: () => {
                            setState(() {
                              _hasBeenPressed = false;
                              _hasBeenPressed2 = false;
                              _hasBeenPressed3 = true;
                              _hasBeenPressed4 = false;
                              firstOrderController.text = '100';
                              maxOrderController.text = '6';
                              stopProfitRateController.text = '1.5';
                              stopProfitCallbackController.text = '0.3';
                              coverRateController.text = '2';
                              coverCallBackRateController.text = '0.5';
                            })
                          },
                      ),
                        ),
                        Expanded(
                          child: RaisedButton(
                          child: new Text(MyLocalizations.of(context).getData('customize'),style: TextStyle(fontSize: 12)),
                          textColor: Colors.grey,
                          // 2
                          color: _hasBeenPressed4 ? Colors.yellowAccent : Colors.black,
                          // 3
                          onPressed: () => {
                            setState(() {
                              _hasBeenPressed = false;
                              _hasBeenPressed2 = false;
                              _hasBeenPressed3 = false;
                              _hasBeenPressed4 = true;
                              firstOrderController.text = '';
                              maxOrderController.text = '';
                              stopProfitRateController.text = '';
                              stopProfitCallbackController.text = '';
                              coverRateController.text = '';
                              coverCallBackRateController.text = '';
                            })
                          },
                      ),
                        )
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
                                  child: Text('GAS',style: TextStyle(color: Colors.white),),
                                ),
                                SizedBox(height: 5),
                                _inputPointTwo(),
                                SizedBox(height: 20.0),
                                  
                                Container(
                                  child: Text(MyLocalizations.of(context).getData('gas_pingyi'),style: TextStyle(color: Colors.white),),
                                ),
                                SizedBox(height: 5),
                                _inputPointThree(),
                                SizedBox(height: 20.0),

                                Container(
                                  child: Text(MyLocalizations.of(context).getData('gas_type'),style: TextStyle(color: Colors.white),),
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
                                      value: _value,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('GAS'),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                          child: Text(MyLocalizations.of(context).getData('gas_pingyi')),
                                          value: 2,
                                        ),
                                        DropdownMenuItem(
                                          child: Text(MyLocalizations.of(context).getData('gas_gas_pingyi')),
                                          value: 3,
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _value = value;
                                        });
                                      }),
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  child: Text(MyLocalizations.of(context).getData('first_buy_in_amount'),style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                firstOrder(),
                                SizedBox(height: 20.0),

                                Container(
                                  child: Text(MyLocalizations.of(context).getData('numbers_of_cover_up'),style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                maxOrder(),
                                SizedBox(height: 20.0),

                                Container(
                                  child: Text(MyLocalizations.of(context).getData('take_profit_ratio'),style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                stopProfitRate(),
                                SizedBox(height: 20.0),

                                Container(
                                  child: Text(MyLocalizations.of(context).getData('earnings_callback'),style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                stopProfitCallback(),
                                SizedBox(height: 20.0),

                                Container(
                                  child: Text(MyLocalizations.of(context).getData('margin_call_drop'),style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                coverRate(),
                                SizedBox(height: 20.0),

                                Container(
                                  child: Text(MyLocalizations.of(context).getData('buy_in_callback'),style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                coverCallBackRate(),
                                SizedBox(height: 20.0),

                                Container(
                                  child: Text(MyLocalizations.of(context).getData('sec_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                                ),
                                SizedBox(height: 5.0),
                                _inputPassword(),
                                SizedBox(height: 20.0),
                                
                                Container(
                                  child: Text(MyLocalizations.of(context).getData('strategy_type'),style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                recycleStatus(),
                                SizedBox(height: 20.0),
                              
                                Container(
                                child: GestureDetector(
                                onTap: ()async{
                                  setState(() {
                                    load = !load;
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
                                      child: load?Text(
                                        MyLocalizations.of(context).getData('submit'),
                                        style: TextStyle(color: Colors.black),
                                      ):CircularProgressIndicator(backgroundColor: Colors.black, strokeWidth: 2,)),
                                ),
                              ),),
                                SizedBox(height: 20.0),
                              ],
                            )),
                      ),
                  ],
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
  
  _inputPointTwo() {
    return new Container(
      child: TextFormField(
        controller: pointTwoController,
        validator: validateInput,
        enabled: false,
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

  _inputPointThree() {
    return new Container(
      child: TextFormField(
        controller: pointThreeController,
        validator: validateInput,
        enabled: false,
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

  firstOrder() {
    return new Container(
      child: TextFormField(
        controller: firstOrderController,
        validator: validateFirst,
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

  maxOrder() {
    return new Container(
      child: TextFormField(
        controller: maxOrderController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        suffixIcon: IconButton(
          icon: Text(MyLocalizations.of(context).getData('times')),
        ),
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

  stopProfitRate() {
    return new Container(
      child: TextFormField(
        controller: stopProfitRateController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
          suffixIcon: IconButton(
          icon: Text('%'),
        ),
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

  stopProfitCallback() {
    return new Container(
      child: TextFormField(
        controller: stopProfitCallbackController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
          suffixIcon: IconButton(
          icon: Text('%'),
        ),
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

  coverRate() {
    return new Container(
      child: TextFormField(
        controller: coverRateController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
          suffixIcon: IconButton(
          icon: Text('%'),
        ),
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

  coverCallBackRate() {
    return new Container(
      child: TextFormField(
        controller: coverCallBackRateController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
          suffixIcon: IconButton(
          icon: Text('%'),
        ),
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
  
  recycleStatus() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Radio(
          value: 0,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        new Text(
          MyLocalizations.of(context).getData('single_strategy'),
          style: new TextStyle(fontSize: 16.0,color: Colors.white),
        ),
        new Radio(
          value: 1,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        new Text(
          MyLocalizations.of(context).getData('circular_strategy'),
          style: new TextStyle(
            fontSize: 16.0,color: Colors.white
          ),
        ),
      ],
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

  String validateFirst(String value) {
    if (value.isEmpty) {
      return MyLocalizations.of(context).getData('value_fill_in');
    } else if (double.parse(value) < 10) {
      return MyLocalizations.of(context).getData('minimum_10');
    }
    return null;
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/create", bodyData, token, context);
    
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
                      widget.url, widget.onChangeLanguage)));
            })
          ..show();
    }else{
        setState(() {
          load = true;
        });
      }
    setState(() {
     
    });
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var tmap = new Map<String, dynamic>();
      if (mounted)
        if(checkApiBinding == false){
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: false,
            title: MyLocalizations.of(context).getData('error'),
            desc: MyLocalizations.of(context).getData('no_bind_api'),
            btnOkOnPress: () {},
            btnOkText: MyLocalizations.of(context).getData('close'),
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
          ..show();
        }else{
          setState(() {
            if(_value == 1){
              finalValue = 'point2';
            }
            else if(_value == 2){
              finalValue = 'point3';
            }
            else if(_value == 3){
              finalValue = 'point2&point3';
            }
            tmap['gas_type'] = finalValue;
            tmap['platform'] = widget.type;
            tmap['market_id'] = widget.marketId.toString();
            tmap['first_order_value'] = firstOrderController.text.toString();
            tmap['max_order_count'] = maxOrderController.text.toString();
            tmap['stop_profit_rate'] = stopProfitRateController.text.toString();
            tmap['stop_profit_callback_rate'] = stopProfitCallbackController.text.toString();
            tmap['cover_rate'] = coverRateController.text.toString();
            tmap['cover_callback_rate'] = coverCallBackRateController.text.toString();
            tmap['recycle_status'] = _radioValue.toString();
            tmap['sec_password'] = secpwdController.text;
            print(tmap['platform']);
            print(tmap['market_id']);
          });
          postData(tmap);
        }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
