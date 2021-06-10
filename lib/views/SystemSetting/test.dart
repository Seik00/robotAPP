import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_treeview/list_treeview.dart';
import 'package:list_treeview/tree/tree_view.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:http/http.dart' as http;

class Testing extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:TreePage(),
    );
  }
}

/// The data class that is bound to the child node
/// You must inherit from NodeData ！！！
/// You can customize any of your properties
class TreeNodeData extends NodeData {
  TreeNodeData({this.label, this.id, this.isRegister}) : super();

  /// Other properties that you want to define
  final String label;
  final id;
  final bool isRegister;

  String property1;
  String property2;
  String property3;
}

class TreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TreePageState();
  }
}

class _TreePageState extends State<TreePage>
    with SingleTickerProviderStateMixin {
  TreeViewController _controller;
  bool _isSuccess;
  List<Color> _colors = [];

  var userId;
  String username;
  var otherUserId;
  var language;

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
   
  }

  getRequest() async {
    var contentData = await Request()
        .getRequest(Config().url + "api/member/get-member-info", context);
    if (contentData != null) {
      if (contentData['code'] == 0) {
        if (mounted) {
          setState(() {
            username = contentData['data']['username'];
            userId = contentData['data']['id'].toString();
          });
        }
      }
    }
  }
  

  initializeData(userId2) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var body = {
      'parent': userId2,
    };
    print(body);
    var uri = Uri.https(Config().url2, 'api/team/downline', body);

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token'
    }).timeout(new Duration(seconds: 10));
    var contentData = json.decode(response.body);
    return contentData['data'];
  }

  @override
  void initState() {
    super.initState();
    getRequest();
    getLanguage();

    ///The controller must be initialized when the treeView create
    _controller = TreeViewController();

    for (int i = 0; i < 100; i++) {
      if (randomColor() != null) {
        _colors.add(randomColor());
      }
    }

    ///Data may be requested asynchronously
    getData();
  }

  void getData() async {
    print('start get data');
    _isSuccess = false;
    await Future.delayed(Duration(seconds: 2));

    var colors1 = TreeNodeData(label: username, id: userId, isRegister: false);

    /// set data
    add(colors1);
    _controller.treeData([colors1]);
    setState(() {
      _isSuccess = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getColor(int level) {
    return _colors[level % _colors.length];
  }

  Color randomColor() {
    return Colors.black;
  }

  /// Add
  void add(TreeNodeData dataNode) async {
    var dataList = await initializeData(dataNode.id);
    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i]['children']) {
        var downLine = dataList[i]['id'].toString();
        var downLineUsername = dataList[i]['text'];
        var newNode = TreeNodeData(
            label: downLineUsername,
            id: downLine,
            isRegister: false);
        _controller.insertAtRear(dataNode, newNode);
        print(dataList);
      } else{
        var newNode = TreeNodeData(
            label: language == 'en'?'Register':'注册',
            id: dataNode.id,
            isRegister: true);
        _controller.insertAtRear(dataNode, newNode);
      }
    }

//    _controller.insertAtRear(dataNode, newNode);
//    _controller.insertAtIndex(1, dataNode, newNode);
  }

  void select(dynamic item) {
    _controller.selectItem(item);
  }

  void selectAllChild(dynamic item) {
    _controller.selectAllChild(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(language == 'en'?'My Team':'我的团队',),
      ),
      body: _isSuccess ? getBody() : getProgressView(),
    );
  }

  Widget getProgressView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getBody() {
    return ListTreeView(
      shrinkWrap: false,
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context, NodeData data) {
        TreeNodeData item = data;
//              double width = MediaQuery.of(context).size.width;
        double offsetX = item.level * 16.0;

        return Container(
          height: 54,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: offsetX),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: InkWell(
                            splashColor: Colors.amberAccent.withOpacity(1),
                            highlightColor: Colors.red,
                            child: Icon(
                              item.isExpand ? Icons.minimize : Icons.add,
                              size: 30,
                              color: Colors.black,
                            )),
                      ),
                      Icon(
                        Icons.people,
                        size: 30,
                        color: Colors.black,
                      ),
                      Text(
                        '${item.label}',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(
                        width: 10,
                      ),
//                          Text(
//                            '${item.label}',
//                            style: TextStyle(color: item.color),
//                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onTap: (NodeData data) {
        TreeNodeData item = data;
        if(!item.isRegister){
          add(data);
        }else{
          print('this is register');
        }
        
        print('index = ${data.index}');
      },
      controller: _controller,
    );
  }
}
