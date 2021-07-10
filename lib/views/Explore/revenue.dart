import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Explore/revenueDetails.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;

class Revenue extends StatefulWidget {
   final url;
   final type;

  Revenue(this.url,this.type);
  @override
  _RevenueState createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  
  var dataList;
  var todayRevenue;
  var totalRevenue;
 
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
          dataList = contentData['data']['data']['data'];
          todayRevenue = contentData['data']['today_revenue'];
          totalRevenue = contentData['data']['total_revenue'];
          print(todayRevenue);
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
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/img/yellow_card.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  MyLocalizations.of(context).getData('today_revenue'), 
                                  style: TextStyle(
                                    color:Colors.black, 
                                    fontSize: 13, 
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                                SizedBox(height: 20),
                                Text(
                                  todayRevenue==null?'0':double.parse(todayRevenue).toStringAsFixed(8), 
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontSize: 15,  
                                  )
                                ),
                                todayRevenue == null?
                                Text('≈ ' + '0' +' USD',style: TextStyle(color:Colors.black,fontSize: 15)):
                                Text('≈ ' + double.parse(todayRevenue).toStringAsFixed(6) +' USD',style: TextStyle(color:Colors.black,fontSize: 12)),
                              ],
                            ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  MyLocalizations.of(context).getData('cumulative_profit'), 
                                  style: TextStyle(
                                    color:Colors.black, 
                                    fontSize: 13, 
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                                SizedBox(height: 20),
                                Text(
                                  totalRevenue==null?'0':double.parse(totalRevenue).toStringAsFixed(8), 
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontSize: 15,  
                                  )
                                ),
                                totalRevenue==null?
                                Text('≈ ' + '0' +' USD',style: TextStyle(color:Colors.black,fontSize: 15)):
                                Text('≈ ' + double.parse(totalRevenue).toStringAsFixed(6) +' USD',style: TextStyle(color:Colors.black,fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(MyLocalizations.of(context).getData('data_refresh_per_hour'),style: TextStyle(color:Colors.black,fontSize: 12)),
                              Text(MyLocalizations.of(context).getData('every_day_count'),style: TextStyle(color:Colors.black,fontSize: 12)),
                            ],
                          ),
                        )
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
                        onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RevenueDetails(widget.url,dataList[index]['date'])),
                        );
                        },
                        child:  Container(
                          padding: EdgeInsets.all(10),
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
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(dataList[index]['date'].substring(5, 10),style: TextStyle(color: Colors.white,fontSize: 16)),
                                    Text(dataList[index]['date'].substring(0, 4),style: TextStyle(color: Colors.white54)),
                                  ],
                                )
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: dataList[index]['revenue'].substring(0)=='-'?
                                      Text(
                                        double.parse(dataList[index]['revenue']).toStringAsFixed(6)+' USDT',
                                        style: TextStyle(color: Colors.redAccent,fontSize: 16),
                                      ):
                                      Text(
                                        double.parse(dataList[index]['revenue']).toStringAsFixed(6)+' USDT',
                                        style: TextStyle(color: Colors.greenAccent,fontSize: 16),
                                      ),
                                    ),
                                    Container(child: 
                                    dataList[index]['revenue'].substring(0)=='-'?
                                    Text(MyLocalizations.of(context).getData('loss'),style: TextStyle(color:Colors.white54,fontSize: 13)):
                                    Text(MyLocalizations.of(context).getData('earn'),style: TextStyle(color:Colors.white54,fontSize: 13)),
                                    )
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
