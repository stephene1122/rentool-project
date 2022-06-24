import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:rentool/model/rent_items_model.dart';
import 'package:rentool/rent_items/rent_item_note.dart';
import 'package:rentool/rent_items/rent_list.dart';

class EditRentItem extends StatefulWidget {
  EditRentItem({Key? key, required this.docId}) : super(key: key);

  QueryDocumentSnapshot docId;

  @override
  State<EditRentItem> createState() => _EditRentItemState();
}

class _EditRentItemState extends State<EditRentItem> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();

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
          showSnackBar("No file selected", const Duration(milliseconds: 400));
        }
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future uploadImage() async {
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
        .doc(widget.docId.id)
        .collection("images")
        .add({
      'downloadURL': downloadURL,
      'dateCreated': DateTime.now(),
    }).whenComplete(() => showSnackBar(
            "Item created successfully", const Duration(seconds: 2)));
  }

  // snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    itemNameController =
        TextEditingController(text: widget.docId.get('itemName'));
    itemDescriptionController =
        TextEditingController(text: widget.docId.get('itemDescription'));
    itemPriceController =
        TextEditingController(text: widget.docId.get('itemPrice'));
    itemQuantityController =
        TextEditingController(text: widget.docId.get('itemQuantity'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // item name field
    final itemNameField = TextFormField(
        autofocus: false,
        controller: itemNameController,
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
          itemNameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Name"));

    // item description field
    final itemDescriptionField = TextFormField(
        autofocus: false,
        controller: itemDescriptionController,
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
          itemDescriptionController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Description"));

    // item Price field
    final itemPriceField = TextFormField(
        autofocus: false,
        controller: itemPriceController,
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
          itemPriceController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Price"));

    // item quantity field
    final itemQuantityField = TextFormField(
        autofocus: false,
        controller: itemQuantityController,
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
          itemQuantityController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            imagePickerMethod(ImageSource.gallery);
          },
          child: const Text(
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
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            imagePickerMethod(ImageSource.camera);
          },
          child: const Text(
            "Take a picture",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // Update button
    final updateItemBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(6),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            postRentItemToFirestore();
          },
          child: const Text(
            "Save",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // Delete button
    final deleteItemBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(6),
        color: HexColor("#E91B1B"),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            // widget.docId.reference.delete().whenComplete(() {
            //   Navigator.pushReplacement(context,
            //       MaterialPageRoute(builder: (context) => LendedItems()));
            // });
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Are you sure to delete this item?"),
                      actions: [
                        TextButton(
                            onPressed: () => {
                                  widget.docId.reference
                                      .delete()
                                      .whenComplete(() {
                                    Navigator.pop(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new LendedItems()));
                                  })
                                },
                            child: const Text("Ok"))
                      ],
                    ));
          },
          child: const Text(
            "Delete",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    return Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Edit Rent Item",
          ),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              // passing this to our root
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
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
                        itemNameField,
                        const SizedBox(
                          height: 10,
                        ),
                        itemDescriptionField,
                        const SizedBox(
                          height: 10,
                        ),
                        itemPriceField,
                        const SizedBox(
                          height: 10,
                        ),
                        itemQuantityField,
                        const SizedBox(
                          height: 25,
                        ),
                        _image != null
                            ? Image.file(_image!)
                            : _imageItem(refId: widget.docId.id),
                        const SizedBox(
                          height: 20,
                        ),
                        galleryBtn,
                        const SizedBox(
                          height: 10,
                        ),
                        cameraBtn,
                        const SizedBox(
                          height: 20,
                        ),
                        updateItemBtn,
                        const SizedBox(
                          height: 10,
                        ),
                        deleteItemBtn
                      ],
                    )),
              ),
            ),
          ),
        ));
  }

  postRentItemToFirestore() async {
    RentItemModel rentItemModel = RentItemModel();
    // writing all the values
    rentItemModel.uid = _auth.currentUser!.uid;
    rentItemModel.itemName = itemNameController.text.toUpperCase();
    rentItemModel.itemDescription = itemDescriptionController.text;
    rentItemModel.itemPrice = itemPriceController.text;
    rentItemModel.itemQuantity = itemQuantityController.text;
    rentItemModel.itemCreated = DateTime.now();

    // uploading image and creating downloadURL
    uploadImage();

    await widget.docId.reference.set(rentItemModel.toMap()).whenComplete(() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LendedItems(),
          ));
    });
  }
}

class _imageItem extends StatelessWidget {
  _imageItem({Key? key, required this.refId}) : super(key: key);

  String? refId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .doc(refId)
          .collection("images")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/square-album.png"));
        } else {
          // return ListView.builder(
          //     itemCount: snapshot.data!.docs.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       String url = snapshot.data!.docs[index]["downloadURL"];
          //       return GestureDetector(
          //         onTap: () {
          //           print("images");
          //         },
          //         child: CircleAvatar(
          //           radius: 30,
          //           backgroundImage: NetworkImage(url),
          //         ),
          //       );
          //     });
          String url = snapshot.data!.docs[0]["downloadURL"];
          return GestureDetector(
              onTap: () {
                print("image");
              },
              child: SizedBox(
                  child: Image.network(
                url,
                fit: BoxFit.contain,
              )));
        }
      },
    );
  }
}
