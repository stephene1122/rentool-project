import 'dart:convert';
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
import 'package:rentool/screens/navigation_bar.dart';
import 'package:rentool/services/check_token_notification.dart';
import 'package:http/http.dart' as http;

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

  // notification initailization
  String? nToken;

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

    getFirebaseToken(widget.borrowerUid.toString());
  }

  void getFirebaseToken(String uid) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    String token = snap['nToken'];
    nToken = token;
    print(token);
  }

  void sendPushMessage(String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAARiLOifY:APA91bHzJcIGhL3JSn7HL03yOUS1m-oIH6vvLG1uEr9rBfpacTyH9ldYR5RmhrlioIXNZQ74JTxav8kzrw7gJNCwF6tV5AzLQe-h3wl5MBH9LMOhip7TfXRCClsD_oN8j5mh9rv8cE35',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{'body': body, 'title': title},
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to': nToken,
            },
          ));
    } catch (e) {
      print('error push notification ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Borrower Receipt Details"),
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
                  "Borrower Receipt Details",
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

                                // sending notification to lenderPhone
                                String title = "Transaction Accepted!";
                                String body =
                                    "Lender will deliver the item to your location, please wait and prepare payment.\nThank you.";
                                sendPushMessage(body, title);
                                // navigate to chat screen
                                // Navigator.push(
                                //     (context),
                                //     MaterialPageRoute(
                                //         builder: (context) => chatpage(
                                //               friendUid: widget.borrowerUid,
                                //               friendEmail:
                                //                   borrowerInfo.emailAddress,
                                //               friendName: borrowerInfo.fullName,
                                //             )));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            super.widget));
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
                                // initializing value
                                String title = "Transaction Declined!";
                                String body =
                                    "Lender have been declined the transaction, sorry for the inconvenience";
                                // updating the rent quantity and the status decline
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

                                // create notification for declined transaction
                                FirebaseFirestore.instance
                                    .collection("notifications")
                                    .add({
                                  "dateCreated": DateTime.now(),
                                  "title": title,
                                  "body": body,
                                  "from": user!.uid,
                                  "to": lendItemDetails.uid,
                                  "typeId": 10,
                                  "lend-item-id": lendItemDetails.id
                                }).then((value) {
                                  FirebaseFirestore.instance
                                      .collection("notifications")
                                      .doc(value.id)
                                      .update({"id": value.id});
                                });

                                // send phone notification
                                sendPushMessage(body, title);

                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationBarScreen()));
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