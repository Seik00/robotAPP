import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/main.dart';
import 'package:robot/views/Explore/investRecord.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUp extends StatefulWidget {
   final url;
   final type;
   final marketId;

  StartUp(this.url,this.type,this.marketId);
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
  
  bool _validate = false;
  var body;
 
  int _radioValue = 0;
  bool _hasBeenPressed = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;
  bool _hasBeenPressed4 = false;
  var robotList = [];

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
    getRobotList();
  }

  getAPIInfo(bodyData) async {
    print(bodyData);
    print('----------');
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/trade-account/accountBalance", bodyData, token, context);
    
    print(contentData);
    setState(() {
     
    });
  }

  getRobotList() async {
    var contentData = await Request().getRequest(Config().url + "api/trade-robot/robotList", context);
    print(contentData);
    if(contentData != null){
      if (contentData['code'] == 0) {
          setState(() {
            robotList = contentData['data'];
            print(robotList);
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
                    height: 100,
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
                              child: Text('Robot Setup',style: TextStyle(color: Colors.white,fontSize: 28),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                          child: new Text('Radical',style: TextStyle(fontSize: 12),),
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
                          child: new Text('Conserve',style: TextStyle(fontSize: 12)),
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
                          child: new Text('Stable',style: TextStyle(fontSize: 12)),
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
                          child: new Text('Customize',style: TextStyle(fontSize: 12)),
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
                               
                                SizedBox(height: 30.0),
                                
                                Container(
                                  child: Text('First Order Amount (USDT)',style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                firstOrder(),
                                SizedBox(height: 30.0),

                                Container(
                                  child: Text('Number of call margin',style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                maxOrder(),
                                SizedBox(height: 30.0),

                                Container(
                                  child: Text('Take Profit Rate',style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                stopProfitRate(),
                                SizedBox(height: 30.0),

                                Container(
                                  child: Text('Earnings callback',style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                stopProfitCallback(),
                                SizedBox(height: 30.0),

                                Container(
                                  child: Text('Margin call drop',style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                coverRate(),
                                SizedBox(height: 30.0),

                                Container(
                                  child: Text('Buy in callback',style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                coverCallBackRate(),
                                SizedBox(height: 30.0),

                                Container(
                                  child: Text('Strategy Type',style: TextStyle(color:Colors.white),),
                                ),
                                SizedBox(height: 5),
                                recycleStatus(),
                                SizedBox(height: 30.0),


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
                                SizedBox(height: 30.0),
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
 
  firstOrder() {
    return new Container(
      child: TextFormField(
        controller: firstOrderController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
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

  maxOrder() {
    return new Container(
      child: TextFormField(
        controller: maxOrderController,
        validator: validateInput,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
        suffixIcon: IconButton(
          icon: Text('Time'),
        ),
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
          'Circular Strategy',
          style: new TextStyle(fontSize: 16.0,color: Colors.white),
        ),
        new Radio(
          value: 1,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        new Text(
          'Single Strategy',
          style: new TextStyle(
            fontSize: 16.0,color: Colors.white
          ),
        ),
      ],
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
          tmap['platform'] = widget.type;
          tmap['market_id'] = widget.marketId.toString();
          tmap['first_order_value'] = firstOrderController.text.toString();
          tmap['max_order_count'] = maxOrderController.text.toString();
          tmap['stop_profit_rate'] = stopProfitRateController.text.toString();
          tmap['stop_profit_callback_rate'] = stopProfitCallbackController.text.toString();
          tmap['cover_rate'] = coverRateController.text.toString();
          tmap['cover_callback_rate'] = coverCallBackRateController.text.toString();
          tmap['recycle_status'] = _radioValue.toString();
          print(tmap['platform']);
          print(tmap['market_id']);
        });
         postData(tmap);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
