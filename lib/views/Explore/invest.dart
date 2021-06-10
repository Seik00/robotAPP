import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/Explore/investRecord.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Invest extends StatefulWidget {
   final url;

  Invest(this.url);
  @override
  _InvestState createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  var selectedAmount = 0;
  var dataList = [];
   var pointOne;
  bool visible = true;

  final secpwdController = TextEditingController();

  var language;
  var _firstPress = true ;
  
  getLanguage() async{
      final prefs = await SharedPreferences.getInstance();
      language = prefs.getString('language');
  }
  getInfo() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
         pointOne = contentData['data']['point1'];
        });
      }
    }
    }
  }

   getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/package/get-package", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
      if (mounted) {
        setState(() {
          print(contentData);
          dataList = contentData['data'];
          // username = contentData['data']['username'];
        });
      }
    }
    }
  }

  @override
  void initState() {
    super.initState();
    getRequest();
    getInfo();
    getLanguage();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                  margin: EdgeInsets.only(right:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context, true)),
                      GestureDetector(
                        onTap: (){
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InvestRecord(widget.url)),
                            );
                        },
                        child:Container(
                          alignment: Alignment.bottomRight,
                          child: 
                          Text(MyLocalizations.of(context).getData('invest_record'),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                      )
                    ],
                  ),
                ),
                  Center(
                    child: Container(
                      child: Text(
                        MyLocalizations.of(context).getData('invest_package'),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                   Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.purple,
                      ),
                      child: Column(children: [
                        Center(
                          child:Text(MyLocalizations.of(context).getData('my_balance'),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text('USD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                            Padding(padding: EdgeInsets.only(left: 10.0)),
                            Container(
                              child:pointOne == null
                                ? Container(
                                    child: Row(
                                    children: <Widget>[
                                      SkeletonAnimation(
                                        child: Container(
                                          width: 100.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                                : Container(
                                    child: Text(
                                      pointOne,
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                          ],)
                        ),
                      ],),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.only(top: 5,left: 20,right: 20),
                      child: new GridView.builder(
                          itemCount: dataList.length,
                          primary: false,
                          shrinkWrap: true,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return FlatButton(
                                onPressed: () {
                                  setState(() {
                                    selectedAmount = dataList[index]['id'];
                                    print(selectedAmount);
                                    print('--------------------');
                                  });
                                },
                                color: (selectedAmount == dataList[index]['id'])
                                    ? Colors.purple
                                    : Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                        color: Colors.deepPurpleAccent)),
                                child:Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      language == 'zh'?
                                      Text(dataList[index]['package_name'],textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 13),):
                                      Text(dataList[index]['package_name_en'],textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 11),),
                                      Text(dataList[index]['display_price'],style: TextStyle(color: Colors.white,fontSize: 12),),
                                  ],),
                                )
                                    
                              );
                          })
                      ),
                      SizedBox(height:20),
                      Center(
                        child: Container(
                                width: MediaQuery.of(context).size.width/1.6,
                                margin: EdgeInsets.only(left: 20,right: 20,top: 5),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  autofocus: false,
                                  controller: secpwdController,
                                  obscureText: visible,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(8.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: BorderSide(color: Colors.grey, width: 1),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: MyLocalizations.of(context).getData('sec_password'),
                                  
                                      ),
                                  keyboardType: TextInputType.text,
                                  onSaved: (str) {
                                    print(str);
                                  },
                                ),
                              ),
                      ),
                  AbsorbPointer(
                    absorbing: !_firstPress,
                    child: GestureDetector(
                       onTap: ()async{
                                setState(() {
                                if(secpwdController.text.isEmpty){
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.RIGHSLIDE,
                                    headerAnimationLoop: false,
                                    title: 'Error',
                                    desc: MyLocalizations.of(context).getData('please_fill_in'),
                                    btnOkOnPress: () {},
                                    btnOkText: MyLocalizations.of(context).getData('close'),
                                    btnOkIcon: Icons.cancel,
                                    btnOkColor: Colors.red)
                                  ..show();
                                }else{
                                  Map<String, dynamic> map = {};
                                  map['user_group'] = selectedAmount.toString();
                                  map['pay_type'] = 'P1';
                                  map['sec_password'] = secpwdController.text;
                                  print(map['user_group']);
                                  print(map['pay_type']);
                                  print(map['sec_password']);
                                  postData(map);
                                   _firstPress = false ;
                                }
                                });
                                
                              }, 
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(67, 71, 241, 1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                          width: MediaQuery.of(context).size.width/1.6,
                          height: MediaQuery.of(context).size.height / 15,
                          alignment: Alignment.center,
                          child: Text(
                             MyLocalizations.of(context).getData('submit'),
                            
                            style: TextStyle(color: Colors.white),
                          )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/package/upgrade-package", bodyData, token, context);
    
    print(contentData);
    if (contentData['code'] == 0) {
          
           AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            autoHide: Duration(seconds: 2),
            title: MyLocalizations.of(context).getData('success'),
            desc:MyLocalizations.of(context).getData('operation_success'),
            onDissmissCallback: () {
              Navigator.pop(context);
            })
          ..show();
    } else {
       setState(() {
            _firstPress = true ;
          });
    }
  }
}
