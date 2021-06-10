import 'package:flutter/material.dart';

class CustomerDetails extends StatefulWidget {
  final details;

  CustomerDetails(this.details);
  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0,), 
        preferredSize: Size.fromHeight(0)
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,), 
                  onPressed: ()=>Navigator.pop(context)
                ),
                Container(
                  margin: EdgeInsets.only(right:15),
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: (){},
                    child: Text('Edit', style: TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ),
            SizedBox(height:10),
            Center(
              child: Text("Customer Contact Details", style: Theme.of(context).textTheme.headline1)
            ),
            SizedBox(height:80),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text("Customer Contact Details", style: Theme.of(context).textTheme.headline2)
                    ),
                    SizedBox(height:80),
                    structRow(Icons.person_outline, widget.details['name']),
                    SizedBox(height:60),
                    structRow(Icons.email_outlined, widget.details['email']),
                    SizedBox(height:60),
                    structRow(Icons.phone_outlined, widget.details['phone']),
                    SizedBox(height:60),
                    structRow(Icons.home_outlined, widget.details['name']),
                    SizedBox(height:60),
                  ],
                ),
              ),
            )
          ]
        )
      )
    );
  }
  structRow(icon, content){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Icon(icon)
          )
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: Text(content.toString(), 
            style: Theme.of(context).textTheme.headline6,),
          )
        )
      ], 
    );
  }
}