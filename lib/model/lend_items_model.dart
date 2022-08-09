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
  String? rentPeriod;
  String? rentPeriodFrom;
  String? rentPeriodTo;
  String? status;
  String? rentCountDown;
  String? extendPrice;
  String? serviceFee;
  String? extendedDay;
  String? id;
  String? lenderUid;

  LendItemModel({
    this.uid,
    this.itemId,
    this.lendItemQuantity,
    this.dayLended,
    this.lendMessage,
    this.deliveryAddress,
    this.paymentMethod,
    this.shippingPayment,
    this.subtotalPayment,
    this.totalPayment,
    this.dateCreated,
    this.rentPeriod,
    this.rentPeriodFrom,
    this.rentPeriodTo,
    this.status,
    this.rentCountDown,
    this.extendPrice,
    this.serviceFee,
    this.extendedDay,
    this.id,
    this.lenderUid,
  });

  // taking data from server
  factory LendItemModel.fromMap(map) {
    return LendItemModel(
      uid: map['uid'],
      itemId: map['itemId'],
      lendItemQuantity: map['lendItemQuantity'],
      dayLended: map['dayLended'],
      lendMessage: map['lendMessage'],
      deliveryAddress: map['deliveryAddress'],
      paymentMethod: map['paymentMethod'],
      shippingPayment: map['shippingPayment'],
      subtotalPayment: map['subtotalPayment'],
      totalPayment: map['totalPayment'],
      rentPeriod: map['rentPeriod'],
      rentPeriodFrom: map['rentPeriodFrom'],
      rentPeriodTo: map['rentPeriodTo'],
      status: map['status'],
      rentCountDown: map['rentCountDown'],
      extendedDay: map['extendedDay'],
      serviceFee: map['serviceFee'],
      extendPrice: map['extendPrice'],
      id: map['id'],
      lenderUid: map['lenderUid'],
    );
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
      'rentPeriod': rentPeriod,
      'rentPeriodFrom': rentPeriodFrom,
      'rentPeriodTo': rentPeriodTo,
      'status': status,
      'rentCountDown': rentCountDown,
      'extendPrice': extendPrice,
      'serviceFee': serviceFee,
      'extendedDay': extendedDay,
      'id': id,
      'lenderUid': lenderUid,
      'dateCreated': DateTime.now(),
    };
  }
}
