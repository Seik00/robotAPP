import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderScroll extends StatefulWidget {
  @override
  _LoaderScrollState createState() => _LoaderScrollState();
}

class _LoaderScrollState extends State<LoaderScroll> {

  final spinkit = SpinKitFadingCircle(
    color: Color.fromRGBO(12, 59, 113, 1),
    size: 50,
  );

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        color: Colors.grey,
        child:Column(
          children: [
            SizedBox(height:MediaQuery.of(context).size.height/4),
            spinkit,
            SizedBox(height:MediaQuery.of(context).size.height/2),
          ],
        )      
      ),
    );
  }
}