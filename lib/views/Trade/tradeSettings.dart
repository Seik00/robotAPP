import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Trade/tradeDetails.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;

class TradeSettings extends StatefulWidget {
   final url;
   final onChangeLanguage;
   final type;
   final marketId;

  TradeSettings(this.url,this.onChangeLanguage,this.type,this.marketId);
  @override
  _TradeSettingsState createState() => _TradeSettingsState();
}

class _TradeSettingsState extends State<TradeSettings> {
  var type = '';
  var body;
  var robotList = [];
  @override
  void initState() {
    super.initState();
    getRobotList();
    
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
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Container(
                                child: Text('Trade Settings',style: TextStyle(color: Colors.white,fontSize: 20),),
                              )
                            ],
                          ),
                          robotList == null || robotList.isEmpty?Container():
                          GestureDetector(
                            onTap: (){
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TradeDetails(widget.url,widget.onChangeLanguage,robotList[0]['id'],robotList[0]['first_order_value'],robotList[0]['max_order_count'],robotList[0]['stop_profit_rate'],robotList[0]['stop_profit_callback_rate'],robotList[0]['cover_rate'],robotList[0]['cover_callback_rate'],robotList[0]['recycle_status'],robotList[0]['status'],robotList[0]['is_clean'])),
                              ).then((value) => getRobotList());
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Edit Robot',style: TextStyle(color: Colors.white,fontSize: 18),)),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Color(0xff595c64),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top:20,bottom:10,left: 10,right: 10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Container(
                                child: Text(
                                  'First order limit',
                                  style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                                child: Container(
                                  child: Text(
                                    '10 USDT',
                                    style: TextStyle(color: Colors.white,fontSize: 18,),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
                  Center(
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Color(0xff595c64),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(top:20,bottom:10,left: 10,right: 10),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Container(
                                  child: Text(
                                    'Open position double',
                                    style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                    child: Text(
                                      '10 USDT',
                                      style: TextStyle(color: Colors.white,fontSize: 18,),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Divider(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                           SizedBox(height: 20,),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Container(
                                  child: Text(
                                    'Number of calls',
                                    style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                    child: Text(
                                      '7',
                                      style: TextStyle(color: Colors.white,fontSize: 18,),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Divider(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                           SizedBox(height: 20,),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Container(
                                  child: Text(
                                    'Take profit ratio',
                                    style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                    child: Text(
                                      '1.3 %',
                                      style: TextStyle(color: Colors.white,fontSize: 18,),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Divider(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                           SizedBox(height: 20,),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Container(
                                  child: Text(
                                    'Take porift callback',
                                    style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                    child: Text(
                                      '0.3%',
                                      style: TextStyle(color: Colors.white,fontSize: 18,),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Divider(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                           SizedBox(height: 20,),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Container(
                                  child: Text(
                                    'Callback margin call',
                                    style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                    child: Text(
                                      '0.5%',
                                      style: TextStyle(color: Colors.white,fontSize: 18,),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          
                        ],
                      ),
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
}
