import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:http/http.dart' as http;
import 'package:robot/views/SystemSetting/Node.dart';


class Node extends StatefulWidget {
  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {

  var dataList;
  var userId;
  var otherUserId;
  
  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          print(contentData);
          
          userId = contentData['data']['id'].toString();
        });
        initializeData();
      }
    }
    }
  }

  initializeData() async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'parent': userId,
      };
      var uri = Uri.https(Config().url2, 'api/team/organize', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
      print(contentData);
        setState(() {
          dataList = contentData['data'];
        });
     
  }

  checkDetails(otherUserId){
    userId = otherUserId.toString();
    initializeData();
  }

  @override
  void initState() {
    super.initState();
    getRequest();
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
              child:Column(
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
                        MyLocalizations.of(context).getData('my_node'),
                        style: Theme.of(context).textTheme.headline1)),
                Spacer(),
                Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withOpacity(0.2)
                ),
                child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 30),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        dataList == null?Container():
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Node()),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Image(
                                        image:
                                            AssetImage("lib/assets/img/active.png"),
                                        height: 80,
                                        width: 70,
                                      )),
                                  Container(
                                    child: Text(
                                      dataList[0]['username'],
                                      style: TextStyle(fontSize: 14,color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:20),
                        dataList == null?Container():
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                              dataList[1]['parrent'] == 0?
                              GestureDetector(
                                onTap: () {
                                  print('go register');
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Image(
                                          image: AssetImage(
                                              "lib/assets/img/unactive.png"),
                                          height: 80,
                                          width: 70,
                                      )),
                                      Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('register'),
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):
                              GestureDetector(
                                onTap: () {
                                   print('go details');
                                   checkDetails(dataList[1]['parrent']);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/active.png"),
                                            height: 80,
                                            width: 70,
                                          )), 
                                      Container(
                                        child: Text(
                                          dataList[1]['username'],
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              dataList[2]['parrent'] == 0?
                              GestureDetector(
                                onTap: () {
                                  print('go register');
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/unactive.png"),
                                            height: 80,
                                            width: 70,
                                      )),
                                      Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('register'),
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):
                              GestureDetector(
                                onTap: () {
                                  print('go details');
                                  checkDetails(dataList[2]['parrent']);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/active.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                          dataList[2]['username'],
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            ])),
                            SizedBox(height:20),
                            dataList == null?Container():
                            Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                              dataList[3]['parrent'] == 0?
                                 GestureDetector(
                                onTap: () {
                                  print('go register');
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/unactive.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('register'),
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):
                                GestureDetector(
                                onTap: () {
                                   print('go details');
                                   checkDetails(dataList[3]['parrent']);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/active.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                          dataList[3]['username'],
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              dataList[4]['parrent'] == 0?
                              GestureDetector(
                                onTap: () {
                                  print('go register');
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/unactive.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                           MyLocalizations.of(context).getData('register'),
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):
                              GestureDetector(
                                onTap: () {
                                  print('go details');
                                  checkDetails(dataList[4]['parrent']);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/active.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                          dataList[4]['username'],
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              dataList[5]['parrent'] == 0?
                              GestureDetector(
                                onTap: () {
                                  print('go register');
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/unactive.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('register'),
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):
                              GestureDetector(
                                onTap: () {
                                  print('go details');
                                  checkDetails(dataList[5]['parrent']);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/active.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                          dataList[5]['username'],
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              dataList[6]['parrent'] == 0?
                              GestureDetector(
                                onTap: () {
                                  print('go register');
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/unactive.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                          MyLocalizations.of(context).getData('register'),
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):
                              GestureDetector(
                                onTap: () {
                                  print('go details');
                                  checkDetails(dataList[6]['parrent']);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Node()),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Image(
                                            image: AssetImage(
                                                "lib/assets/img/active.png"),
                                            height: 80,
                                            width: 70,
                                          )),
                                      Container(
                                        child: Text(
                                          dataList[6]['username'],
                                          style: TextStyle(fontSize: 14,color: Colors.white),
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
                )),
                ),
                 Spacer(flex: 2,),
                 ],
               ),
            ),
            
          ],
        ));
  }
}
