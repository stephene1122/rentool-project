import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:rentool/chat/chatpage.dart';
import 'package:rentool/model/lend_items_model.dart';
import 'package:rentool/model/notifications_model.dart';
import 'package:rentool/model/rent_items_model.dart';
import 'package:rentool/model/user_model.dart';
import 'package:rentool/screens/home_screen.dart';
import 'package:rentool/screens/lend_items_screen.dart';

class ContactBorrower extends StatefulWidget {
  ContactBorrower({
    Key? key,
    this.refId,
    this.borrowerUid,
  }) : super(key: key);

  String? borrowerUid;
  String? refId;

  @override
  State<ContactBorrower> createState() => _ContactBorrowerState();
}

class _ContactBorrowerState extends State<ContactBorrower> {
  User? user = FirebaseAuth.instance.currentUser;
  LendItemModel lendItemDetails = LendItemModel();
  RentItemModel rentItemDetails = RentItemModel();
  UserModel borrowerInfo = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection("lend-items")
        .doc(widget.refId)
        .get()
        .then((value) {
      lendItemDetails = LendItemModel.fromMap(value.data());
      setState(() {});
      FirebaseFirestore.instance
          .collection("rent-items")
          .doc(lendItemDetails.itemId)
          .get()
          .then((d) {
        rentItemDetails = RentItemModel.fromMap(d.data());
        setState(() {});
      });
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.borrowerUid)
          .get()
          .then((value) {
        borrowerInfo = UserModel.fromMap(value.data());
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 80,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "Receipt Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: buildMaterialColor(const Color(0xFFE3B13B)),
                    border: Border.all(
                        color: buildMaterialColor(const Color(0xFFC35E12))),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Form(
                        child: Column(
                      children: [
                        TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: borrowerInfo.fullName),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "BORROWER NAME")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: rentItemDetails.itemName),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "ITEM NAME")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: lendItemDetails.lendItemQuantity),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "QUANTITY")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            readOnly: true,
                            maxLines: null,
                            autofocus: false,
                            controller: TextEditingController(
                                text: lendItemDetails.rentPeriod),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "RENT PERIOD")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: lendItemDetails.deliveryAddress),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "DELIVERY ADDRESS")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            maxLines: null,
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: lendItemDetails.lendMessage),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "BORROWER MESSAGE")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: lendItemDetails.paymentMethod),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "PAYMENT METHOD")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: lendItemDetails.subtotalPayment),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "SUBTOTAL PAYMENT")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: lendItemDetails.shippingPayment),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "SHIPPING PAYMENT")),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(
                                text: lendItemDetails.totalPayment),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          buildMaterialColor(Color(0xFFC35E12)),
                                      width: 2.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                labelText: "TOTAL PAYMENT")),
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              (lendItemDetails.status == "pending")
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(30),
                            color: HexColor("#C35E12"),
                            child: MaterialButton(
                              onPressed: () async {
                                FirebaseFirestore.instance
                                    .collection('lend-items')
                                    .doc(widget.refId)
                                    .update({'status': 'accepted'});

                                NotificationModel notifModel =
                                    NotificationModel();
                                // writing all values
                                notifModel.title = "Transaction Granted!";
                                notifModel.body =
                                    "Congrats, your transaction is accepted.";
                                notifModel.from = user!.uid;
                                notifModel.to = widget.borrowerUid;

                                await FirebaseFirestore.instance
                                    .collection("notifications")
                                    .add(notifModel.toMap())
                                    .then((value) {
                                  FirebaseFirestore.instance
                                      .collection("notifications")
                                      .doc(value.id)
                                      .update({
                                    'id': value.id,
                                    'typeId': 5,
                                    'lend-item-id': widget.refId
                                  });
                                });

                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (context) => chatpage(
                                              friendUid: widget.borrowerUid,
                                              friendEmail:
                                                  borrowerInfo.emailAddress,
                                              friendName: borrowerInfo.fullName,
                                            )));
                              },
                              child: const Text(
                                "Accept Transaction",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.red,
                            child: MaterialButton(
                              onPressed: () async {
                                num a =
                                    int.parse(rentItemDetails.itemQuantity!);
                                num b = int.parse(
                                    lendItemDetails.lendItemQuantity!);
                                num c = a + b;
                                c.toInt();
                                await FirebaseFirestore.instance
                                    .collection('rent-items')
                                    .doc(lendItemDetails.itemId)
                                    .update({"itemQuantity": c.toString()});
                                await FirebaseFirestore.instance
                                    .collection('lend-items')
                                    .doc(widget.refId)
                                    .update({'status': 'declined'});

                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                              child: const Text(
                                "Decline Transaction",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                      ],
                    )
                  : (lendItemDetails.status == "declined")
                      ? const Text(
                          "Transaction Declined!",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      : const Text(
                          "Transaction Accepted!",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
              const SizedBox(
                height: 15,
              ),
              Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: HexColor("#C35E12"),
                  child: MaterialButton(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    minWidth: 350,
                    onPressed: () {
                      Navigator.push(
                          (context),
                          MaterialPageRoute(
                              builder: (context) => chatpage(
                                    friendUid: widget.borrowerUid,
                                    friendEmail: borrowerInfo.emailAddress,
                                    friendName: borrowerInfo.fullName,
                                  )));
                    },
                    child: const Text(
                      "Contact Borrower",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
