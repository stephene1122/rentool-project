class LendItemModel {
  String? uid;
  String? itemId;
  String? lendItemQuantity;
  String? dayLended;
  String? lendMessage;
  String? deliveryAddress;
  String? paymentMethod;
  String? shippingPayment;
  String? subtotalPayment;
  String? totalPayment;
  DateTime? dateCreated;

  LendItemModel(
      {this.uid,
      this.itemId,
      this.lendItemQuantity,
      this.dayLended,
      this.lendMessage,
      this.deliveryAddress,
      this.paymentMethod,
      this.shippingPayment,
      this.subtotalPayment,
      this.totalPayment,
      this.dateCreated});

  // taking data from server
  factory LendItemModel.fromMap(map) {
    return LendItemModel(
        uid: map['uid'],
        itemId: map['itemId'],
        lendItemQuantity: map['lendItemQuantity'],
        dayLended: map['dayLended'],
        lendMessage: map['lendMessage'],
        deliveryAddress: map['deliveryMethod'],
        paymentMethod: map['paymentMethod'],
        shippingPayment: map['shippingPayment'],
        subtotalPayment: map['subtotalPayment'],
        totalPayment: map['totalPayment']);
  }

  // sending data from server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'itemId': itemId,
      'lendItemQuantity': lendItemQuantity,
      'dayLended': dayLended,
      'lendMessage': lendMessage,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'shippingPayment': shippingPayment,
      'subtotalPayment': subtotalPayment,
      'totalPayment': totalPayment,
      'dateCreated': DateTime.now(),
    };
  }
}
