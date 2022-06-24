import 'package:cloud_firestore/cloud_firestore.dart';

class ChattedFriendService {
  getFriendChat(String currentUid, String friendUid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(currentUid)
        .collection("chatted-friend")
        .where("uid", isEqualTo: friendUid)
        .get();
  }
}
