import 'package:flutter/material.dart';
import 'package:vintage_home/items.dart';
import 'package:vintage_home/virtual_ar_view_screen.dart';

class ItemDetailsScreen extends StatefulWidget {

  Items? clickedItemInfo;

  ItemDetailsScreen({this.clickedItemInfo,});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          widget.clickedItemInfo!.itemName.toString(),
        ),
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => VirtualARViewScreen(
            clickedItemImageLink : widget.clickedItemInfo!.itemImage.toString(),
          )));
        },
        label: Text(
          "Try Virtually",
        ),

        icon: Icon(
          Icons.mobile_screen_share_rounded,
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.clickedItemInfo!.itemImage.toString(),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 30.0),

                child: Text(
                  widget.clickedItemInfo!.itemName.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),

              Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),

                child: Text(
                  widget.clickedItemInfo!.itemDescription.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                    color: Colors.purple,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

