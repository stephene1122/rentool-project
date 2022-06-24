class ChattedFriendModel {
  String? uid;
  String? friendChatContact;
  String? friendChatName;
  DateTime? dateCreated;

  ChattedFriendModel(
      {this.uid,
      this.friendChatContact,
      this.friendChatName,
      this.dateCreated});

  // taking data from server
  factory ChattedFriendModel.fromMap(map) {
    return ChattedFriendModel(
        uid: map['uid'],
        friendChatContact: map['friend-chat-contact'],
        friendChatName: map['friend-chat-name'],
        dateCreated: map['dateCreated']);
  }

  // sending data from server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'friend-chat-name': friendChatName,
      'friend-chat-contact': friendChatContact,
      'dateCreated': DateTime.now(),
    };
  }
}
