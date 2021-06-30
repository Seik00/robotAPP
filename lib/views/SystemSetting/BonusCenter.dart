import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/bonusRecord.dart';
import 'package:robot/views/SystemSetting/changePwd.dart';
import 'package:robot/views/SystemSetting/changeSecurityPwd.dart';
import 'package:robot/views/SystemSetting/userBank.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;

class BonusCenter extends StatefulWidget {
  final url;
  final onChangeLanguage;
  String type;

  BonusCenter(this.url, this.onChangeLanguage,this.type);

  @override
  _BonusCenterrState createState() => _BonusCenterrState();
}

class _BonusCenterrState extends State<BonusCenter>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();


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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // color: Theme.of(context).backgroundColor,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context, true)),
                        Center(
                          child: Container(
                            child: Text(
                              MyLocalizations.of(context).getData('bonus'),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BonusRecord(widget.url,widget.type = 'dynamic_bonus')),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
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
                                        "lib/assets/img/share_bonus.png"),
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
                                              .getData('dynamic_bonus'),
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
                        Divider(
                          height: 1,
                          color: Colors.grey[400],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  BonusRecord(widget.url,widget.type = 'sponsor_bonus')),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
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
                                        "lib/assets/img/event_bonus.png"),
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
                                              .getData('sponsor_bonus'),
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BonusRecord(widget.url,widget.type = 'special_bonus')),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
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
                                        "lib/assets/img/share_bonus.png"),
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
                                              .getData('special_bonus'),
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
                        Divider(
                          height: 1,
                          color: Colors.grey[400],
                        ),
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
