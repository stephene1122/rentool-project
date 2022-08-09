class RentItemModel {
  String? itemId;
  String? uid;
  String? itemName;
  String? itemDescription;
  String? itemPrice;
  String? itemQuantity;
  DateTime? itemCreated;
  String? ratings;

  RentItemModel({
    this.itemId,
    this.uid,
    this.itemName,
    this.itemDescription,
    this.itemPrice,
    this.itemQuantity,
    this.itemCreated,
    this.ratings,
  });

  // taking data from server
  factory RentItemModel.fromMap(map) {
    return RentItemModel(
      uid: map['uid'],
      itemName: map['itemName'],
      itemDescription: map['itemDescription'],
      itemPrice: map['itemPrice'],
      itemQuantity: map['itemQuantity'],
      itemId: map['itemId'],
      ratings: map['ratings'],
    );
  }

  // sending data from server
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'uid': uid,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'itemQuantity': itemQuantity,
      'ratings': ratings,
      'dateCreated': DateTime.now(),
    };
  }
}
