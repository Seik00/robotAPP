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

class TradeDetails extends StatefulWidget {
   final url;
   final onChangeLanguage;
   final robotId;
   final firstOrderValue;
   final maxOrderCount;
   final stopProfitRate;
   final stopProfitCallbackRate;
   final coverRate;
   final coverCallbackRate;
   final recycleStatus;
   final status;
   final is_clean;
   final showMsg;
   final valuesStr;

  TradeDetails(this.url,this.onChangeLanguage,this.robotId,this.firstOrderValue,this.maxOrderCount,this.stopProfitRate,this.stopProfitCallbackRate,this.coverRate,this.coverCallbackRate,this.recycleStatus,this.status,this.is_clean,this.showMsg,this.valuesStr);
  @override
  _TradeDetailsState createState() => _TradeDetailsState();
}

class _TradeDetailsState extends State<TradeDetails> {
  
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController firstOrderValueController = TextEditingController();
  TextEditingController maxOrderCountController = TextEditingController();
  TextEditingController stopProfitRateController = TextEditingController();
  TextEditingController stopProfitCallbackRateController = TextEditingController();
  TextEditingController coverRateController = TextEditingController();
  TextEditingController coverCallbackRateController = TextEditingController();
  TextEditingController recycleStatusController = TextEditingController();
  
  bool _validate = false;
  var body;
  int _radioValue = 0;

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
    getRobotInfo();
    print(widget.is_clean);
  }

  getRobotInfo(){
    firstOrderValueController.text = widget.firstOrderValue.toString();
    maxOrderCountController.text = widget.maxOrderCount.toString();
    stopProfitRateController.text = widget.stopProfitRate.toString();
    stopProfitCallbackRateController.text = widget.stopProfitCallbackRate.toString();
    coverRateController.text = widget.coverRate.toString();
    coverCallbackRateController.text = widget.coverCallbackRate.toString();
    _radioValue = widget.recycleStatus;
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
                              child: Text(MyLocalizations.of(context).getData('trade_details'),style: TextStyle(color: Colors.white,fontSize: 28),))),
                         
                        
                          
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
                            
                            SizedBox(height: 30.0),

                            Container(
                              child: Text(MyLocalizations.of(context).getData('first_buy_in_amount'),style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(height: 5),
                            _inputfirstOrderValue(),
                            SizedBox(height: 30.0),

                            Container(
                              child: Text(MyLocalizations.of(context).getData('numbers_of_cover_up'),style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(height: 5),
                            _inputmaxOrderCount(),
                            SizedBox(height: 30.0),
                            
                            Container(
                              child: Text(MyLocalizations.of(context).getData('take_profit_ratio'),style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(height: 5),
                            _inputstopProfitRate(),
                            SizedBox(height: 30.0),

                            Container(
                              child: Text(MyLocalizations.of(context).getData('earnings_callback'),style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(height: 5),
                            _inputstopProfitCallback(),
                            SizedBox(height: 30.0),

                            Container(
                              child: Text(MyLocalizations.of(context).getData('margin_call_drop'),style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(height: 5),
                            _inputcoverRate(),
                            SizedBox(height: 30.0),

                            Container(
                              child: Text(MyLocalizations.of(context).getData('buy_in_callback'),style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(height: 5),
                            _inputcoverCallbackRate(),
                            SizedBox(height: 30.0),

                            Container(
                              child: Text(MyLocalizations.of(context).getData('strategy_type'),style: TextStyle(color: Colors.white)),
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
            ),
          ),
          ],
        ),
      ),
    );
  }
 
  _inputfirstOrderValue() {
    return new Container(
      child: TextFormField(
        controller: firstOrderValueController,
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

  _inputmaxOrderCount() {
    return new Container(
      child: TextFormField(
        controller: maxOrderCountController,
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

  _inputstopProfitRate() {
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

   _inputstopProfitCallback() {
    return new Container(
      child: TextFormField(
        controller: stopProfitCallbackRateController,
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

  _inputcoverRate() {
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

  _inputcoverCallbackRate() {
    return new Container(
      child: TextFormField(
        controller: coverCallbackRateController,
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
    var contentData = await Request().postRequest(Config().url+"api/trade-robot/edit", bodyData, token, context);
    
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
        if(widget.is_clean ==1){
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: false,
            title: MyLocalizations.of(context).getData('error'),
            desc: MyLocalizations.of(context).getData('robot_clean'),
            btnOkOnPress: () {},
            btnOkText: MyLocalizations.of(context).getData('close'),
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
          ..show();
          }else if(widget.is_clean==0 && widget.showMsg == '卖出成功' && widget.valuesStr == '' )
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: false,
            title: MyLocalizations.of(context).getData('error'),
            desc: MyLocalizations.of(context).getData('sold'),
            btnOkOnPress: () {},
            btnOkText: MyLocalizations.of(context).getData('close'),
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
          ..show();
          else{
          setState(() {
            tmap['robot_id'] = widget.robotId.toString();
            tmap['first_order_value'] = firstOrderValueController.text.toString();
            tmap['max_order_count'] = maxOrderCountController.text.toString();
            tmap['stop_profit_rate'] = stopProfitRateController.text.toString();
            tmap['stop_profit_callback_rate'] = stopProfitCallbackRateController.text.toString();
            tmap['cover_rate'] = coverRateController.text.toString();
            tmap['cover_callback_rate'] = coverCallbackRateController.text.toString();
            tmap['recycle_status'] = _radioValue.toString();
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
