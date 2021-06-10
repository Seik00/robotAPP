import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:intl/intl.dart';

class Timeline extends StatefulWidget {
  final projectId;

  Timeline(this.projectId);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

  var timeLineList= [];

  bool isLoading = true;

  getProjectItems() async {

    print(widget.projectId.toString());
    var contentData = await Request().getRequest(Config().url+"/api/pump/get_projectTimeline?project id="+widget.projectId.toString(), context);
    print(contentData);

    if (contentData!=null) {
      if (contentData['status'] == true) {
        if (mounted) {
          setState(() {
            timeLineList = contentData['data']['data'];
            isLoading = false;
          });
        }
      }
    }else{
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

    }
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        child: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0,), 
        preferredSize: Size.fromHeight(0)
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/img/header.png'),
                  fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45)
                )
              ),
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
                  SizedBox(height:20),
                  Center(
                    child: Text("Service Timeline", style: Theme.of(context).textTheme.headline1)
                  ),
                  SizedBox(height:40),
                ],
              ),
            ),
            // SizedBox(height:20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: (isLoading)?Container(
                height: MediaQuery.of(context).size.height/2,
                child: Center(
                  child: CircularProgressIndicator()
                ),
              ):ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: timeLineList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 2.5,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top:30),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(DateFormat('dd').format(DateTime.parse(timeLineList[index]['updated_at'])), style: Theme.of(context).textTheme.bodyText1,),
                                    ),
                                    Container(
                                      child: Text(DateFormat('MMM').format(DateTime.parse(timeLineList[index]['updated_at'])), style: Theme.of(context).textTheme.bodyText2,),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      padding: EdgeInsets.only(top:40),
                                      width: 2,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: checkColor(timeLineList[index]['timeline_type'])
                                        )
                                      ),
                                      padding: EdgeInsets.all(5),
                                    ),
                                    (index==timeLineList.length-1)?Container():Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        // height: 10,
                                        width: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  margin: EdgeInsets.only(top:20),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical:10, horizontal:20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(DateFormat.jm().format(DateTime.parse(timeLineList[index]['updated_at'])), style: Theme.of(context).textTheme.bodyText2,),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: checkColor(timeLineList[index]['timeline_type']),
                                              ),
                                              padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                              child: Text(
                                                timeLineList[index]['timeline_type'], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 30,
                                        // ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(timeLineList[index]['user']['role_info']['display_name'], style: Theme.of(context).textTheme.bodyText1,),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.person),
                                                      SizedBox(width:10),
                                                      Text(timeLineList[index]['user']['name'], style: Theme.of(context).textTheme.bodyText2,),
                                                    ],
                                                  ),
                                                  // Text('Comment', style: Theme.of(context).textTheme.bodyText2,)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      
    );
  }

  checkColor(str){
    switch (str) {
      case 'Pending':{
        return Colors.grey;
      }
      break;
      case 'Active':{
        return Colors.green;
      }
      break;
      case 'In Progress':{
        return Colors.blue;
      }
      break;
      case 'On Hold':{
        return Colors.red;
      }
      break;
      case 'Closed':{
        return Colors.green;
      }
      break;
      case 'Completed':{
        return Colors.green;
      }
      break;
      default:{
        return Colors.amber;
      }
    }
  }
}