import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:rentool/model/rent_items_model.dart';
import 'package:rentool/screens/home_screen_default.dart';

class AddRent extends StatefulWidget {
  const AddRent({Key? key}) : super(key: key);

  @override
  State<AddRent> createState() => _AddRentState();
}

class _AddRentState extends State<AddRent> {
  final _auth = FirebaseAuth.instance;

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final itemNameEditingController = new TextEditingController();
  final itemDescriptionEditingController = new TextEditingController();
  final itemPriceEditingController = new TextEditingController();
  final itemQuantityEditingController = new TextEditingController();

  // some initialization
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  // image picker gallery
  Future imagePickerMethod(ImageSource sourceType) async {
    try {
      // picking the file
      final pick = await imagePicker.pickImage(source: sourceType);

      setState(() {
        if (pick != null) {
          _image = File(pick.path);
        } else {
          // showing a snackbar error
          showSnackBar("No file selected", Duration(milliseconds: 400));
        }
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  // uploading the image, then getting the download url and then
  // adding that download url to our cloudfirestore

  Future uploadImage(String id) async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${_auth.currentUser!.uid}/images/rental_items")
        .child("post_$postID");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();

    // uploading to cloudfirestore
    await firebaseFirestore
        .collection("rent-items")
        .doc(id)
        .collection("images")
        .add({'downloadURL': downloadURL}).whenComplete(() =>
            showSnackBar("Image uploaded successfully", Duration(seconds: 2)));
  }

  // snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // item name field
    final itemNameField = TextFormField(
        autofocus: false,
        controller: itemNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Item name cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter valid name(Min. 6 Character)");
          }
          return null;
        },
        onSaved: (value) {
          itemNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Name"));

    // item description field
    final itemDescriptionField = TextFormField(
        autofocus: false,
        controller: itemDescriptionEditingController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Item description cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter value(Min. 6 Character)");
          }
          return null;
        },
        onSaved: (value) {
          itemDescriptionEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Description"));

    // item Price field
    final itemPriceField = TextFormField(
        autofocus: false,
        controller: itemPriceEditingController,
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Item price cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter value(Min. 6 Character)");
          }
          return null;
        },
        onSaved: (value) {
          itemPriceEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Price"));

    // item quantity field
    final itemQuantityField = TextFormField(
        autofocus: false,
        controller: itemQuantityEditingController,
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Item quantity cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter value(Min. 6 Character)");
          }
          return null;
        },
        onSaved: (value) {
          itemQuantityEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Quantity"));
    // gellery btn
    final galleryBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            imagePickerMethod(ImageSource.gallery);
          },
          child: Text(
            "Choose from album",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // camera btn
    final cameraBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            imagePickerMethod(ImageSource.camera);
          },
          child: Text(
            "Take a picture",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // Next button
    final placeItemBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(6),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            postDetailsToFirestore();
          },
          child: Text(
            "Place Item",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: HexColor("#C35E12"),
                ),
                // passing this to our root
                onPressed: () {
                  Navigator.of(context).pop();
                })),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Add Item",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        itemNameField,
                        SizedBox(
                          height: 10,
                        ),
                        itemDescriptionField,
                        SizedBox(
                          height: 10,
                        ),
                        itemPriceField,
                        SizedBox(
                          height: 10,
                        ),
                        itemQuantityField,
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 160,
                          child: _image == null
                              ? Image.asset("assets/square-image.png")
                              : Image.file(_image!),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        galleryBtn,
                        SizedBox(
                          height: 10,
                        ),
                        cameraBtn,
                        SizedBox(
                          height: 20,
                        ),
                        placeItemBtn,
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ));
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    RentItemModel rentItemModel = RentItemModel();
    // writing all the values
    rentItemModel.uid = user!.uid;
    rentItemModel.itemName = itemNameEditingController.text;
    rentItemModel.itemDescription = itemDescriptionEditingController.text;
    rentItemModel.itemPrice = itemPriceEditingController.text;
    rentItemModel.itemQuantity = itemQuantityEditingController.text;

    await firebaseFirestore
        .collection("rent-items")
        .add(rentItemModel.toMap())
        .then((value) {
      uploadImage(value.id);
    });
    Fluttertoast.showToast(msg: "For rent item created successfully");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreenDefault()));
  }
}
