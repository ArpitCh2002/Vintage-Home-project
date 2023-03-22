import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vintage_home/api_consumer.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:vintage_home/home_screen.dart';

class ItemsUploadScreen extends StatefulWidget {

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  Uint8List? imageFileUint8List;
  bool isUploading = false;

  String downloadUrlOfUploadedImage = "";

  TextEditingController sellerNameTextEditingController = TextEditingController();
  TextEditingController sellerPhoneTextEditingController = TextEditingController();
  TextEditingController itemNameTextEditingController = TextEditingController();
  TextEditingController itemDescriptionTextEditingController = TextEditingController();
  TextEditingController itemPriceTextEditingController = TextEditingController();
  
  Widget uploadFormScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'UPLOAD NEW ITEMS',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(onPressed: () {
              if(isUploading != true) {
                validateUploadFormAndUploadItemInfo();
              }
            },
                icon: Icon(Icons.cloud_upload, color: Colors.white,)),
          )
        ],
      ),

      body: ListView(
        children: [
          isUploading == true ? const LinearProgressIndicator(color: Colors.purpleAccent,) : Container(),

          SizedBox(
            height: 250.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: imageFileUint8List != null ?
              Image.memory(
                  imageFileUint8List!) :
                  Icon(
                      Icons.image_not_supported, color: Colors.grey,
                  size: 40.0,)
              
            ),
          ),

          const Divider(
            color: Colors.white70,
            thickness: 2.0,
          ),

          ListTile(
            leading: Icon(
              Icons.person_pin_rounded,
              color: Colors.purple,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.grey),
                controller: sellerNameTextEditingController,
                decoration: InputDecoration(
                  hintText: "Seller Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.white70,
            thickness: 2.0,
          ),
          
          ListTile(
            leading: Icon(
              Icons.phone_iphone_rounded,
              color: Colors.purple,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.grey),
                controller: sellerPhoneTextEditingController,
                decoration: InputDecoration(
                  hintText: "Seller Phone",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.white70,
            thickness: 2.0,
          ),

          ListTile(
            leading: Icon(
              Icons.title,
              color: Colors.purple,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.grey),
                controller: itemNameTextEditingController,
                decoration: InputDecoration(
                  hintText: "Item Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.white70,
            thickness: 2.0,
          ),

          ListTile(
            leading: Icon(
              Icons.description,
              color: Colors.purple,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.grey),
                controller: itemDescriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Item Description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.white70,
            thickness: 2.0,
          ),

        ],
      ),
    );
  }

  validateUploadFormAndUploadItemInfo() async {
    if(imageFileUint8List != null) {
      if(sellerNameTextEditingController.text.isNotEmpty &&
      sellerPhoneTextEditingController.text.isNotEmpty &&
      itemNameTextEditingController.text.isNotEmpty &&
      itemDescriptionTextEditingController.text.isNotEmpty) {
        setState(() {
          isUploading = true;
        });

        String imageUniqueName = DateTime.now().microsecondsSinceEpoch.toString();
        fStorage.Reference firebaseStorageRef = fStorage.FirebaseStorage.instance.ref().child("Items Images").child(imageUniqueName);

        fStorage.UploadTask uploadTaskImageFile = firebaseStorageRef.putData(imageFileUint8List!);
        fStorage.TaskSnapshot taskSnapshot = await uploadTaskImageFile.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((imageDownloadUrl)
        {
          downloadUrlOfUploadedImage = imageDownloadUrl;
        });

        saveItemInfoToFirestore();
      }
      else {
        Fluttertoast.showToast(msg: "Please Complete Upload Form ");
      }
    }
    else {
      Fluttertoast.showToast(msg: "Please Select an Image File ");
    }
  }

  saveItemInfoToFirestore() {
    String itemUniqueId = DateTime.now().microsecondsSinceEpoch.toString();

    FirebaseFirestore.instance.collection("items").doc(itemUniqueId).set({
      "itemID" : itemUniqueId,
      "itemName" : itemNameTextEditingController.text,
      "itemDescription" : itemDescriptionTextEditingController.text,
      "itemImage" : downloadUrlOfUploadedImage,
      "sellerName" : sellerNameTextEditingController.text,
      "sellerPhone" : sellerPhoneTextEditingController.text,
      "publishedDate" : DateTime.now(),
      "status" : "available",
    });

    Fluttertoast.showToast(msg: "Item Uploaded Successfully");

    setState(() {
      isUploading = false;
      imageFileUint8List = null;
    });

    Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
  }

  //default Screen

  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload New Item",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              color: Colors.grey,
              size: 200.0,
            ),

            ElevatedButton(onPressed: () {
              showDialogBox();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
            ),
            child: Text(
              "Add New Item",
              style: TextStyle(
                color: Colors.white70,
              ),
            ),)
          ],
        ),
      ),
    );
  }

  showDialogBox() {
    return showDialog(
      context: context,
      builder: (c) {
        return SimpleDialog(
          backgroundColor: Colors.black,
            title: Center(
              child: Text(
                "Item Image",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                captureImageWithPhoneCamera();
              },
              child: Center(
                child: Text(
                  "Capture Image from Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            SimpleDialogOption(
              onPressed: () {
                chooseImageFromPhoneGallery();
              },
              child: Center(
                child: Text(
                  "Select Image from Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  captureImageWithPhoneCamera() async {
    Navigator.pop(context);
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

      if(pickedImage != null) {
        String imagePath = pickedImage.path;
        imageFileUint8List = await pickedImage.readAsBytes();

        imageFileUint8List = await ApiConsumer().removeImageBackgroundApi(imagePath);

        setState(() {
          imageFileUint8List;
        });
      }
    }
    catch (errorMsg) {
      print(errorMsg.toString());

      setState(() {
        imageFileUint8List = null;
      });
    }
  }

  chooseImageFromPhoneGallery() async {
    Navigator.pop(context);
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(pickedImage != null) {
        String imagePath = pickedImage.path;
        imageFileUint8List = await pickedImage.readAsBytes();

        imageFileUint8List = await ApiConsumer().removeImageBackgroundApi(imagePath);


        setState(() {
          imageFileUint8List;
        });
      }
    }
    catch (errorMsg) {
      print(errorMsg.toString());

      setState(() {
        imageFileUint8List = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageFileUint8List == null ? defaultScreen() : uploadFormScreen();
  }
}
