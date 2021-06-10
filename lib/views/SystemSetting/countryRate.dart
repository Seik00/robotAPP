import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:http/http.dart' as http;
import 'package:robot/views/SystemSetting/Node.dart';


class CountryRate extends StatefulWidget {
  @override
  _CountryRateState createState() => _CountryRateState();
}

class _CountryRateState extends State<CountryRate> {

  var packageList=[];
  var language;
  
  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
   
  }

  getPackageList() async {
    var contentData = await Request().getRequest(Config().url + "api/package/get-package", context);
    print(contentData);
    if (contentData != null) {
      if (contentData['code'] == 0) {
        setState(() {
           packageList = contentData['data'];
         
          
        });
       
        
      
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPackageList();
    getLanguage();
  }


  TextEditingController usernameController = TextEditingController();
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
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/img/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:SingleChildScrollView(
                child: Column(
                  children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                      onPressed: () => Navigator.pop(context)),
                  ),
                  Center(
                      child: Text(
                          MyLocalizations.of(context).getData('package_earn'),
                          style: Theme.of(context).textTheme.headline1)),
                  SizedBox(height:10),
                  Container(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(left: 10, right: 10,),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: packageList.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                          return Container(
                             decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white.withOpacity(0.2)
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom:10),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                    Container(
                                        margin: EdgeInsets.only(right:10),
                                        child: Image(
                                          image: NetworkImage(
                                            packageList ==null?
                                            'https://philip.greatwallsolution.com/sae.png':
                                            packageList[index]['public_image_path']),
                                          height: 60,
                                          width: 60,
                                        )
                                      ),
                                    SizedBox(width:20),
                                    Container(
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          Text(MyLocalizations.of(context).getData('package_name'),style: TextStyle(color:Colors.white,fontSize:14,)),
                                          Text(MyLocalizations.of(context).getData('earn_share'),style: TextStyle(color:Colors.white,fontSize:14,)),
                                          Text(MyLocalizations.of(context).getData('share_times'),style: TextStyle(color:Colors.white,fontSize:14,)),
                                        ]
                                      )
                                    ),
                                    SizedBox(width:20),
                                    Expanded(
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children:[
                                          Text(language == 'zh'?packageList[index]['package_name']:packageList[index]['package_name_en'],style: TextStyle(color:Colors.white,fontSize:14,)),
                                          Text(packageList[index]['static_bonus'].toString(),style: TextStyle(color:Colors.white,fontSize:14,)),
                                          Text(packageList[index]['share_times'].toString(),style: TextStyle(color:Colors.purpleAccent,fontSize:16,fontWeight:FontWeight.bold)),
                                        ]
                                      )
                                    ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                            ),
                          );
                          }),
                          ],
                        ),
                      ),
                    )),
                  ),  
                  
                   ],
                 ),
              ),
            ),
            
          ],
        ));
  }
}
