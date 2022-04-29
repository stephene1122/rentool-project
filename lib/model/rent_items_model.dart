class RentItemModel {
  String? uid;
  String? itemName;
  String? itemDescription;
  String? itemPrice;
  String? itemQuantity;
  DateTime? itemCreated;

  RentItemModel(
      {this.uid,
      this.itemName,
      this.itemDescription,
      this.itemPrice,
      this.itemQuantity,
      this.itemCreated});

  // taking data from server
  factory RentItemModel.fromMap(map) {
    return RentItemModel(
      uid: map['uid'],
      itemName: map['itemName'],
      itemDescription: map['itemDescription'],
      itemPrice: map['itemPrice'],
      itemQuantity: map['itemQuantity'],
    );
  }

  // sending data from server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'itemQuantity': itemQuantity,
      'dateCreated': DateTime.now(),
    };
  }
}
