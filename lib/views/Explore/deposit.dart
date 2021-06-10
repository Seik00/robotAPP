import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/views/Explore/depositRecord.dart';
import 'package:robot/views/LoginPage/countryPicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;

class Deposit extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Deposit(this.url, this.onChangeLanguage);

  @override
  _DepositState createState() => _DepositState();
}

class User {
  const User(this.name);    
  final String name;
}

class _DepositState extends State<Deposit> {

  final GlobalKey<CountryPickerState> countryState = GlobalKey<CountryPickerState>();
  final GlobalKey<CountryPickerState> bankState = GlobalKey<CountryPickerState>();
  final GlobalKey<CountryPickerState> newcountryState = GlobalKey<CountryPickerState>();

  var selectedAmount = 0;
  var amountOptions = [100, 300, 500, 1000, 1500, 3000];
  bool visible = true;
  File _image;
  DateTime selectedDate= DateTime.now();
  String base64Image = '';
  String imageId = '';
  final picker = ImagePicker();
  var countryID;
  var dataList =[];
  var dataList2 =[];
  var userInfo;
  var selectedCountryID;
  var selectednewCountryID;
  var selectedCountryCode = '+60';
  var selectednewCountryCode = '';
  var selectedBank = '';
  var selectedBankID = '';
  var selectedBankUser = '';
  var selectedBankNumber = '';
  var selectedBankBranch = '';
  var selectedBankSwiftCode = '';
  var countryList;
  List<String> countryName = [];
  List<String> newcountryName = [];
  List<String> bankName = [];
  var language;
  var total;
  var inputValue;
  var rate;
  var currency;
  var bankID;
  var _firstPress = true ;

  final amountController = TextEditingController();
  final secpwdController = TextEditingController();
  final countryController = TextEditingController();
  final rateController = TextEditingController();

  getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    print(language);
  }

  getRequest() async {
    var contentData = await Request().getRequest(Config().url + "api/member/get-member-info", context);
    if(contentData != null){
      if (contentData['code'] == 0) {
        if (mounted) {
          setState(() {
            countryID = contentData['data']['country_id'].toString();
          });
        }
      }
    }
  }

  initializeData(bankID) async {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var body = {
        'country_id': bankID.toString(),
      };
      print(body);
      var uri = Uri.https(Config().url2, 'api/project/get-deposit-bank', body);

      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token'
      }).timeout(new Duration(seconds: 10));
      var contentData = json.decode(response.body);
    
      setState(() {
          dataList = contentData['data']['system_bank'];
         
          print(dataList);
          for (var i = 0; i < dataList.length; i++) {
            setState(() {
             
              if (countryList[i]["name_en"] == 'Indonesia') {
                selectedBank = dataList[0]["bank_name"];
                selectedBankID = dataList[0]["id"].toString();
                selectedBankUser = dataList[0]["bank_user"].toString();
                selectedBankNumber = dataList[0]["bank_number"].toString();
                selectedBankBranch = dataList[0]["branch"].toString();
                selectedBankSwiftCode = dataList[0]["swift_code"].toString();
              }
             
                 bankName.add(dataList[i]["bank_name"]);
                return bankName;
             
              
              //print(bankName[i]);
            });
          }
          if(dataList.length == 0){
              selectedBank = '';
              selectedBankID = '';
              selectedBankUser = '';
              selectedBankNumber = '';
              selectedBankBranch = '';
          }else if(dataList.length != 0){
            
          }
        });
  }

  //  getSystemBankID() async {
  //   var contentData = await Request().getRequest(Config().url + "api/project/get-deposit-bank", context);
  //   if(contentData != null){
  //     if (contentData['code'] == 0) {
  //     if (mounted) {
  //       setState(() {
  //         dataList = contentData['data']['system_bank'];
  //         selectedBank = dataList[0]["bank_name"];
  //         selectedBankID = dataList[0]["id"].toString();
  //         selectedBankUser = dataList[0]["bank_user"].toString();
  //         selectedBankNumber = dataList[0]["bank_number"].toString();
  //         selectedBankBranch = dataList[0]["branch"].toString();
  //         selectedBankSwiftCode = dataList[0]["swift_code"].toString();
  //         print(dataList);
  //         for (var i = 0; i < dataList.length; i++) {
  //           setState(() {
  //             if (countryList[i]["name_en"] == 'Malaysia') {
  //               selectednewCountryCode = language == 'en'?countryList[i]["name_en"]:countryList[i]["name"];
  //               selectednewCountryID = countryList[i]['id'];
  //             }
  //             bankName.add(dataList[i]["bank_name"]);
              
  //             print(bankName[i]);
  //           });
  //         }
  //       });
  //     }
  //   }
  //   }
  // }

   getCountryList() async {
    var contentData = await Request().getRequest(Config().url + "api/global/country_list", context);
  
    if (contentData != null) {
      if (contentData['status'] == true) {
        countryList = contentData['data'];
        for (var i = 0; i < countryList.length; i++) {
          setState(() {
            if (countryList[i]["name_en"] == 'Malaysia') {
              selectedCountryCode = language == 'en'?countryList[i]["name_en"]:countryList[i]["name"];
              selectednewCountryCode = language == 'en'?countryList[i]["name_en"]:countryList[i]["name"];
              selectedCountryID = countryList[i]['id'];
              selectednewCountryID = countryList[i]['id'];
              currency = countryList[i]["short_form"];
              rate = countryList[i]["sell"];
            }
            countryName.add(language == 'en'?countryList[i]["name_en"]:countryList[i]["name"]);
            newcountryName.add(language == 'en'?countryList[i]["name_en"]:countryList[i]["name"]);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getRequest();
    getCountryList();
    initializeData('2');
    getLanguage();
  }
  upload(file) async {
    Map<String, String> headers = {};
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if(token!=null){
      headers = {'Authorization': 'Bearer' + token};

    }

    var uri = Uri.parse("https://sae.ceo/api/upload/upload-file");
    var request = new http.MultipartRequest("POST", uri);
    // ignore: deprecated_member_use
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var multipartFile = new http.MultipartFile('file', stream, length,
    filename: path.basename(file.path));
    //contentType: new MediaType('image', 'png'));

    request.headers.addAll(headers);
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      var contentData=json.decode(value);
      print(contentData);
      setState(() {
        imageId = contentData['data'].toString();
      });
      Map<String, dynamic> map = {};
      map['amount'] = amountController.text;
      map['document'] = imageId;
      map['sec_password'] = secpwdController.text;
      map['system_bank_id'] = selectedBankID.toString();
      map['country_id'] =selectedCountryID.toString();
      print(map['system_bank_id']);
      print(map['country_id']);
      postData(map);

    });
  }
  

  Future _imgFromGallery() async {
    print(true);
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 5);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _imgFromCamera() async {
    print(true);
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 5);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/wallet/deposit", bodyData, token, context);
    
    print(contentData);
    if (contentData!=null) {
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
       
      }
      setState(() {
        _firstPress = true ;
      });
    }
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
      body: NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (scrollNotification){
          if (scrollNotification is ScrollStartNotification) {
            countryState.currentState.closeMenu();
            newcountryState.currentState.closeMenu();
            bankState.currentState.closeMenu();
          }else if (scrollNotification is ScrollUpdateNotification) {
            countryState.currentState.closeMenu();
            newcountryState.currentState.closeMenu();
            bankState.currentState.closeMenu();
          } else if (scrollNotification is ScrollEndNotification) {
            countryState.currentState.closeMenu();
            newcountryState.currentState.closeMenu();
            bankState.currentState.closeMenu();
          }
        }, 
        child: new GestureDetector(
           onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            countryState.currentState.closeMenu();
            newcountryState.currentState.closeMenu();
            bankState.currentState.closeMenu();
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
                                  MaterialPageRoute(builder: (context) => DepositRecord(widget.url)),
                                );
                            },
                            child:Container(
                              alignment: Alignment.bottomRight,
                              child: 
                              Text(MyLocalizations.of(context).getData('deposit_record'),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        child: Text(
                          MyLocalizations.of(context).getData('deposit'),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.2)
                      ),
                      child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(left: 10, right: 10,),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                            countryList == null?Container():
                            ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: countryList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      children: [
                                      Container(
                                          margin: EdgeInsets.only(right:10),
                                          child: Image(
                                            image: NetworkImage(
                                              countryList ==null?
                                              'https://philip.greatwallsolution.com/sae.png':
                                              countryList[index]['flag']),
                                            height: 60,
                                            width: 60,
                                          )
                                        ),
                                      SizedBox(width:20),
                                      Container(
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Text(MyLocalizations.of(context).getData('country'),style: TextStyle(color:Colors.white,fontSize:14,)),
                                            Text(language=='zh'?countryList[index]['name']:countryList[index]['name_en'],style: TextStyle(color:Colors.grey,fontSize:16,fontWeight:FontWeight.bold)),
                                          ]
                                        )
                                      ),
                                      SizedBox(width:20),
                                      Expanded(
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children:[
                                            Text(MyLocalizations.of(context).getData('rate'),style: TextStyle(color:Colors.white,fontSize:14,)),
                                            Text(countryList[index]['sell'],style: TextStyle(color:Colors.purpleAccent,fontSize:16,fontWeight:FontWeight.bold)),
                                          ]
                                        )
                                      ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                              ),
                            );
                            }),
                            ],
                          ),
                        ),
                      )),
                    ),  
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff7CAAD5), Color(0xff8263CE)])
                        ),
                        child: Column(children: [
                          Center(
                            child:Text(MyLocalizations.of(context).getData('enter_amount')+'(USD)',style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                          TextField(
                            onChanged: (String values) async {
                              if (values == "") {
                                total = 0;
                                print(total);
                              } else {
                                inputValue = double.parse(values);
                                total = inputValue*double.parse(rate);
                                setState(() {
                                  rateController.text = total.toStringAsFixed(2); 
                                  print(total);
                                });
                                
                                
                              }
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                enabledBorder: UnderlineInputBorder(      
                                  borderSide: BorderSide(color: Colors.white),   
                                ),  
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Colors.white)),
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ],),
                      ),
                    ),
                    
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(MyLocalizations.of(context).getData('select_amount'),
                            style: TextStyle(color: Colors.white))),
                    Container(  
                        padding: EdgeInsets.all(20),
                        child: new GridView.builder(
                            itemCount: amountOptions.length,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.6,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      amountController.text = amountOptions[index].toString();
                                      selectedAmount = amountOptions[index];
                                      inputValue = selectedAmount;
                                      total = inputValue*double.parse(rate);
                                      setState(() {
                                        rateController.text = total.toStringAsFixed(2); 
                                        print(total);
                                      });
                                    });
                                  },
                                  color: (selectedAmount == amountOptions[index])
                                      ? Colors.purple
                                      : Colors.deepPurpleAccent,
                                      
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                          color: Colors.deepPurpleAccent)),
                                  child:Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('USD',style: TextStyle(color: Colors.white),),
                                        Text(amountOptions[index].toString(),style:TextStyle(fontSize: 20,color: Colors.white),),
                                    ],),
                                  )
                                      
                                );
                            })
                      ),
                      Container(
                          margin: EdgeInsets.only(left:20,right: 20),
                          child: Text(MyLocalizations.of(context).getData('country_rate'),style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                        countryList == null?Container():
                        Row(
                        children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left:20,right: 20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                
                                  child: CountryPicker(
                                    key: countryState,
                                    name: selectedCountryCode,
                                    lists: countryName,
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(width: 1, color: Colors.white),
                                    onChange: (index) {
                                        newcountryState.currentState.closeMenu();
                                        bankState.currentState.closeMenu();
                                        setState(() {
                                        if(amountController.text==''){
                                          AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title: 'Error',
                                          desc: MyLocalizations.of(context).getData('amount_fill_in'),
                                          btnOkOnPress: () {},
                                          btnOkText: MyLocalizations.of(context).getData('close'),
                                          btnOkIcon: Icons.cancel,
                                          btnOkColor: Colors.red)
                                        ..show();
                                        }
                                        else if(amountController.text!=''){
                                          selectedCountryCode = language =='en'?countryList[index]["name_en"]:countryList[index]["name"];
                                          selectedCountryID = countryList[index]["id"];
                                          currency = countryList[index]["short_form"];
                                          rate = countryList[index]['sell'];

                                          total = inputValue*double.parse(rate);
                                          rateController.text = total.toStringAsFixed(2); 
                                          print(total);
                                      
                                          print(currency);
                                        }
                                      });
                                    
                                    },
                                  ),
                                ),
                              ),
                        ],
                      ),
                      SizedBox(height:20),
                        Container(
                          margin: EdgeInsets.only(left:20,right: 20),
                          child: Text(MyLocalizations.of(context).getData('need_paid'),style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                      Container(
                        margin: EdgeInsets.only(left: 20,right: 20,top: 5),
                        child: Stack(
                          children: [
                            TextFormField(
                                readOnly: true,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText:  rateController.text,
                                    contentPadding: const EdgeInsets.only(left:60.0,right:16,top:16,bottom:16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(color: Colors.grey, width: 1),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white),
                                onSaved: (str) {
                                }),
                            Container(
                              padding: EdgeInsets.only(left: 10,top:18,),
                              child: Text(currency == null?'':currency,style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height:20),
                      Container(
                          margin: EdgeInsets.only(left:20,right: 20),
                          child: Text(MyLocalizations.of(context).getData('country'),style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                        countryList == null?Container():
                        Row(
                        children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left:20,right: 20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                
                                  child: CountryPicker(
                                    key: newcountryState,
                                    name: selectednewCountryCode,
                                    lists: newcountryName,
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(width: 1, color: Colors.white),
                                    onChange: (index) {
                                        countryState.currentState.closeMenu();
                                        bankState.currentState.closeMenu();
                                        setState(() {
                                          
                                          selectednewCountryCode = language =='en'?countryList[index]["name_en"]:countryList[index]["name"];
                                          selectednewCountryID = countryList[index]["id"];
                                          bankID = selectednewCountryID;
                                          initializeData(bankID);
                                          bankName = [];
                                      });
                                    
                                    },
                                  ),
                                ),
                              ),
                        ],
                      ),
                      SizedBox(height:20),
                        Container(
                          margin: EdgeInsets.only(left:20,right: 20),
                          child: Text(MyLocalizations.of(context).getData('bank_name'),style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                      Row(
                        children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left:20,right: 20,top: 5),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                
                                  child: CountryPicker(
                                    key: bankState,
                                    name: selectedBank,
                                    lists: bankName,
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(width: 1, color: Colors.white),
                                    onChange: (index) {
                                       countryState.currentState.closeMenu();
                                       newcountryState.currentState.closeMenu();
                                        setState(() {
                                          selectedBank = dataList[index]["bank_name"];
                                          selectedBankID = dataList[index]["id"].toString();
                                          selectedBankUser = dataList[index]["bank_user"].toString();
                                          selectedBankNumber = dataList[index]["bank_number"].toString();
                                          selectedBankBranch = dataList[index]["branch"].toString();
                                          selectedBankSwiftCode = dataList[index]["swift_code"].toString();
                                          print(selectedBankID);
                                      });
                                    
                                    },
                                  ),
                                ),
                              ),
                        ],
                      ),
                      SizedBox(height:20),
                        Container(
                          margin: EdgeInsets.only(left:20,right: 20),
                          child: Text(MyLocalizations.of(context).getData('bank_details'),style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                           decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff9957ED), Color(0xff7835E5)])
                          ),
                           margin: EdgeInsets.only(left:20,right: 20,top: 5),
                           child: Column(children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                  Container(
                                   padding: EdgeInsets.all(10),
                                   child: Text(MyLocalizations.of(context).getData('bank_user'),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)),
                                  Container(
                                   padding: EdgeInsets.all(10),
                                   child: Text(selectedBankUser,style: TextStyle(color:Colors.white,))),
                               ],
                             ),
                             Divider(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                  Container(
                                   padding: EdgeInsets.all(10),
                                   child: Text(MyLocalizations.of(context).getData('bank_number'),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)),
                                  Container(
                                   padding: EdgeInsets.all(10),
                                   child: Text(selectedBankNumber,style: TextStyle(color:Colors.white,),)),
                               ],
                             ),
                             Divider(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                  Container(
                                   padding: EdgeInsets.all(10),
                                   child: Text(MyLocalizations.of(context).getData('bank_branch'),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)),
                                  Container(
                                   padding: EdgeInsets.all(10),
                                   child: Text(selectedBankBranch,style: TextStyle(color:Colors.white,))),
                               ],
                             ),
                            //  Divider(
                            //           height: 2,
                            //           color: Colors.white,
                            //         ),
                            //  Row(
                            //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //    children: [
                            //       Container(
                            //        padding: EdgeInsets.all(10),
                            //        child: Text(MyLocalizations.of(context).getData('swift_code'),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)),
                            //       Container(
                            //        padding: EdgeInsets.all(10),
                            //        child: Text(selectedBankSwiftCode,style: TextStyle(color:Colors.white,))),
                            //    ],
                            //  ),
                           ],),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 5),
                        //   child: TextFormField(
                        //     readOnly: true,
                        //     obscureText: visible,
                        //     autovalidateMode: AutovalidateMode.onUserInteraction,
                        //     decoration: new InputDecoration(
                        //           hintText:  rateController.text,
                        //           contentPadding: const EdgeInsets.all(8.0),
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(8.0),
                        //             borderSide: BorderSide(color: Colors.grey, width: 1),
                        //           ),
                        //           filled: true,
                        //           fillColor: Colors.white,
                        //         ),
                        //     keyboardType: TextInputType.text,
                        //     onSaved: (str) {
                        //       print(str);
                        //     },
                        //   ),
                        // ),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: (){_showPicker(context);},
                          child: Container(
                            decoration: _image!=null?BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_image),
                                fit: BoxFit.cover
                              )
                            ):BoxDecoration(
                              color: Colors.white
                            ),
                            height: MediaQuery.of(context).size.height/4,
                            child: (_image!=null)?Center():Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt),
                                  SizedBox(width:10),
                                  Text(MyLocalizations.of(context).getData('upload_cert'), style: TextStyle(color: Theme.of(context).buttonColor),)
                                ],
                              ),
                            ),
                          ),
                        )
                        ),
                        Container(
                          margin: EdgeInsets.only(left:20,right: 20),
                          child: Text(MyLocalizations.of(context).getData('sec_password'),style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 5),
                          child: TextFormField(
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
                                ),
                            keyboardType: TextInputType.text,
                            onSaved: (str) {
                              print(str);
                            },
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: !_firstPress,
                          child: GestureDetector(
                              onTap: ()async{
                                setState(() {
                                if(_image == null){
                                  AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: false,
                                  title: 'Error',
                                  desc: MyLocalizations.of(context).getData('cert_fill_in'),
                                  btnOkOnPress: () {},
                                  btnOkText: MyLocalizations.of(context).getData('close'),
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red)
                                ..show();
                                }else if(amountController.text.isEmpty && secpwdController.text.isEmpty){
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
                                }else if(_image!=null){
                                  upload(_image);
                                  print(imageId);
                                  _firstPress = false ;
                                }else{
                                  Map<String, dynamic> map = {};
                                  map['amount'] = amountController.text;
                                  map['document'] = imageId;
                                  map['sec_password'] = secpwdController.text;
                                  print(map['amount']);
                                  print(map['document']);
                                  print(map['sec_password']);
                                  postData(map);
                                  _firstPress = false ;
                                }
                                });
                                
                              }, 
                          child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0xff3DC2EA), Color(0xff7C1999)])
                                ),
                                margin: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width/2,
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
      ),
    );
  }
  void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
