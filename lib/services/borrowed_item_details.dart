import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowedItemDetailsService {
  getItemDetails(String refId) {
    return FirebaseFirestore.instance.collection("rent-items").doc(refId).get();
  }
}
