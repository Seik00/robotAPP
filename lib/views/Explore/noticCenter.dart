import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Explore/apiBindingForm.dart';
import 'package:robot/views/Explore/investRecord.dart';
import 'package:robot/views/Explore/newsList.dart';
import 'package:robot/views/Explore/noticList.dart';
import 'package:robot/views/Explore/xinwenList.dart';
import 'package:robot/views/otpPage.dart/apiBindingOtp.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticCenter extends StatefulWidget {
   final url;

  NoticCenter(this.url);
  @override
  _NoticCenterState createState() => _NoticCenterState();
}

class _NoticCenterState extends State<NoticCenter> {
  var type = '';
 
 
  

  @override
  void initState() {
    super.initState();
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
                              child: Text(MyLocalizations.of(context).getData('msg_center'),style: TextStyle(color: Colors.white,fontSize: 20),))),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                 Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewsList(widget.url)),
                        );
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                          color: Color(0xff595c64),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(top:20,bottom:10,left: 10,right: 10),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.announcement,color: Color(0xfffFDE323),)
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      MyLocalizations.of(context).getData('news_list'),
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
                  ),
                   Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => XinwenList()),
                        );
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                          color: Color(0xff595c64),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.new_releases,color: Color(0xfffFDE323),)
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      MyLocalizations.of(context).getData('xinwen'),
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
