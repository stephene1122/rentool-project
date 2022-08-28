import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:rentool/chat/chatpage.dart';
import 'package:rentool/model/lend_items_model.dart';
import 'package:rentool/model/rent_items_model.dart';
import 'package:rentool/model/user_model.dart';
import 'package:rentool/screens/home_screen.dart';
import 'package:rentool/screens/lend_items_screen.dart';
import 'package:rentool/screens/navigation_bar.dart';

class ContactLender extends StatefulWidget {
  ContactLender({
    Key? key,
    required this.refId,
    this.lenderUid,
    this.lenderEmail,
    this.lenderName,
  }) : super(key: key);

  String? lenderUid;
  String? lenderEmail;
  String? lenderName;
  String refId;

  @override
  State<ContactLender> createState() => _ContactLenderState();
}

class _ContactLenderState extends State<ContactLender> {
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
        setState(() {
          FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .get()
              .then((value) {
            borrowerInfo = UserModel.fromMap(value.data());
          });
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Receipt"),
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 55,
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
                            controller:
                                TextEditingController(text: widget.lenderName),
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
                                labelText: "LENDER  NAME")),
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
                                labelText: "BORROWER ADDRESS")),
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
                                    friendUid: widget.lenderUid,
                                    friendEmail: widget.lenderEmail,
                                    friendName: widget.lenderName,
                                  )));
                    },
                    child: const Text(
                      "Contact Lender",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      (context),
                      MaterialPageRoute(
                          builder: (context) => NavigationBarScreen()));
                },
                child: const Text(
                  "Rent more",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 16),
                ),
              ),
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
