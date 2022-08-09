import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:rentool/chat/chatpage.dart';
import 'package:rentool/model/lend_items_model.dart';
import 'package:rentool/model/rent_items_model.dart';
import 'package:rentool/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:rentool/screens/notification_screen.dart';

import '../model/notifications_model.dart';
import '../services/check_token_notification.dart';

class ReturnItemNotification extends StatefulWidget {
  ReturnItemNotification({
    Key? key,
    this.refId,
    this.borrowerUid,
  }) : super(key: key);

  String? borrowerUid;
  String? refId;

  @override
  State<ReturnItemNotification> createState() => _ReturnItemNotificationState();
}

class _ReturnItemNotificationState extends State<ReturnItemNotification> {
  User? user = FirebaseAuth.instance.currentUser;
  var lendItemDetails = LendItemModel();
  RentItemModel rentItemDetails = RentItemModel();
  UserModel borrowerInfo = UserModel();
  NotificationModel notifModel = NotificationModel();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String? aToken;
  String? aUid;

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

    // get Admin nToken
    NotificationToken().getAdminToken().then((QuerySnapshot d) {
      aToken = d.docs[0]['nToken'];
      aUid = d.docs[0]['uid'];
      print(aToken);
      print(aUid);
    });
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
              'to': "aToken",
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
          // title: const Text("Receipt"),
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
                width: 260,
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                height: 30,
              ),
              (lendItemDetails.status == "completed")
                  ? const SizedBox(
                      height: 15,
                    )
                  : checkRentExtended(lendItemDetails.extendedDay!),
              (lendItemDetails.status == "completed")
                  ? const Text(
                      "TRANSACTION COMPLETED",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )
                  : Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                      child: MaterialButton(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        minWidth: 350,
                        onPressed: () {
                          // Navigator.push(
                          //     (context),
                          //     MaterialPageRoute(
                          //         builder: (context) => chatpage(
                          //               friendUid: widget.borrowerUid,
                          //               friendEmail: borrowerInfo.emailAddress,
                          //               friendName: borrowerInfo.fullName,
                          //             )));
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Complete transaction?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              {Navigator.pop(context)},
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            // Navigator.pop(context);
                                            // update the for rent item quantity
                                            var lendedItemQuantity = int.parse(
                                                lendItemDetails
                                                    .lendItemQuantity!);
                                            var cRentItemQuantity = int.parse(
                                                rentItemDetails.itemQuantity!);
                                            var com = lendedItemQuantity +
                                                cRentItemQuantity;
                                            await FirebaseFirestore.instance
                                                .collection("rent-items")
                                                .doc(lendItemDetails.itemId)
                                                .update({
                                              "itemQuantity": com.toString(),
                                            });
                                            await FirebaseFirestore.instance
                                                .collection("lend-items")
                                                .doc(lendItemDetails.id)
                                                .update({
                                              "dateCompleted": DateTime.now(),
                                              "status": "completed"
                                            });
                                            // notify the admin thet transaction is completed
                                            String title =
                                                "Transaction Completed";
                                            String body =
                                                "The item has been return to the owner, and the transaction is successfully completed!";
                                            sendPushMessage(body, title);

                                            // saving data into database for the notification
                                            await firebaseFirestore
                                                .collection("notifications")
                                                .add({
                                              "title": title,
                                              "body": body,
                                              "dateCreated": DateTime.now(),
                                              "from":
                                                  widget.borrowerUid.toString(),
                                              "to": aUid,
                                              "lend-item-id": widget.refId,
                                              "typeId": 9
                                            }).then((value) async {
                                              await firebaseFirestore
                                                  .collection("notifications")
                                                  .doc(value.id)
                                                  .update({"id": value.id});
                                            });

                                            // show Transaction successfully completed
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          "Transaction Successfully Completed!"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              // Navigator.pushReplacement(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (BuildContext context) =>
                                                              //             super.widget));
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pushAndRemoveUntil(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              NotificationScreen()),
                                                                      (route) =>
                                                                          false);
                                                            },
                                                            child: const Text(
                                                                "Ok")),
                                                      ],
                                                    ));
                                          },
                                          child: const Text("Ok")),
                                    ],
                                  ));
                        },
                        child: const Text(
                          "Item Return",
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
              Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: HexColor("#C35E12"),
                  child: MaterialButton(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    minWidth: 350,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
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

  checkRentExtended(d) {
    if (d != "0") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Additional Rent Payment",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Service fee: ₱${lendItemDetails.serviceFee}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Additional Day: ${lendItemDetails.extendedDay} day",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Item Price: ₱${rentItemDetails.itemPrice}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Total: (${rentItemDetails.itemPrice} * ${lendItemDetails.extendedDay}) + ${lendItemDetails.serviceFee} = ₱${lendItemDetails.extendPrice}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }
}
