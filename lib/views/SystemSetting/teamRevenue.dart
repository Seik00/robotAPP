
import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:shared_preferences/shared_preferences.dart';import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TeamRevenue extends StatefulWidget {
  final url;
  final robotID;

  TeamRevenue(this.url, this.robotID);
  @override
  _TeamRevenueState createState() => _TeamRevenueState();
}

class _TeamRevenueState extends State<TeamRevenue> {
  final scrollController = ScrollController();
  var type = '';
  var dataList;
  bool loading = true;
  bool beyondPages = false;
  bool startLoading = false;
  var pageParams = {'current_page': 1, 'per_page': 10};
  String date = "";
  DateTime selectedDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  var formattedSelectedDate;
  var formattedSelectedEndDate;

  @override
  void initState() {
    super.initState();
    getRequest();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formattedSelectedDate = formatter.format(selectedDate);
    formattedSelectedEndDate = formatter.format(selectedEndDate);
    // scrollController.addListener(() {
    //   print('qqqqq');
    //   if (scrollController.position.maxScrollExtent ==
    //       scrollController.offset) {
    //     if (beyondPages) {
    //       setState(() {
    //         startLoading = true;
    //         pageParams['current_page'] += 1;
    //       });
    //       getRequest();
    //        print(pageParams['current_page']);
    //     } else {
    //       setState(() {
    //         startLoading = false;
    //       });
    //     }
    //   }
    // });
  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff595c64),
              accentColor: const Color(0xff595c64),
              colorScheme: ColorScheme.light(primary: const Color(0xff595c64)),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
              ),
          ),
          child: child,
        );
      },
      firstDate: DateTime(2021),
      lastDate: DateTime.now(), 
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        formattedSelectedDate = formatter.format(selectedDate);
        print(formattedSelectedDate);
        getRequest();
      });
  }

   _selectEndDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff595c64),
              accentColor: const Color(0xff595c64),
              colorScheme: ColorScheme.light(primary: const Color(0xff595c64)),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
              ),
          ),
          child: child,
        );
      },
      firstDate: selectedDate,
      lastDate: DateTime.now(), 
    );
    if (selected != null && selected != selectedEndDate)
      setState(() {
        selectedEndDate = selected;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        formattedSelectedEndDate = formatter.format(selectedEndDate);
        print(formattedSelectedEndDate);
        getRequest();
      });
  }

  @override
  void dispose() {
    //scrollController.dispose();
    super.dispose();
  }

  getRequest() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'start_date': formattedSelectedDate.toString(),
        'end_date': formattedSelectedEndDate.toString(),
      };
      print(body);
      var uri = Uri.https(Config().url2, 'api/team/teamRevenue', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
    
      setState(() {
        dataList = contentData['data'];
        print(dataList);
      });
  }
  // getRequest() async {
  //   var contentData = await Request().getRequest(Config().url +"api/team/teamRevenue?page=" +pageParams['current_page'].toString(),context);
  //   if (contentData['code'] == 0) {
  //     if (mounted) {
  //       setState(() {
  //         loading = false;
  //         if (dataList == null) {
  //           dataList = contentData['data']['data'];
  //         } else {
  //           for (var i = 0; i < contentData['data']['data'].length; i++) {
  //             dataList.add(contentData['data']['data'][i]);
  //           }
  //         }

  //         print(contentData['data']['current_page']);
  //       });
  //       if (contentData['data']['last_page'] > 1) {
  //         if (pageParams['current_page'] <= contentData['data']['last_page']) {
  //           beyondPages = true;
  //           print('123123');
  //         } else {
  //           beyondPages = false;
  //           print('ccccccccccccc');
  //         }
  //       }
  //     }
  //   }
  // }

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
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Row(
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
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              MyLocalizations.of(context)
                                  .getData('team_revenue'),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ))),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.all(10),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                  Text("${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",style: TextStyle(color: Colors.black),),
                   ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    primary: Color(0xff595c64),
                    textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(MyLocalizations.of(context).getData('start_date')),
                  ),
                ],),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.all(10),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                  Text("${selectedEndDate.year}/${selectedEndDate.month}/${selectedEndDate.day}",style: TextStyle(color: Colors.black),),
                   ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    primary: Color(0xff595c64),
                    textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
                    onPressed: () {
                      _selectEndDate(context);
                    },
                    child: Text(MyLocalizations.of(context).getData('end_date')),
                  ),
                ],),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(MyLocalizations.of(context).getData('search_date'),style: TextStyle(color: Colors.white),),
                    Text("${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",style: TextStyle(color: Colors.white),),
                    Text(' - ',style: TextStyle(color: Colors.white)),
                     Text("${selectedEndDate.year}/${selectedEndDate.month}/${selectedEndDate.day}",style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              dataList == null
                  ? Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Color(0xff595c64)),))
                  : Container(
                     padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      color: Color(0xff595c64),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              MyLocalizations.of(context).getData('username'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                            Text(
                                MyLocalizations.of(context).getData('revenue'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                            
                          ],
                        ),
                        Divider(
                          height: 10,
                          color: Colors.grey[400],
                        ),
                        ListView.builder(
                            controller: scrollController,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: dataList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            child: Text(
                                            dataList[index]['name'].toString(),overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                            dataList[index]['revenue'].toString(),overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                            }),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
