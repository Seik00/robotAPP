import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/pump/createPump.dart';

class MyPump extends StatefulWidget {
  final initial;

  MyPump(this.initial);
  @override
  _MyPumpState createState() => _MyPumpState();
}

class _MyPumpState extends State<MyPump> {

  final TextEditingController _searchController = new TextEditingController();

  List pumpList = [];  
  List _searchResult = [];  

  bool loading = true;

  getMyPump() async {
    var contentData = await Request().getRequest(Config().url+"api/pump/myPump", context);
    // print(contentData['data'][6]);

    if (contentData!=null) {
      if (contentData['status'] == true) {
        if (mounted) {
          setState(() {
            loading = false;
            pumpList = contentData['data'];
          });
        }
      }
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    pumpList.forEach((item) {
      if (item['invoice_no'].contains(text)||item['distributor'].contains(text))
        _searchResult.add(item);
      else
        if(item['pump_model']!=null){
          item['pump_model'].forEach((k, y){
            // print(item['pump_model']);
            switch (k) {
              case 'pump_model':{
                if (y.contains(text))
                  _searchResult.add(item);
              }
                break;
              case 'product_code':{
                if (y.contains(text))
                  _searchResult.add(item);
              }
                break;
              default:
            }
             

          });
        }
        
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyPump();

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        child: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0,), 
        preferredSize: Size.fromHeight(0)
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.initial)?Container():IconButton(
                    icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,), 
                    onPressed: ()=>Navigator.pop(context)
                  ),
                  GestureDetector(
                    onTap: ()=>Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>CreatePump(null)
                      )
                    ).then((value) => getMyPump()),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Colors.grey[700], size: 40,),
                    ),
                  ),
                ],
              ),
              SizedBox(height:0),
              Center(
                child: Text("My Pump", style: Theme.of(context).textTheme.headline1)
              ),
              SizedBox(height:20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value){onSearchTextChanged(value);},
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(     
                    isDense: true, 
                    hintText: 'Model/Series No/warranty/Part No/Invoice/Product Code',
                    hintStyle: TextStyle(color:Colors.grey[300], fontSize:12),
                    suffixIconConstraints:BoxConstraints(minWidth: 40, maxHeight: 40),
                    suffixIcon: (_searchController.text!='')?IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 30,),
                      onPressed: (){
                        setState(() {
                          _searchController.text='';
                        });
                      } ,
                    ):IconButton(
                      icon: Icon(Icons.search, color: Colors.white, size: 30,),
                      onPressed: (){
                        // setState(() {
                        //   _searchController.text='';
                        // });
                      } ,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical:10), 
                    enabledBorder: UnderlineInputBorder(borderSide: new BorderSide(color: Colors.white)),  
                    focusedBorder: UnderlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                    border: UnderlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height:20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                ),
                child: (loading)?Container(
                  height: MediaQuery.of(context).size.height/2,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                  :(_searchController.text!="")?_listBuilder(_searchResult):Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: (pumpList.isNotEmpty)?pumpList.length:0,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            margin: EdgeInsets.only(top:10, bottom:30),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1, color: Colors.grey[300]
                                )
                              )
                            ),
                            child: Stack(
                              children: <Widget>[
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  margin: EdgeInsets.fromLTRB(30, 35, 30, 35),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20, 35, 20, 15),
                                    child: (pumpList[index]['pump_model']!=null)?Column(
                                      children: [
                                        SizedBox(height:20),
                                        Text(pumpList[index]['pump_model']['pump_model'].toString(), style: TextStyle(
                                          color: Theme.of(context).buttonColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        ),),
                                        SizedBox(height:20),
                                        Divider(
                                          height: 2,
                                        ),
                                        SizedBox(height:20),
                                        Container(
                                          padding: EdgeInsets.only(bottom:15, left: 30),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text('Product code:', style: TextStyle(
                                                  color: Theme.of(context).buttonColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(pumpList[index]['pump_model']['product_code'].toString(), style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom:15, left: 30),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text('Part no:', style: TextStyle(
                                                  color: Theme.of(context).buttonColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(pumpList[index]['distributor'].toString(), style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom:15, left: 30),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text('Invoice no:', style: TextStyle(
                                                  color: Theme.of(context).buttonColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(pumpList[index]['invoice_no'].toString(), style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height:10),
                                        RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          color: Colors.blueAccent[800],
                                          onPressed: (){
                                            if(widget.initial){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>CreatePump(pumpList[index])
                                                )
                                              ).then((value) => getMyPump());
                                            }else{
                                              Navigator.pop(context, pumpList[index]);

                                            }
                                          }, 
                                          child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 50),
                                            // width: double.infinity,
                                            child: Text(
                                              (widget.initial)?'Details':'Select', 
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ):Container(),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(70),
                                      color: Colors.grey,
                                      image: (pumpList[index]['uploaded_file'].length>0)?DecorationImage(
                                        image: NetworkImage(pumpList[index]['uploaded_file'][0]['public_image_path']),
                                        fit: BoxFit.fill
                                      ):null
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  _listBuilder(_list){
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: (_list.isNotEmpty)?_list.length:0,
      itemBuilder: (BuildContext ctxt, int index) {
        return new GestureDetector(
          onTap: () {
          },
          child: Container(
            margin: EdgeInsets.only(top:10, bottom:30),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1, color: Colors.grey[300]
                )
              )
            ),
            child: Stack(
              children: <Widget>[
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.fromLTRB(30, 35, 30, 35),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 35, 20, 15),
                    child: (_list[index]['pump_model']!=null)?Column(
                      children: [
                        SizedBox(height:20),
                        Text(_list[index]['pump_model']['pump_model'].toString(), style: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),),
                        SizedBox(height:20),
                        Divider(
                          height: 2,
                        ),
                        SizedBox(height:20),
                        Container(
                          padding: EdgeInsets.only(bottom:15, left: 30),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Product code:', style: TextStyle(
                                  color: Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(_list[index]['pump_model']['product_code'].toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom:15, left: 30),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Part no:', style: TextStyle(
                                  color: Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(_list[index]['distributor'].toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom:15, left: 30),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Invoice no:', style: TextStyle(
                                  color: Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(_list[index]['invoice_no'].toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height:10),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.blueAccent[800],
                          onPressed: (){
                            if(widget.initial){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>CreatePump(pumpList[index])
                                )
                              ).then((value) => getMyPump());
                            }else{
                              Navigator.pop(context, pumpList[index]);

                            }
                          }, 
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            // width: double.infinity,
                            child: Text(
                              (widget.initial)?'Details':'Select', 
                              textAlign: TextAlign.center,
                              style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ):Container(),
                  ),
                ),
                Center(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: Colors.grey,
                      image: (_list[index]['uploaded_file'].length>0)?DecorationImage(
                        image: NetworkImage(_list[index]['uploaded_file'][0]['public_image_path']),
                        fit: BoxFit.fill
                      ):null
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}