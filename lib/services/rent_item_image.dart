import 'package:cloud_firestore/cloud_firestore.dart';

class RentItemImage {
  getRentItemImage(String refId) {
    return FirebaseFirestore.instance
        .collection("rent-items")
        .doc(refId)
        .collection("images")
        .orderBy("dateCreated", descending: true)
        .get();
  }
}
