import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Explore/apiBindingForm.dart';
import 'package:robot/views/Explore/investRecord.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionRecord extends StatefulWidget {
   final url;

  TransactionRecord(this.url);
  @override
  _TransactionRecordState createState() => _TransactionRecordState();
}

class _TransactionRecordState extends State<TransactionRecord> {
  var type = '';
  var dataList =[];
 
  getAllInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/trade-robot/robotList", context);
    print(contentData);
    if(contentData != null){
      if (contentData['code'] == 0) {
          setState(() {
             dataList = contentData['data'];
            print(dataList);
          });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    getAllInfo();
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
                              child: Text(MyLocalizations.of(context).getData('transaction'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                    color: Color(0xff595c64),
                    borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: ExpansionTile(
                            title: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dataList[index]['market_name'],style: TextStyle(color: Colors.white,fontSize: 18),),
                                  SizedBox(height:5),
                                  Text(double.parse(dataList[index]['revenue']).toStringAsFixed(3),style: TextStyle(color: Colors.white,fontSize: 20)),
                                  SizedBox(height:5),
                                  Text(MyLocalizations.of(context).getData('average_buy_in'),style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height:10),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('order_time'),style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['ctime'],style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                  SizedBox(height:5),
                                   Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('first_buy_in_amount')+ ' : ',style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['first_order_value'].toString()+ ' USDT',style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                    SizedBox(height:5),
                                    Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('numbers_of_cover_up')+ ' : ',style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['max_order_count'].toString(),style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                    SizedBox(height:5),
                                    Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('take_profit_ratio')+ ' : ',style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['stop_profit_rate'].toString()+ '%',style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                    SizedBox(height:5),
                                    Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('earnings_callback')+ ' : ',style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['stop_profit_callback_rate'].toString()+ '%',style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                    SizedBox(height:5),
                                    Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('margin_call_drop')+ ' : ',style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['cover_rate'].toString()+ '%',style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                    SizedBox(height:5),
                                    Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left:15),
                                    child: Row(
                                      children: [
                                        Text(MyLocalizations.of(context).getData('buy_in_callback')+ ' : ',style: TextStyle(color: Colors.white70)),
                                        Text(dataList[index]['cover_callback_rate'].toString()+ '%',style: TextStyle(color: Colors.white70)),
                                      ],
                                    )),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                  }),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
