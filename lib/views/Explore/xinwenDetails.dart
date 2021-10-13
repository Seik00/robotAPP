import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:robot/API/config.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class XinwenDetails extends StatefulWidget {
  final noticId;
  final title;
  final description;
  final url;
  final time;

  XinwenDetails(this.noticId, this.title, this.description, this.url, this.time);
  @override
  _XinwenDetailsState createState() => _XinwenDetailsState();
}

class _XinwenDetailsState extends State<XinwenDetails> {
  String path;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(widget.url);
    final responseJson = response.bodyBytes;
    
    return responseJson;
  }

  void loadPdf() async {
    await writeCounter(await fetchPost());
    await existsFile();
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  var language;
  getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
    if(widget.url == Config().url+'storage'){
      
    }else{
       loadPdf();
    }
   
    print(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xff212630),
      appBar: PreferredSize(
          child: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Theme.of(context).primaryColor,
                    size: 35,
                  ),
                  onPressed: () => Navigator.pop(context, true)),
            ),
            title: Container(
              child: Text(
                MyLocalizations.of(context).getData('user_guide'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(50)),
      body: Stack(
        children: [
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
            child: new Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(widget.time,
                          style:
                              TextStyle(color: Colors.black, fontSize: 13)),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (path != null)
                      Expanded(
                        child: PdfView(
                          path: path,
                        ),
                      )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
