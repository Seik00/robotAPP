import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';

class ProjectItems extends StatefulWidget {
  @override
  _ProjectItemsState createState() => _ProjectItemsState();
}

class _ProjectItemsState extends State<ProjectItems> {
  final TextEditingController _searchController = new TextEditingController();

  List stockList = [];  
  List _searchResult = [];  

  getProjectItems() async {
    var contentData = await Request().getRequest(Config().url+"api/pump/stock_list", context);
    print(contentData);

    if (contentData['status'] == true) {
      if (mounted) {
        setState(() {
          stockList = contentData['data']['data'];
        });
      }
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    stockList.forEach((item) {
      if (item['name'].contains(text))
        _searchResult.add(item);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProjectItems();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0,), 
        preferredSize: Size.fromHeight(0)
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
            SizedBox(height:0),
            Center(
              child: Text("Stocks", style: Theme.of(context).textTheme.headline1)
            ),
            SizedBox(height:20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value){onSearchTextChanged(value);},
                // validator: validateCustomername,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(     
                  isDense: true, 
                  hintText: 'Stock Name',
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
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  // borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                ),
                child: (_searchController.text!='')?_listBuilder(_searchResult):_listBuilder(stockList)
              )
            )
          ],
        ),
      ),
      
    );
  }

  _listBuilder(list){
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.pop(context, list[index]);
          },
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list[index]['name'],
                        style: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Product Code:'),
                              Text(
                                list[index]['product_code'],style: 
                                TextStyle(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Quantity:'),
                              Text(
                                list[index]['quantity'].toString(),style: 
                                TextStyle(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}