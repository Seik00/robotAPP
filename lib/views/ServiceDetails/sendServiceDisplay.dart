import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/ServiceDetails/sendService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDisplay extends StatefulWidget {
  final projectID;

  ServiceDisplay(this.projectID);
  @override
  _ServiceDisplayState createState() => _ServiceDisplayState();
}

class _ServiceDisplayState extends State<ServiceDisplay> {
  var itemList = [];
  var quantity = 0;
  var maxQuantity = 0;
  var itemId;
  var price = "0.00";
  var roleID = 2;
  String item = "";
  TextEditingController quantityController;
  
  getProjectItem() async {
    final prefs = await SharedPreferences.getInstance();
    
    roleID= prefs.getInt("roleId");
    var contentData = await Request().getRequest(Config().url+"api/pump/get_project_item?project_id="+widget.projectID.toString(), context);

    print(contentData);
    if (contentData['status'] == true) {
      if (mounted) {
        setState(() {
          itemList = contentData['data'];
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
    }
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
              child: Text("Selected Stock", style: Theme.of(context).textTheme.headline1)
            ),
            SizedBox(height:50),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                ),
                child: (itemList.length>0)?Column(
                  children: [
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
                              child: Text('Stock Name :', style: Theme.of(context).textTheme.bodyText1)
                            ),
                            Expanded(
                              child: Text(item, style: Theme.of(context).textTheme.bodyText1)
                            )
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
                              child: Text('Stock Quantity:', style: Theme.of(context).textTheme.bodyText1)),
                            // GestureDetector(
                            //   onTap: (){
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(horizontal: 15),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //     ),
                            //     child: Icon(Icons.remove)
                            //   ),
                            // ),
                            Expanded(
                              child: Text((quantity).toString(), style: Theme.of(context).textTheme.bodyText1)
                            )
                            // GestureDetector(
                            //   onTap: (){
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(horizontal: 15),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //     ),
                            //     child: Icon(Icons.add)
                            //   ),
                            // ),
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
                ):Center(
                  child: Text('No stock was selected'),
                ),
              )
            )
          ]
        )
      ),
      floatingActionButton: (roleID==3)?FloatingActionButton(
        elevation: 0,
        onPressed: ()=>Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>SendService(widget.projectID, itemList)
          )
        ).then((value) => getProjectItem()),
        child: Icon(Icons.edit, size: 40, color: Colors.white,),
        backgroundColor: Theme.of(context).indicatorColor,
      ):null,
    );
    
  }
}