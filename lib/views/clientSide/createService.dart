import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/pump/pumps.dart';
import 'package:robot/views/clientSide/simpleMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateService extends StatefulWidget {
  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  final GlobalKey<FormState> _key = new GlobalKey();

  final GlobalKey<SimpleMenuState> _usageTState = GlobalKey<SimpleMenuState>();
  final GlobalKey<SimpleMenuState> _requestTState = GlobalKey<SimpleMenuState>();
  final GlobalKey<SimpleMenuState> _natureRState = GlobalKey<SimpleMenuState>();
  
  final TextEditingController _remarkController = new TextEditingController();

  final TextEditingController _customerController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _addressline1Controller = new TextEditingController();
  final TextEditingController _addressline2Controller = new TextEditingController();
  final TextEditingController _cityController = new TextEditingController();
  final TextEditingController _countryController = new TextEditingController();
  final TextEditingController _postCodeController = new TextEditingController();

  final _debouncer = Debouncer(milliseconds: 1000);

  Color labelGreen = Color.fromRGBO(51, 194, 174, 1);

  String pumpId;
  String usageId;
  String requestId;
  String natureId;

  var selectedPump;
  var contactDetail;
  List requestType = [];
  List natureRequest = [];
  List usageType = [];

  bool nameValidate = false;
  bool emailValidate = false;
  bool phoneValidate = false;
  bool addressValidate = false;
  bool addressValidate2 = false;
  bool cityValidate = false;
  bool countryValidate = false;
  bool postcodeValidate = false;
  bool checkedTnC = false;
  bool showCursor = false;

  FocusNode nameFocusNode;
  FocusNode emailFocusNode;
  FocusNode phoneFocusNode;
  FocusNode addressFocusNode;

  postData() async {
    Map<String, dynamic> map = {};
    map['pump_id'] = pumpId;
    map['usage_type'] = usageId;
    map['request_type'] = requestId;
    map['nature_request'] = natureId;
    map['remark'] = _remarkController.text;
    map['user_contact_detail'] = (contactDetail!=null)?contactDetail['id'].toString():'';
    map['email'] = _emailController.text;
    map['full_name'] = _customerController.text;
    map['address_line1'] = _addressline1Controller.text;
    map['address_line2'] = _addressline2Controller.text;
    map['city'] = _cityController.text;
    map['poscode'] = _postCodeController.text;
    map['state'] = _countryController.text;

    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var contentData = await Request().postRequest(Config().url+"api/pump/request_service", map, token, context);
    // print(bodyData);
    print(contentData);
    // if (contentData['status'] == true) {
    // }

    Navigator.pop(context, true);

    Fluttertoast.showToast(
      msg: 'Request created',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color(0xFFDCDCDC),
      textColor: Colors.black,
    );

  }

  getServieOption() async {
    var contentData = await Request().getRequest(Config().url+"api/pump/get_service_option", context);

    if (contentData['status'] == true) {
      if (mounted) {
        setState(() {
          requestType= contentData['data']['REQUEST_TYPE'];
          natureRequest= contentData['data']['NATURE_OF_REQUEST'];
          usageType= contentData['data']['USAGE_TYPE'];
        });

        print(usageType[1]['name']);
      }
    }
  }

  getUserContact() async {
    var contentData = await Request().getRequest(Config().url+"api/user/user_contact", context);
    print(contentData);
    if (contentData['status'] == true) {
      contactDetail = contentData['user_contact_detail'];
      if (mounted) {
        setState(() {
          if (contactDetail!=null) {
            _customerController.text = contactDetail['full_name'];
            _emailController.text = contactDetail['email'];
            _phoneController.text = contactDetail['mobile_no'];
            _addressline1Controller.text = contactDetail['address_line1'];
            _addressline2Controller.text = contactDetail['address_line2'];
            _cityController.text = contactDetail['city'];
            _countryController.text = contactDetail['state'];
            _postCodeController.text = contactDetail['poscode'];
                    
            nameValidate = true;
            emailValidate = true;
            phoneValidate = true;
            addressValidate = true;
            cityValidate = true;
            countryValidate = true;
            postcodeValidate = true;
          }

          showCursor =true;
        });
      }
    }
  }

  _removeOverlay(){
    _usageTState.currentState.closeMenu();
    _requestTState.currentState.closeMenu();
    _natureRState.currentState.closeMenu();
  }

  @override
  void initState() {
    super.initState();
    getServieOption();
    getUserContact();

    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    addressFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    addressFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0,), 
        preferredSize: Size.fromHeight(0)),
      body: NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (scrollNotification){
          if (scrollNotification is ScrollStartNotification) {
            _removeOverlay();
          }else if (scrollNotification is ScrollUpdateNotification) {
            _removeOverlay();
          } else if (scrollNotification is ScrollEndNotification) {
            _removeOverlay();
          }
        },
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: (){
              _removeOverlay();

            },
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,), 
                    onPressed: ()=>Navigator.pop(context, true)
                  ),
                  SizedBox(height:0),
                  Center(
                    child: Text("Service Request", style: Theme.of(context).textTheme.headline1)
                  ),
                  SizedBox(height:50),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height:40),
                        Stack(
                          overflow: Overflow.visible,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _removeOverlay();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>MyPump(false)
                                  )
                                ).then((value){
                                  if(value!=null){
                                    setState(() {
                                      selectedPump = value;
                                      pumpId=selectedPump['id'].toString();
                                    });
                                  }
                                });

                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(width: 1, color: Colors.grey)
                                ),
                                margin: EdgeInsets.all(0),
                                color: (pumpId!=null)?labelGreen:Colors.grey[200],
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left:5),
                                        decoration: new BoxDecoration(
                                          color: Theme.of(context).indicatorColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(child: Icon(Icons.add, color: Colors.white, size: 25)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                                        child: Text(selectedPump!=null?MyLocalizations.of(context).getData('productInfo')+" - "+selectedPump['pump_model']['pump_model']:MyLocalizations.of(context).getData('productInfo'), style: Theme.of(context).textTheme.bodyText1,)
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right:-10,
                              top: 10,
                              child: Visibility(
                                visible: pumpId!=null?true:false,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.white,
                                  ),
                                  child:Icon(
                                    Icons.check,
                                    size: 25.0,
                                    color: labelGreen,
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:10),
                        Container(
                          child: SimpleMenu(
                            name:usageId!=null?MyLocalizations.of(context).getData('usageType')+" - "+usageId:MyLocalizations.of(context).getData('usageType'),
                            key: _usageTState,
                            selected: usageId!=null?true:false,
                            backgroundColor: usageId!=null?labelGreen:Colors.grey[100],
                            lists: usageType,
                            iconColor: Colors.white,
                            onChange: (index) {
                              setState(() {
                                usageId = usageType[index]['name'];
                              });
                            },
                            onTapped: (isOpen){
                              if(isOpen){
                                _requestTState.currentState.closeMenu();
                                _natureRState.currentState.closeMenu();
                              }
                            },
                          )
                        ),
                        SizedBox(height:10),
                        Container(
                          child: SimpleMenu(
                            name:requestId!=null?MyLocalizations.of(context).getData('requestType')+" - "+requestId:MyLocalizations.of(context).getData('requestType'),
                            key: _requestTState,
                            lists: requestType,
                            iconColor: Colors.white,
                            selected: requestId!=null?true:false,
                            backgroundColor: requestId!=null?labelGreen:Colors.grey[100],
                            onChange: (index) {
                              setState(() {
                                requestId = requestType[index]['name'];
                              });
                            },
                            onTapped: (isOpen){
                              if(isOpen){
                                _usageTState.currentState.closeMenu();
                                _natureRState.currentState.closeMenu();
                              }
                            },
                          )
                        ),
                        SizedBox(height:10),
                        Container(
                          child: SimpleMenu(
                            name:natureId!=null?MyLocalizations.of(context).getData('naturalRequest')+" - "+natureId:MyLocalizations.of(context).getData('naturalRequest'),
                            key: _natureRState,
                            lists: natureRequest,
                            iconColor: Colors.white,
                            selected: natureId!=null?true:false,
                            backgroundColor: natureId!=null?labelGreen:Colors.grey[100],
                            onChange: (index) {
                              setState(() {
                                natureId = natureRequest[index]['name'];
                              });
                            },
                            onTapped: (isOpen){
                              if(isOpen){
                                _usageTState.currentState.closeMenu();
                                _requestTState.currentState.closeMenu();
                              }
                            },
                          )
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0, bottom: 4.0),
                          child: Text(
                            MyLocalizations.of(context).getData('addIn'),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(width: 1, color: Colors.grey)
                          ),
                          margin: EdgeInsets.all(0),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: _remarkController,
                              maxLines: 6,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(MyLocalizations.of(context).getData('fillIn'), style: Theme.of(context).textTheme.headline2)
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _buttonDetails(Icons.person_outline, nameValidate, nameFocusNode),
                            _buttonDetails(Icons.mail_outline, emailValidate, emailFocusNode),
                            _buttonDetails(Icons.local_phone_rounded, phoneValidate, phoneFocusNode),
                            _buttonDetails(Icons.home, addressValidate, addressFocusNode),

                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: showCursor?true:false,
                          child: Form(
                            key: _key,
                            child:Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top:30),
                                    child: Text(MyLocalizations.of(context).getData('fullname'), style: Theme.of(context).textTheme.caption,),
                                  ),
                                  _inputCustomerName(),
                                  Container(
                                    margin: EdgeInsets.only(top:30),
                                    child: Text(MyLocalizations.of(context).getData('email'), style: Theme.of(context).textTheme.caption,),
                                  ),
                                  _inputEmail(),
                                  Container(
                                    margin: EdgeInsets.only(top:30),
                                    child: Text(MyLocalizations.of(context).getData('phone'), style: Theme.of(context).textTheme.caption,),
                                  ),
                                  _inputPhone(),
                                  Container(
                                    margin: EdgeInsets.only(top:30, bottom: 0),
                                    child: Text(MyLocalizations.of(context).getData('street_address1'), style: Theme.of(context).textTheme.caption,),
                                  ),
                                  _inputAddressline1(),
                                  _inputAddressline2(),
                                  Container(
                                    margin: EdgeInsets.only(top:30),
                                    child: Text(MyLocalizations.of(context).getData('city'), style: Theme.of(context).textTheme.caption,),
                                  ),
                                  _inputCity(),
                                  Container(
                                    margin: EdgeInsets.only(top:30),
                                    child: Text(MyLocalizations.of(context).getData('state'), style: Theme.of(context).textTheme.caption,),
                                  ),
                                  _inputCountry(),
                                  Container(
                                    margin: EdgeInsets.only(top:30),
                                    child: Text(MyLocalizations.of(context).getData('postcode'), style: Theme.of(context).textTheme.caption,),
                                  ),
                                  _inputPostcode(),
                                ]
                              )
                            )
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          MyLocalizations.of(context).getData('tnc'),
                          style: TextStyle(color: Colors.grey[400], fontSize: 10),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    checkedTnC = !checkedTnC;
                                  });
                                },
                                child: Card(
                                  shape: CircleBorder(),
                                  color: checkedTnC?Color.fromRGBO(51, 194, 174, 1):Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: checkedTnC
                                    ? Icon(
                                        Icons.check,
                                        size: 20.0,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.check_box_outline_blank,
                                        size: 20.0,
                                        color: Colors.white,
                                      ),
                                  ),
                                ),
                              )
                            ),
                            SizedBox(width:15),
                            RichText(
                              text: TextSpan(
                                text: 'I accept the ',
                                style: Theme.of(context).textTheme.headline3,
                                children: <TextSpan>[
                                  TextSpan(text: 'Terms and Conditions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue)),
                                  
                                ],
                              ),
                            ),
                          ],
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.blueAccent[800],
                          onPressed: isAllSelected()?(){_checkValidate();}:null, 
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'Create Request', 
                              textAlign: TextAlign.center,
                              style: TextStyle(color:checkedTnC?Colors.white:Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  isAllSelected(){
    if(pumpId!=null && usageId!=null && requestId!=null && natureId!=null && checkedTnC){
      return true;

    }else{
      return false;
    }
  }

  _checkValidate(){
    if (_key.currentState.validate()) {
      postData();
    }
  }

  _inputCustomerName() {
    return new TextFormField(
      controller: _customerController,
      validator: validateCustomername,
      focusNode: nameFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(     
        isDense: true, 
        suffixIconConstraints:BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: nameValidate?Icon(Icons.check, color: Color.fromRGBO(51, 194, 174, 1), size: 24,):null,
        contentPadding: EdgeInsets.symmetric(vertical:10), 
        enabledBorder: UnderlineInputBorder(),  
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      onChanged: (str){
        _debouncer.run(() {
            if(validateCustomername(str)==null){
              setState(() =>nameValidate =true);
            }else{
              setState(() =>nameValidate =false);
            }
          }
        );
      },
      onSaved: (str) {
        print(str);

      },
    );
  }

  _inputEmail() {
    return new TextFormField(
      controller: _emailController,
      validator: validateEmail,
      focusNode: emailFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(     
        isDense: true, 
        suffixIconConstraints:BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: emailValidate?Icon(Icons.check, color: Color.fromRGBO(51, 194, 174, 1), size: 24,):null,
        contentPadding: EdgeInsets.symmetric(vertical:10), 
        enabledBorder: UnderlineInputBorder(),  
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      onChanged: (str){
        _debouncer.run(() {
            if(validateEmail(str)==null){
              setState(() =>emailValidate =true);
            }else{
              setState(() =>emailValidate =false);
            }
          }
        );
      },
      onSaved: (str) {

      },
    );
  }

  _inputPhone() {
    return new TextFormField(
      controller: _phoneController,
      validator: validatePhone,
      focusNode: phoneFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(     
        isDense: true, 
        suffixIconConstraints:BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: phoneValidate?Icon(Icons.check, color: Color.fromRGBO(51, 194, 174, 1), size: 24,):null,
        contentPadding: EdgeInsets.symmetric(vertical:10), 
        enabledBorder: UnderlineInputBorder(),  
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (str){
        _debouncer.run(() {
            if(validatePhone(str)==null){
              setState(() =>phoneValidate =true);
            }else{
              setState(() =>phoneValidate =false);
            }
          }
        );
      },
      onSaved: (str) {

      },
    );
  }

  _inputAddressline1() {
    return new TextFormField(
      controller: _addressline1Controller,
      // validator: validateEmail,
      focusNode: addressFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(     
        isDense: true, 
        suffixIconConstraints:BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: addressValidate?Icon(Icons.check, color: Color.fromRGBO(51, 194, 174, 1), size: 24,):null,
        contentPadding: EdgeInsets.symmetric(vertical:10),    
        enabledBorder: UnderlineInputBorder(),  
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      onChanged: (str){
        _debouncer.run(() {
            if(str!=null){
              setState(() =>addressValidate =true);
            }else{
              setState(() =>addressValidate =false);
            }
          }
        );
      },
      onSaved: (str) {

      },
    );
  }

  _inputAddressline2() {
    return new TextFormField(
      controller: _addressline2Controller,
      // validator: validateEmail,
      // focusNode: addressFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(     
        isDense: true, 
        suffixIconConstraints:BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: addressValidate2?Icon(Icons.check, color: Color.fromRGBO(51, 194, 174, 1), size: 24,):null,
        contentPadding: EdgeInsets.symmetric(vertical:10),    
        enabledBorder: UnderlineInputBorder(),  
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      onChanged: (str){
        _debouncer.run(() {
            if(str!=null){
              setState(() =>addressValidate2 =true);
            }else{
              setState(() =>addressValidate2 =false);
            }
          }
        );
      },
      onSaved: (str) {

      },
    );
  }

  _inputCity() {
    return new TextFormField(
      controller: _cityController,
      // validator: validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(     
        isDense: true, 
        suffixIconConstraints:BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: cityValidate?Icon(Icons.check, color: Color.fromRGBO(51, 194, 174, 1), size: 24,):null,
        contentPadding: EdgeInsets.symmetric(vertical:10),   
        enabledBorder: UnderlineInputBorder(),  
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
      // keyboardType: TextInputType.number,
      onChanged: (str){
        _debouncer.run(() {
            if(str!=null){
              setState(() =>cityValidate =true);
            }else{
              setState(() =>cityValidate =false);
            }
          }
        );
      },
      onSaved: (str) {

      },
    );
  }

  _inputCountry() {
    return new TextFormField(
      controller: _countryController,
      // validator: validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(     
        isDense: true, 
        suffixIconConstraints:BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: countryValidate?Icon(Icons.check, color: Color.fromRGBO(51, 194, 174, 1), size: 24,):null,
        contentPadding: EdgeInsets.symmetric(vertical:10),  
        enabledBorder: UnderlineInputBorder(),  
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
      // keyboardType: TextInputType.number,
      onChanged: (str){
        _debouncer.run(() {
            if(str!=null){
              setState(() =>countryValidate =true);
            }else{
              setState(() =>countryValidate =false);
            }
          }
        );
      },
      onSaved: (str) {

      },
    );
  }

  _inputPostcode() {
    return new TextFormField(
      controller: _postCodeController,
      // validator: validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(     
        isDense: true, 
        suffixIconConstraints:BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: postcodeValidate?Icon(Icons.check, color: Color.fromRGBO(51, 194, 174, 1), size: 24,):null,
        contentPadding: EdgeInsets.symmetric(vertical:10),   
        enabledBorder: UnderlineInputBorder(),  
        focusedBorder: UnderlineInputBorder(),
        border: UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (str){
        _debouncer.run(() {
            if(str!=null){
              setState(() =>postcodeValidate =true);
            }else{
              setState(() =>postcodeValidate =false);
            }
          }
        );
      },
      onSaved: (str) {

      },
    );
  }

  String validateCustomername(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Username is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Username must be a-z and A-Z';
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern = r"(^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$)";
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String validatePhone(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    } 
    // else if (value.length != 10) {
    //   return 'Invalid phone number';
    // }
    return null;
  }
  

  _buttonDetails(iconData, validated, focusNode){
    return GestureDetector(
      onTap: (){
        focusNode.requestFocus();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: new BoxDecoration(
          color: validated?Color.fromRGBO(51, 194, 174, 1):Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color:Colors.grey,
            width: 3
          )
        ),
        child: new Icon(
          iconData,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}