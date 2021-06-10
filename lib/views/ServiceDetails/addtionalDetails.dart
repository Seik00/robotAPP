import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';

class AdditionalDetails extends StatefulWidget {
  final details;

  AdditionalDetails(this.details);
  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  final TextEditingController _requestIDController =
      new TextEditingController();
  final TextEditingController _usageTypeController =
      new TextEditingController();
  final TextEditingController _requestTypeController =
      new TextEditingController();
  final TextEditingController _statusController = new TextEditingController();
  final TextEditingController _assignToController = new TextEditingController();
  var details;

  // @override
  // void initState() {
  //   super.initState();
  //   _requestIDController.text = widget.details['ref_code'];
  //   _usageTypeController.text = widget.details['usage_type'];
  //   _requestTypeController.text = widget.details['request_type'];
  //   _statusController.text = widget.details['status_remark'];
  //   _assignToController.text = widget.details.pump_info['id'];
  //   print(_assignToController);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
            ),
            preferredSize: Size.fromHeight(0)),
        body: SingleChildScrollView(
            child: Container(
                // height: MediaQuery.of(context).size.height,
                color: Theme.of(context).backgroundColor,
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                      child: Text("Additional Details",
                          style: Theme.of(context).textTheme.headline1)),
                  SizedBox(height: 80),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text("Service Request Details",
                                style: Theme.of(context).textTheme.headline2)),
                        SizedBox(height: 35),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Product Code',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        _readTextFormField(
                            _requestIDController, 'fsedcsdcdcd'),
                        SizedBox(height: 25),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Reason',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
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
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            )),
                            SizedBox(height: 25),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Remark',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
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
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            )),

                      ],
                    ),
                  )
                ]))));
  }
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
        hintText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    ),
  );
}
