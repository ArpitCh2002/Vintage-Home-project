import 'package:flutter/material.dart';
import 'package:vintage_home/item_details_screen.dart';
import 'package:vintage_home/items.dart';
import 'package:vintage_home/items_upload_screen.dart';

class ItemUIDesignWidget extends StatefulWidget {

  Items? itemsInfo;
  BuildContext? context;

  ItemUIDesignWidget({
    this.itemsInfo,
    this.context,
});

  @override
  State<ItemUIDesignWidget> createState() => _ItemUIDesignWidgetState();
}

class _ItemUIDesignWidgetState extends State<ItemUIDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailsScreen(
          clickedItemInfo: widget.itemsInfo,
        )));
      },
      splashColor: Colors.purple,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: SizedBox(
          height: 100.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(
                widget.itemsInfo!.itemImage.toString(),
                width: 150.0,
                height: 150.0,
              ),

              SizedBox(
                width: 10.0,
              ),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                          child: Text(
                            widget.itemsInfo!.itemName.toString(),
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 20.0,
                            ),
                          )),

                      SizedBox(
                        height: 1.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Expanded(
                          child: Text(
                            widget.itemsInfo!.itemDescription.toString(),
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 12.0,
                            ),
                          )),

                      SizedBox(
                        height: 7.0,
                      ),

                      Divider(
                        height: 2.0,
                        color: Colors.purple,
                        thickness: 1.5,
                      ),
                    ],
                  ),),
            ],
          ),
        ),
      ),
    );
  }
}
