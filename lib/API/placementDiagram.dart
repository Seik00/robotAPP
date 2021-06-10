import 'package:flutter/material.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/SystemSetting/Node.dart';


class PlacementDiagram extends StatefulWidget {
  @override
  _PlacementDiagramState createState() => _PlacementDiagramState();
}

class _PlacementDiagramState extends State<PlacementDiagram> {
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 30),
              child: Center(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Node()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Image(
                                  image:
                                      AssetImage("lib/assets/img/exchange.png"),
                                  height: 80,
                                  width: 70,
                                )),
                            Container(
                              child: Text(
                                MyLocalizations.of(context).getData('profile'),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:20),
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Node()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Image(
                                        image: AssetImage(
                                            "lib/assets/img/exchange.png"),
                                        height: 80,
                                        width: 70,
                                      )),
                                  Container(
                                    child: Text(
                                      MyLocalizations.of(context)
                                          .getData('profile'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Node()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Image(
                                        image: AssetImage(
                                            "lib/assets/img/exchange.png"),
                                        height: 80,
                                        width: 70,
                                      )),
                                  Container(
                                    child: Text(
                                      MyLocalizations.of(context)
                                          .getData('profile'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ])),
                        SizedBox(height:20),
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Node()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Image(
                                        image: AssetImage(
                                            "lib/assets/img/exchange.png"),
                                        height: 80,
                                        width: 70,
                                      )),
                                  Container(
                                    child: Text(
                                      MyLocalizations.of(context)
                                          .getData('profile'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Node()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Image(
                                        image: AssetImage(
                                            "lib/assets/img/exchange.png"),
                                        height: 80,
                                        width: 70,
                                      )),
                                  Container(
                                    child: Text(
                                      MyLocalizations.of(context)
                                          .getData('profile'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Node()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Image(
                                        image: AssetImage(
                                            "lib/assets/img/exchange.png"),
                                        height: 80,
                                        width: 70,
                                      )),
                                  Container(
                                    child: Text(
                                      MyLocalizations.of(context)
                                          .getData('profile'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Node()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Image(
                                        image: AssetImage(
                                            "lib/assets/img/exchange.png"),
                                        height: 80,
                                        width: 70,
                                      )),
                                  Container(
                                    child: Text(
                                      MyLocalizations.of(context)
                                          .getData('profile'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ])),
                  ],
                ),
              ),
            )));
  }
}
