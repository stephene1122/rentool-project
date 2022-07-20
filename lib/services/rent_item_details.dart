import 'package:cloud_firestore/cloud_firestore.dart';

class RentItemDetailsService {
  getLendedItemDetails(String uid) {
    return FirebaseFirestore.instance
        .collection("lend-items")
        .where("uid", isEqualTo: uid)
        .get();
  }

  getRentItemDetails(String itemRefId) {
    return FirebaseFirestore.instance
        .collection("rent-items")
        .where("itemId", isEqualTo: itemRefId)
        .get();
  }
}
