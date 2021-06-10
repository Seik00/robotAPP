import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/SystemSetting/changePwd.dart';
import 'package:robot/views/SystemSetting/changeSecurityPwd.dart';
import 'package:robot/views/SystemSetting/countryChanges.dart';
import 'package:robot/views/SystemSetting/userBank.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;

class SecurityCenter extends StatefulWidget {
  final url;
  final onChangeLanguage;

  SecurityCenter(this.url, this.onChangeLanguage);

  @override
  _SecurityCenterState createState() => _SecurityCenterState();
}

class _SecurityCenterState extends State<SecurityCenter>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
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
                        IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context, true)),
                        Center(
                          child: Container(
                            child: Text(
                              MyLocalizations.of(context).getData('security_center'),
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
                              MaterialPageRoute(builder: (context) => ChangePwd(widget.url)),
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
                                        "lib/assets/img/me_node.png"),
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
                                              .getData('change_login_pwd'),
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
                              MaterialPageRoute(
                                  builder: (context) => ChangeSecurityPwd(widget.url)),
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
                                        "lib/assets/img/me_team.png"),
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
                                              .getData('change_security_pwd'),
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
                              MaterialPageRoute(builder: (context) => UserBank(widget.url)),
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
                                        "lib/assets/img/me_customer_service.png"),
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
                                              .getData('change_bank_detail'),
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
                          height: 10,
                          color: Colors.grey[400],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CountryChanges(widget.url)),
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
                                        "lib/assets/img/me_customer_service.png"),
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
                                              .getData('change_country'),
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
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
