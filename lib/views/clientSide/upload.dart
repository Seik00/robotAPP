import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/Explore/depositRecord.dart';
import 'package:robot/views/Explore/uploadRecord.dart';
import 'package:robot/views/Part/pageView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../vendor/i18n/localizations.dart' show MyLocalizations;

class Upload extends StatefulWidget {
  final url;
  final onChangeLanguage;

  Upload(this.url, this.onChangeLanguage);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  
  bool visible = true;
  File _image;
  DateTime selectedDate= DateTime.now();
  String base64Image = '';
  String imageId = '';
  final picker = ImagePicker();

  final secpwdController = TextEditingController();
  var _firstPress = true ;
  upload(file) async {
    Map<String, String> headers = {};
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if(token!=null){
      headers = {'Authorization': 'Bearer' + token};

    }

    var uri = Uri.parse(Config().url+"api/upload/upload-file");
    var request = new http.MultipartRequest("POST", uri);
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var multipartFile = new http.MultipartFile('file', stream, length,
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
      map['image'] = imageId;
      map['sec_password'] = secpwdController.text;
      print(map['image']);
      print('----');
      postData(map);
    });
  }

  Future _imgFromGallery() async {
    print(true);
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 5);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  refresh(){
    imageId = "";
    secpwdController.text = "";
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => TopViewing(
              widget.url,
              widget.onChangeLanguage,
            )));
  }
  
  postData(bodyData) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(bodyData);
    var contentData = await Request().postRequest(Config().url+"api/project/submit_share_record", bodyData, token, context);
    
    print(contentData);
    if(contentData != null){
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
              refresh();
            })
          ..show();
    } else {
      
    }
    setState(() {
      _firstPress = true ;
    });
    }
  }

  Future _imgFromCamera() async {
    print(true);
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 5);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
        print('00000000');
      } else {
        print('No image selected.');
      }
    });
    
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
                  SizedBox(height: 30), 
                  Center(
                    child: Container(
                      child: Text(
                        MyLocalizations.of(context).getData('upload'),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.2)
                      ),
                      child: Column(children: [
                        GestureDetector(
                          onTap: (){
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UploadRecord(widget.url,widget.onChangeLanguage)),
                            );
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(MyLocalizations.of(context).getData('history_record'),style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        Center(
                          child: Container(
                          decoration: _image!=null?BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_image),
                              fit: BoxFit.cover
                            )
                          ):BoxDecoration(
                            color: Colors.transparent
                          ),
                          height: MediaQuery.of(context).size.height/4,
                          child: (_image!=null)?Center():Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Icon(Icons.cloud_upload,color: Color(0xff9b9dac),size: 150,)),
                                Text(MyLocalizations.of(context).getData('upload_cert'), style: TextStyle(color: Color(0xff9b9dac),fontSize: 16,fontWeight: FontWeight.bold)
                                )],
                            ),
                          ),
                        ),
                        ),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: ()async{
                              setState(() {
                                _imgFromCamera();
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
                                  margin: EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width/2,
                                  height: MediaQuery.of(context).size.height / 15,
                                  alignment: Alignment.center,
                                  child: Text(
                                    MyLocalizations.of(context).getData('take_photo'),
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                  )),
                            ),
                        ),
                         GestureDetector(
                          onTap: ()async{
                              setState(() {
                                _imgFromGallery();
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
                                  margin: EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width/2,
                                  height: MediaQuery.of(context).size.height / 15,
                                  alignment: Alignment.center,
                                  child: Text(
                                    MyLocalizations.of(context).getData('choose_file'),
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
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
                              }else if(secpwdController.text.isEmpty){
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
                                map['image'] = imageId;
                                map['sec_password'] = secpwdController.text;
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
                                  width: MediaQuery.of(context).size.width/1.6,
                                  height: MediaQuery.of(context).size.height / 15,
                                  alignment: Alignment.center,
                                  child: Text(
                                    MyLocalizations.of(context).getData('submit'),
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                        )
                      ],),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
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
