import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/views/pump/models.dart';
import 'package:robot/views/pump/productMenu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

class CreatePump extends StatefulWidget {
  final pumpDetails;

  CreatePump(this.pumpDetails);
  @override
  _CreatePumpState createState() => _CreatePumpState();
}

class _CreatePumpState extends State<CreatePump> {

  final TextEditingController _idController = new TextEditingController();
  final TextEditingController _purchasedController = new TextEditingController();
  final TextEditingController _invoiceController = new TextEditingController();
  final picker = ImagePicker();

  List products = ['Part No', 'Serial No', 'Warranty No'];
  File _image;
  DateTime selectedDate= DateTime.now();
  String base64Image = '';
  String imageId = '';
  String model = '';
  String modelId = '';

  var selectProduct = 'Part No';  

  upload(file) async {
    Map<String, String> headers = {};
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if(token!=null){
      headers = {'Authorization': 'Bearer' + token};

    }

    var uri = Uri.parse(Config().url+"/api/user/upload_file");
    var request = new http.MultipartRequest("POST", uri);
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var multipartFile = new http.MultipartFile('photo[]', stream, length,
    filename: path.basename(file.path));
    //contentType: new MediaType('image', 'png'));

    request.headers.addAll(headers);
    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      var contentData = json.decode(value);
      print(contentData);
      setState(() {
        imageId = contentData['data'].toString();
      });
      Map<String, dynamic> map = {};
      if(widget.pumpDetails!=null)map['pump_id'] = widget.pumpDetails['id'].toString();
      map['pump_model_id'] = modelId;
      map['image'] = imageId;
      map['id_no'] = _idController.text;
      map['distributor'] = 'Lee Pump';
      map['purchase_date'] = DateFormat.yMd().format(selectedDate);
      map['invoice_no'] = _invoiceController.text;
      postData(map);
    });
  }

  Future _imgFromGallery() async {
    print(true);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

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
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  createPump() async {
    var contentData = await Request().getRequest(Config().url+"api/pump/CreatePump", context);
    print(contentData);

    if (contentData['status'] == true) {
      if (mounted) {
        setState(() {
          products = contentData['data'];
        });
      }
    }
  }

  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/pump/addmyPump", bodyData, token, context);
    
    print(contentData);
    Navigator.pop(context, true);
    Fluttertoast.showToast(
      msg: widget.pumpDetails!=null?'Pump updated' :'Pump created',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color(0xFFDCDCDC),
      textColor: Colors.black,
    );
    // if (contentData['status'] == true) {
    // }
  }

  @override
  void initState() {
    super.initState();

    if(widget.pumpDetails!=null){
       setState(() {
        model = widget.pumpDetails['pump_model']['pump_model'];
        _idController.text = widget.pumpDetails['id_no'];
        _invoiceController.text = widget.pumpDetails['invoice_no'];
        selectedDate = DateTime.parse(widget.pumpDetails['created_at']);
       });

    }

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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/img/background.png'),
              fit: BoxFit.cover
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,), 
                    onPressed: ()=>Navigator.pop(context)
                  ),
                  GestureDetector(
                    onTap: ()=>Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Text('Cancel', style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),),
                    ),
                  ),
                ],
              ),
              SizedBox(height:0),
              Center(
                child: Text("Create Pump", style: Theme.of(context).textTheme.headline1)
              ),
              SizedBox(height:50),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: (model!='')?Text(
                                      model, 
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1
                                    ):Text(
                                      'Model', 
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
                                  child: Center(child: Icon(Icons.search, color: Colors.white, size: 16)),
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
                            builder: (context) =>Models()
                          )
                        ).then((value){
                          if (value!=null) {
                            setState(() {
                              model= value['pump_model'];
                              modelId= value['id'].toString();
                              print(model);
                            });
                          }
                        });
                      }
                    ),
                    SizedBox(height:15),
                    Container(
                      child: ProductMenu(
                        name:selectProduct+":",
                        lists: products,
                        iconColor: Colors.white,
                        backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(width: 1, color: Colors.white),
                        onChange: (index) {
                          setState(() {
                            selectProduct = products[index];
                          });
                        },
                      )
                    ),
                    SizedBox(height:15),
                    _inputTextFormField(_idController, 'Identification no'),
                    SizedBox(height:15),
                    _readTextFormField(_purchasedController, 'Purchased from distributor'),
                    SizedBox(height:15),
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
                                    child: Text(
                                      'Purchase Date: '+ DateFormat.yMd().format(selectedDate), 
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1
                                    )
                                  ),
                                ),
                                
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: new BoxDecoration(
                                    color: Theme.of(context).indicatorColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Icon(Icons.calendar_today, color: Colors.black, size: 16)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000), // Required
                          lastDate: DateTime(2025),  // Required
                        );

                        if (picked != null && picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                        });
                      },
                    ),
                    SizedBox(height:15),
                    _inputTextFormField(_invoiceController, 'Invoice no'),
                    SizedBox(height:15),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.all(0),
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
                          height: 100,
                          child: (_image!=null)?Center():Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt),
                                SizedBox(width:10),
                                Text('Upload Image', style: TextStyle(color: Theme.of(context).buttonColor),)
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                    SizedBox(height:15),
                    Padding(
                      padding: const EdgeInsets.only(left:0.0, bottom: 4.0),
                      child: Text(
                        'Additional Comments',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          // controller: _remarkController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ),
                    SizedBox(height:20),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.blueAccent[800],
                      onPressed: ()async{
                        if(_image!=null){
                          upload(_image);
                          print(imageId);
                        }else{
                          Map<String, dynamic> map = {};
                          if(widget.pumpDetails!=null)map['pump_id'] = widget.pumpDetails['id'].toString();
                          map['model'] = modelId;
                          map['image'] = imageId;
                          map['id_no'] = _idController.text;
                          map['distributor'] = 'Lee Pump';
                          map['purchase_date'] = DateFormat.yMd().format(selectedDate);
                          map['invoice_no'] = _invoiceController.text;
                          postData(map);
                        }
                        
                        
                      }, 
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          'Done', 
                          textAlign: TextAlign.center,
                          style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  _inputTextFormField(_controller, label) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(0),
      child: TextFormField(
        controller: _controller,
        obscureText: false,
        autofocus: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[300]),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );
  }

  _readTextFormField(_controller, label) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(0),
      child: TextFormField(
        controller: _controller,
        obscureText: false,
        autofocus: false,
        readOnly: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label+': Lee Pump',
          hintStyle: Theme.of(context).textTheme.bodyText1,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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