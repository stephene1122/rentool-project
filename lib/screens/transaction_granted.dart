import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rentool/services/check_token_notification.dart';

import '../chat/chatpage.dart';
import '../model/notifications_model.dart';
import '../model/user_model.dart';

class TransactionGrantedDetails extends StatefulWidget {
  TransactionGrantedDetails({this.lenderUid, this.refId});

  String? lenderUid;
  String? refId;

  @override
  State<TransactionGrantedDetails> createState() =>
      _TransactionGrantedDetailsState();
}

class _TransactionGrantedDetailsState extends State<TransactionGrantedDetails> {
  UserModel lenderInfo = UserModel();
  // String? nToken;
  // String? aToken;
  // String? aUid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getFirebaseToken();
    // NotificationToken().getAdminToken().then((QuerySnapshot d) {
    //   aToken = d.docs[0]['nToken'];
    //   aUid = d.docs[0]['uid'];
    //   print(aToken);
    //   print(aUid);
    // });
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.lenderUid)
        .get()
        .then((value) {
      lenderInfo = UserModel.fromMap(value.data());
    });
    setState(() {});
  }

  // void getFirebaseToken() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(widget.uid)
  //       .get();
  //   String token = snap['nToken'];
  //   nToken = token;
  //   print(token);
  // }

  // void sendPushMessage(String token, String body, String title) async {
  //   try {
  //     await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization':
  //               'key=AAAARiLOifY:APA91bHzJcIGhL3JSn7HL03yOUS1m-oIH6vvLG1uEr9rBfpacTyH9ldYR5RmhrlioIXNZQ74JTxav8kzrw7gJNCwF6tV5AzLQe-h3wl5MBH9LMOhip7TfXRCClsD_oN8j5mh9rv8cE35',
  //         },
  //         body: jsonEncode(
  //           <String, dynamic>{
  //             'notification': <String, dynamic>{'body': body, 'title': title},
  //             'priority': 'high',
  //             'data': <String, dynamic>{
  //               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //               'id': '1',
  //               'status': 'done'
  //             },
  //             'to': token,
  //           },
  //         ));
  //   } catch (e) {
  //     print('error push notification ${e}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Granted!")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 110,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Transaction Granted!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Congrats, your request has been accepted.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 35,
              ),
              const Text(
                "Note: The only allowed users for this app are living at Tagum City.",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              const SizedBox(
                height: 35,
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
                                    friendEmail: lenderInfo.emailAddress,
                                    friendName: lenderInfo.fullName,
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
              // GestureDetector(
              //   onTap: () async {
              //     // String title = "New User!";
              //     // String body = "Account created! Verify the user information";

              //     // // sendPushMessage(aToken!, body, title);

              //     // FirebaseFirestore firebaseFirestore =
              //     //     FirebaseFirestore.instance;

              //     // NotificationModel notifModel = NotificationModel();
              //     // // writing all values
              //     // notifModel.title = title;
              //     // notifModel.body = body;
              //     // notifModel.from = widget.uid;
              //     // notifModel.to = aUid;

              //     // await firebaseFirestore
              //     //     .collection("notifications")
              //     //     .add(notifModel.toMap());

              //     // Navigator.push(context,
              //     //     MaterialPageRoute(builder: (context) => LoginScreen()));
              //     // logout(context);
              //   },
              //   child: Text(
              //     "Click here to process",
              //     style: TextStyle(
              //         fontWeight: FontWeight.w400,
              //         fontSize: 15,
              //         color: HexColor("#C35E12")),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
