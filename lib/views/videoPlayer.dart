import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';


class VideoAppPlayer extends StatelessWidget {

  final String url;
  final String path;
  final String title;
  final String videoTag;
  VideoAppPlayer(this.url,this.path,this.title,this.videoTag);
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: const ValueKey<String>('home_page'),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
        body: Stack(
          children: <Widget>[
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/img/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
            BumbleBeeRemoteVideo(url,path,title,videoTag),
          ],
        ),
      ),
    );
  }
}

class BumbleBeeRemoteVideo extends StatefulWidget {
  BumbleBeeRemoteVideo(this.url,this.public_path,this.title,this.videoTag);
  final String url;
  final String public_path;
  final String title;
  final String videoTag;
  
  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<BumbleBeeRemoteVideo> {
  VideoPlayerController _controller;
  String fbProtocolUrl;
  
  download() async {
    if (await canLaunch(widget.public_path)) {
      await launch(widget.public_path);
    } else {
      throw 'Could not launch';
    }
  }

  _launchURL() async {
    var url = 'fb://page/';
    var fallbackUrl = 'https://www.facebook.com/';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
        }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }


  @override
  void initState() {
    print(widget.url);
    print(widget.public_path);
    print(widget.title);
    super.initState();
    _controller = VideoPlayerController.network(
       widget.public_path,
    
      // 'https://www.youtube.com/watch?v=Mx7gjYVHgaU',
    
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(false);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top:10),
            child: Row(
              children: [
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context, true)),
            ],)
          ),
          Container(padding: const EdgeInsets.only(top: 20.0)),
          Text(widget.title,style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height:20),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top:10,bottom:10,left:20,right:20),
                margin: const EdgeInsets.only(left:20,right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                    gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff9957ED), Color(0xff7835E5)])
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(new ClipboardData(text: widget.public_path));
                        Fluttertoast.showToast(
                          msg: MyLocalizations.of(context).getData('copy_link'),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Color(0xFFDCDCDC),
                          textColor: Colors.black,
                        );
                      },
                      child: Icon(Icons.copy,size: 35,color: Colors.white,)),
                     GestureDetector(
                      onTap: () {
                        download();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left:20),
                        child: Icon(Icons.download_sharp,size: 35,color: Colors.white,))),
                    SizedBox(width:20),
                    Expanded(
                      child: 
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.close,size: 35,color: Colors.white,)
                        ),
                      )),
                ],),
              ),
              Container(
                padding: const EdgeInsets.only(left:20,right: 20),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      _PlayPauseOverlay(controller: _controller),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(20),
                child:Text(
                  widget.videoTag,style: TextStyle(color: Colors.grey,fontSize: 16),
                )
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(20),
                child:Text(
                  MyLocalizations.of(context).getData('share'),style: TextStyle(color: Colors.white,fontSize: 20),
                )
              ),
              Container(
                padding: const EdgeInsets.only(left:20,right: 20),
                child: Row(children: [
                  GestureDetector(
                    onTap: () async {
                      _launchURL();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right:10),
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("lib/assets/img/facebook.png")
                        )
                    )),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Clipboard.setData(new ClipboardData(text: widget.public_path));
                  //     Fluttertoast.showToast(
                  //       msg: MyLocalizations.of(context).getData('copy_link_insta'),
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.BOTTOM,
                  //       backgroundColor: Color(0xFFDCDCDC),
                  //       textColor: Colors.black,
                  //     );
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.only(right:10),
                  //     width: 40.0,
                  //     height: 40.0,
                  //     decoration: new BoxDecoration(
                  //       shape: BoxShape.rectangle,
                  //       image: new DecorationImage(
                  //           fit: BoxFit.cover,
                  //           image: AssetImage("lib/assets/img/instagram.png")
                  //       )
                  //   )),
                  // ),
                ],),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
