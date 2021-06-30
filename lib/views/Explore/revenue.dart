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

class Revenue extends StatefulWidget {
   final url;
   final type;

  Revenue(this.url,this.type);
  @override
  _RevenueState createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  
  final GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController apiKeyController = TextEditingController();
  TextEditingController secretKeyController = TextEditingController();
  TextEditingController passpharseController = TextEditingController();
  
  bool _validate = false;
  var body;
  var isShow;
  var dataList;
 
  @override
  void initState() {
    super.initState();
    revenue();
  }

  revenue() async {
    var contentData = await Request().getRequest(Config().url + "api/trade-revenue/revenueTotal", context);
    if(contentData != null){
      if (mounted) {
        setState(() {
          print(contentData);
          dataList = contentData['data']['data']['data'];
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
                              child: Text(MyLocalizations.of(context).getData('revenue'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.all(10),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/img/assetsbg.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '123', 
                        style: TextStyle(
                          color:Colors.white, 
                          fontSize: 20, 
                          fontWeight: FontWeight.w500
                        )
                      ),
                      
                      Text(
                        ' USDT', 
                        style: TextStyle(
                          color:Colors.white, 
                        )
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            MyLocalizations.of(context).getData('times'), 
                            style: TextStyle(
                              color:Colors.white, 
                            )
                          ),
                          Image.asset('lib/assets/img/assetsbg.png', height: 20, width: 30,),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20,bottom:20),
                    child: dataList == null || dataList.isEmpty ? Container():
                    ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      child: 
                      GestureDetector(
                        // onTap: (){
                        //   Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => TradeDetails(widget.url,widget.onChangeLanguage,dataList[index]['id'],dataList[index]['first_order_value'],dataList[index]['max_order_count'],dataList[index]['stop_profit_rate'],dataList[index]['stop_profit_callback_rate'],dataList[index]['cover_rate'],dataList[index]['cover_callback_rate'],dataList[index]['recycle_status'],dataList[index]['status'])),
                        // ).then((value) => getdataList());;
                        // },
                        onTap: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Trade(widget.url,widget.onChangeLanguage,dataList[index]['platform'],dataList[index]['market_id'],dataList[index]['market_name'],dataList[index]['id'])),
                        // ).then((value) => startLoop());
                        },
                        child:  Container(
                          decoration: new BoxDecoration(
                            color: Color(0xff595c64),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.only(left:10,right:10,bottom: 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                margin: EdgeInsets.only(right: 20),
                                padding: EdgeInsets.all(10),
                                child: Image(
                                  image: AssetImage(
                                      "lib/assets/img/register.png"),
                                  height: 30,
                                  width: 40,
                                )
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        MyLocalizations.of(context)
                                            .getData('invite_friend'),
                                        style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                        child: (Icon(
                                            Icons.chevron_right_outlined,color: Colors.white,))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                      );
                      }),
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
