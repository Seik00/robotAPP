import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkStatus extends StatefulWidget {
  @override
  _WorkStatusState createState() => _WorkStatusState();
}

class _WorkStatusState extends State<WorkStatus> {
  bool isActive = true;

  postData() async {
    Map<String, dynamic> map = {};

    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var contentData = await Request().postRequest(Config().url+"api/pump/work_status", map, token, context);
    // print(bodyData);
    print(contentData);

    if (contentData!=null) {
      if(contentData['status']==true){
        if(contentData['data']['is_active']==0){
          setState(() {
            isActive = false;
            prefs.setInt('is_active', 0);
            
          });
        }else if(contentData['data']['is_active']==1){
          setState(() {
            isActive = true;
            prefs.setInt('is_active', 1);
            
          });
        }else{
          setState(() {
            isActive = !isActive;
            
          });

        }        
      }else{
        setState(() {
          isActive = !isActive;
        });
      }

    }else{
      setState(() {
        isActive = !isActive;
        
      });

    }

  }
  
  getWorkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    var perStatus = prefs.getInt('is_active');
    print(perStatus);
    setState(() {
      if(perStatus==0){
        setState(() {
          isActive = false;
          
        });
      }else if(perStatus==1){
        setState(() {
          isActive = true;
          
        });
      }
      
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWorkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/img/start_background.png'),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          children: [
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.all(0),
              child: Text(
                isActive?MyLocalizations.of(context).getData('welcome'):'Oops',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            
            Expanded(flex:3, child: Container()),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(0),
                  child: Text(
                    isActive?"We're ready to serve you":"Our engineer is step away",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Container(
                  height: 100,
                  // margin: EdgeInsets.only(bottom:20),
                  child: Transform.scale(
                    scale: 2.0,
                    child: CupertinoSwitch(
                      value: isActive,
                      onChanged: (value){
                        setState(() {
                          isActive=value;
                          print(isActive);  
                        });
                        postData();
                      },
                      trackColor: Colors.red,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  child: Text(
                    isActive?" ":"Please wait",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
      
    );
  }
}