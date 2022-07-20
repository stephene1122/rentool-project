import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationToken {
  checkToken(String token) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("nToken", isEqualTo: token)
        .get();
  }

  getAdminToken() {
    return FirebaseFirestore.instance
        .collection("users")
        .where('isAdmin', isEqualTo: '1')
        .get();
  }
}
