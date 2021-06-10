import 'package:flutter/material.dart';

class ProductInfo extends StatefulWidget {
  final info;

  ProductInfo(this.info);
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0,), 
        preferredSize: Size.fromHeight(0)
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5, 0.9],
            colors: [
              Color.fromRGBO(78, 192, 208, 1), 
              Color.fromRGBO(89, 119, 175, 1),
              Color.fromRGBO(94, 61, 152, 1),
            ]
          )
        ),
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
              ],
            ),
            SizedBox(height:20),
            Text("Product Info", style: Theme.of(context).textTheme.headline1),
            SizedBox(height:40),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(75),
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(widget.info['uploaded_file'][0]['public_image_path']),
                  fit: BoxFit.fill
                )
              ),
            ),
            SizedBox(height:20),
            Text(widget.info['pump_model']['pump_model'], style: Theme.of(context).textTheme.headline4),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                ),
                child: Column(
                  children: [
                    structRow("Product Code", widget.info['pump_model']['product_code']),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:10),
                      child: Divider(
                        height: 1,
                      ),
                    ),
                    structRow("Warranty", "Yes"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:10),
                      child: Divider(
                        height: 1,
                      ),
                    ),
                    structRow("Case no", "2468"),
                  ],
                ),
              ),
            ),
            SizedBox(height:20),
          ],
        ),
      )
    );
  }

  structRow(label, value){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.headline5,),
          Text(value, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),),
        ],
      ),
    );
  }
}