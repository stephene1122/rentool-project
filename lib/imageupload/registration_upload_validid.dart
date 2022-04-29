import 'dart:io';
import 'package:flutter/material.dart';
// image picker for picking the image
// firebase storage for uploading the image to firebasestorage
// and, cloud firestore for saving the url for uploaded image to our application
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentool/imageupload/registration_upload_user_image.dart';

class UploadValidId extends StatefulWidget {
  // we need the user id to create a image folder for a particular user
  String? userId;

  UploadValidId({Key? key, this.userId}) : super(key: key);

  @override
  State<UploadValidId> createState() => _UploadValidIdState();
}

class _UploadValidIdState extends State<UploadValidId> {
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

  Future uploadImage() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${widget.userId}/images/user_validid")
        .child("post_$postID");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();

    // uploading to cloudfirestore
    await firebaseFirestore
        .collection("users")
        .doc(widget.userId)
        .collection("images-user-validid")
        .add({
      'downloadURL': downloadURL,
      'dateCreated': DateTime.now()
    }).whenComplete(() =>
            showSnackBar("Image uploaded successfully", Duration(seconds: 2)));
  }

  // snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
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
    final nextBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(6),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            // upload only when the image has some values
            if (_image != null) {
              uploadImage().then((value) => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UploadUserImage(userId: widget.userId)))
                  });
            } else {
              showSnackBar("Select Image First", Duration(milliseconds: 400));
            }
          },
          child: Text(
            "Next",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));
    return Scaffold(
      appBar: AppBar(title: const Text("Image Upload")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 110,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Please upload your valid ID",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              Expanded(
                child: _image == null
                    ? SizedBox(
                        height: 140, child: Image.asset("assets/id-image.png"))
                    : Image.file(_image!),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 15,
              ),
              galleryBtn,
              SizedBox(
                height: 15,
              ),
              cameraBtn,
              SizedBox(
                height: 35,
              ),
              nextBtn,
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
