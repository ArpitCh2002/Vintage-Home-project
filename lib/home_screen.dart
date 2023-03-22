import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vintage_home/items.dart';
import 'package:vintage_home/items_upload_screen.dart';
import 'package:vintage_home/items_ui_design_widget.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vintage Home', style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20.0, letterSpacing: 2,
        ),),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsUploadScreen()));
              },
              icon: Icon(
                Icons.add, color: Colors.white,
              ))
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("items").orderBy("publishedDate", descending: true).snapshots(),
        builder: (context, AsyncSnapshot dataSnapshot) {
          if(dataSnapshot.hasData) {
            return ListView.builder(
              itemCount: dataSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Items eachItemInfo = Items.fromJson(
                  dataSnapshot.data!.docs[index].data() as Map<String, dynamic>
                );

                return ItemUIDesignWidget(
                  itemsInfo: eachItemInfo, context: context,
                );
              },
            );
          }
          else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Data Unavailable!",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          }

        },
      ),
    );
  }
}
