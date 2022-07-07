import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class userAdminService {
  isUserAdmin(String cuid) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: cuid)
        .get();
  }

  void approvedUser(String uid, context) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .update({"isUserGranted": "1"});
    Fluttertoast.showToast(msg: "Success!");
    Navigator.of(context).pop();
  }
}
