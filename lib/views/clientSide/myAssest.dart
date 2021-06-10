import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/deposit.dart';
import 'package:robot/views/Explore/transfer.dart';
import 'package:robot/views/Explore/wallet_record.dart';
import 'package:robot/views/Explore/withdraw.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:robot/views/clientSide/createService.dart';
import 'package:intl/intl.dart';

class MyAssests extends StatefulWidget {

  final url;

  MyAssests(this.url);
  @override
  _MyAssestsState createState() => _MyAssestsState();
}

class _MyAssestsState extends State<MyAssests>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();
  var pointOne;
  bool moreRequest = false;
  bool loading = true;
  var  total_income;
  var total_income_today;
   var totalCurrency;

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          pointOne = contentData['data']['point1'];
        });
      }
    }
    }
  }

  getHomeInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/member/home-page", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
        total_income = contentData['data']['total_income'];
        total_income_today = contentData['data']['total_income_today'];
        totalCurrency = contentData['data']['total_asset_currency'];
        });
      }
    }
    }
  }

  @override
  void initState() {
    super.initState();
    getRequest();
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // color: Theme.of(context).backgroundColor,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/img/background.png'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(
                            child: Container(
                          child: Text(
                            MyLocalizations.of(context).getData('wallet'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: GridView.count(
                            primary: false,
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                          color: Color(0xff361c60),
                                          border: Border.all(width:1,color:Colors.white),
                                          borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                           MyLocalizations.of(context).getData('today_income'),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,color: Colors.white),
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                'USD',
                                                style: TextStyle(fontSize: 14,color: Colors.white),
                                              ),
                                            ),
                                            Row(
                                                  children:[
                                                    Container(
                                                      child: Text(
                                                        '+',
                                                        style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    total_income_today == null
                                                    ? Container(
                                                        child: Row(
                                                        children: <Widget>[
                                                          Text('')
                                                        ],
                                                      ))
                                                    : Container(
                                                        child: Text(
                                                          total_income_today,
                                                          style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      )
                                                  ]
                                                )
                                          ])
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                          color: Color(0xff361c60),
                                          border: Border.all(width:1,color:Colors.white),
                                          borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          MyLocalizations.of(context).getData('earn'),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,color: Colors.white),
                                        ),
                                      ),
                                      Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'USD',
                                                    style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Row(
                                                  children:[
                                                    Container(
                                                      child: Text(
                                                        '+',
                                                        style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    total_income == null
                                                    ? Container(
                                                        child: Row(
                                                        children: <Widget>[
                                                          Text('')
                                                        ],
                                                      ))
                                                    : Container(
                                                        child: Text(
                                                          total_income,
                                                          style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      )
                                                  ]
                                                )
                                              ])
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WalletRecord(widget.url)),
                            );
                          },
                          child: Container(
                              padding: EdgeInsets.only(right: 20),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    MyLocalizations.of(context)
                                        .getData('wallet_record'),
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,
                                        fontSize: 16),
                                  ))),
                        ),
                        SizedBox(height: 10),
                        Center(
                            child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(30),
                          margin: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xff7CAAD5), Color(0xff8263CE)])
                                      ),
                          child: Column(
                            children: [
                            Container(
                              child: Text(
                                MyLocalizations.of(context)
                                    .getData('my_assets'),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              child:Row(
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
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Colors.white),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                    )
                              ],)
                            ),
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
                                      ? Container():
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
                            SizedBox(height: 60),
                            GestureDetector(
                            onTap: ()async{
                                setState(() {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Withdraw(
                                          widget.url,)),
                                ).then((value) {
                                        getRequest();getHomeInfo();
                                      });
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
                                    margin: EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width/2,
                                    height: MediaQuery.of(context).size.height / 15,
                                    alignment: Alignment.center,
                                    child: Text(
                                      MyLocalizations.of(context).getData('withdraw'),
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                            GestureDetector(
                            onTap: ()async{
                                setState(() {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Transfer(
                                        widget.url,)),
                                ).then((value) {
                                  getRequest();getHomeInfo();
                                });
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
                                    margin: EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width/2,
                                    height: MediaQuery.of(context).size.height / 15,
                                    alignment: Alignment.center,
                                    child: Text(
                                      MyLocalizations.of(context).getData('transfer'),
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    )),
                              ),
                            )
                          ]),
                        ))
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
