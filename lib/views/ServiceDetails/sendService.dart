import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/ServiceDetails/projectItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendService extends StatefulWidget {
  final projectID;
  final itemList;

  SendService(this.projectID, this.itemList);
  @override
  _SendServiceState createState() => _SendServiceState();
}

class _SendServiceState extends State<SendService> {
  var itemList;
  var quantity = 0;
  var maxQuantity = 0;
  var itemId;
  var price = "0.00";
  String item = "";
  TextEditingController quantityController;

  getProjectItem() async {
    // var contentData = await Request().getRequest(Config().url+"api/pump/get_project_item?project_id="+widget.projectID.toString(), context);

    // print(contentData);
    // if (contentData['status'] == true) {
      if (mounted) {
        setState(() {
          itemList = widget.itemList;
          if (itemList.length>0) {
            item = itemList[0]['stock_info']['name'].toString();
            quantity = itemList[0]['quantity'];
            quantityController.text = itemList[0]['quantity'].toString();
            maxQuantity = itemList[0]['stock_info']['quantity'];
            itemId = itemList[0]['stock_info']['id'];
            price = itemList[0]['stock_info']['price'];
          }
        });
      }
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProjectItem();
    quantityController = new TextEditingController(text: '0');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        child: AppBar(backgroundColor: Colors.transparent, elevation: 0, brightness: Brightness.dark,), 
        preferredSize: Size.fromHeight(0),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,), 
                  onPressed: ()=>Navigator.pop(context)
                ),
              ],
            ),
            SizedBox(height:10),
            Center(
              child: Text("Send Service Quote", style: Theme.of(context).textTheme.headline1)
            ),
            SizedBox(height:50),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: EdgeInsets.all(0),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                                    child: (item!='')?Text(
                                      item, 
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1
                                    ):Text(
                                      'Project Item', 
                                      style: TextStyle(color:Colors.grey[300])
                                    )
                                  ),
                                ),
                                
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: new BoxDecoration(
                                    color: Theme.of(context).indicatorColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Icon(Icons.add, color: Colors.white, size: 16)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>ProjectItems()
                          )
                        ).then((value){
                          if (value!=null) {
                            setState(() {
                              item= value['name'];
                              itemId= value['id'].toString();
                              maxQuantity= value['quantity'];
                              price= value['price'];
                              quantityController.text = "0";
                              quantity = 0;
                              // print(model);
                            });
                          }
                        });
                      }
                    ),
                    SizedBox(height:20),
                    
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.all(0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Stock Quantity:', style: Theme.of(context).textTheme.bodyText1)),
                            GestureDetector(
                              onTap: (){
                                if (quantity>0) {
                                  setState(() {
                                    quantity -=1;
                                    quantityController.text = quantity.toString();
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(Icons.remove)
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: quantityController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  // hintText: 'Write your remark here',
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              )
                            ),
                            GestureDetector(
                              onTap: (){
                                if (quantity<maxQuantity) {
                                  setState(() {
                                    quantity +=1;
                                    quantityController.text = quantity.toString();
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(Icons.add)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:20),
                    
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.all(0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Price(RM) :', style: Theme.of(context).textTheme.bodyText1)
                            ),
                            Expanded(
                              child: Text((quantity*double.parse(price)).toStringAsFixed(2), style: Theme.of(context).textTheme.bodyText1)
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            )
          ]
        )
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: (_checkValidate())?(){postData();}:null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        label: Container(
          width: MediaQuery.of(context).size.width/1.5,
          child: Text(
            'Send Service Quote', 
            textAlign: TextAlign.center,
            style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: (_checkValidate())?Theme.of(context).buttonColor:Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  postData() async {
    Map<String, dynamic> map = {};
    map['project_request_id'] = widget.projectID.toString();
    map['stock_id'] = itemId.toString();
    map['quantity'] = quantity.toString();

    print(map);

    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var contentData = await Request().postRequest(Config().url+"api/pump/used_stock", map, token, context);
    // print(bodyData);
    print(contentData);
    if (contentData['status'] == true) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Submitted Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFDCDCDC),
        textColor: Colors.black,
        timeInSecForIos: 2
      );
    }
    

  }

  _checkValidate(){
    if(quantity>=0 && itemId!=null){
      return true;

    }else{
      return false;
    }
  }
}