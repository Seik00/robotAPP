
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/views/Explore/depositRecord.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Deposit extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Deposit(this.url, this.onChangeLanguage);

  @override
  _DepositState createState() => _DepositState();
}

class User {
  const User(this.name);    
  final String name;
}

class _DepositState extends State<Deposit> {

  var address;
  var language;

  final amountController = TextEditingController();
  final secpwdController = TextEditingController();
  final countryController = TextEditingController();
  final rateController = TextEditingController();

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    print(language);
  }


  @override
  void initState() {
    super.initState();
    getLanguage();
    postData('');
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var contentData = await Request().postRequest(Config().url+"api/wallet/depositAddress", bodyData, token, context);
    
    if (contentData!=null) {
      if (contentData['code'] == 0) {
         setState(() {
            address = contentData['data'];
            print(address);
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
      body: NotificationListener<ScrollNotification>(
        // ignore: missing_return
      
        child: new GestureDetector(
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
                                  MaterialPageRoute(builder: (context) => DepositRecord(widget.url)),
                                );
                            },
                            child:Container(
                              alignment: Alignment.bottomRight,
                              child: 
                              Text(MyLocalizations.of(context).getData('deposit_record'),style: TextStyle(color: Colors.white,fontSize: 16,),)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        child: Text(
                          MyLocalizations.of(context).getData('deposit'),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height:20),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(4),
                         decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color:Colors.white54)),
                        child: Text('TRC20',style: TextStyle(color: Colors.white,fontSize: 16),)),
                    ),
                    SizedBox(height:40),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                            //image: DecorationImage(image: AssetImage("lib/assets/img/qr-frame.png"))
                        ), 
                        padding: EdgeInsets.all(6),
                        child: Container(
                          child: QrImage(
                            data: address ==null?'':address,
                            version: QrVersions.auto,
                            size: 180.0,
                          ),
                        ),
                      ),
                    ), 
                    SizedBox(height:40),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 40,right:40,top:20,bottom: 20),
                      decoration: BoxDecoration(
                      color: Color(0xfff9f21a),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(MyLocalizations.of(context).getData('deposit_address'),style: TextStyle(fontSize: 16),),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            
                            children: [
                              Expanded(child: Text(address==null?'':address,style: TextStyle(fontWeight: FontWeight.bold),)),
                              SizedBox(width:10),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(new ClipboardData(text: address));
                                  Fluttertoast.showToast(
                                    msg: MyLocalizations.of(context).getData('copied'),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Color(0xFFDCDCDC),
                                    textColor: Colors.black,
                                  );
                                },
                                child: Icon(Icons.copy,size: 25,color: Colors.black,))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height:40),
                    Container(
                      padding: EdgeInsets.only(left:10,right:10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(MyLocalizations.of(context).getData('deposit_details1',),style: TextStyle(color: Colors.white70),),
                          Text(MyLocalizations.of(context).getData('deposit_details2'),style: TextStyle(color: Colors.white70),),
                          Text(MyLocalizations.of(context).getData('deposit_details3'),style: TextStyle(color: Colors.white70),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
