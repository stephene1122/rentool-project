import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rentool/services/check_token_notification.dart';

import '../model/notifications_model.dart';

class RegistrationScreenNotif extends StatefulWidget {
  RegistrationScreenNotif({required this.uid});

  String uid;

  @override
  State<RegistrationScreenNotif> createState() =>
      _RegistrationScreenNotifState();
}

class _RegistrationScreenNotifState extends State<RegistrationScreenNotif> {
  String? nToken;
  String? aToken;
  String? aUid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseToken();
    NotificationToken().getAdminToken().then((QuerySnapshot d) {
      aToken = d.docs[0]['nToken'];
      aUid = d.docs[0]['uid'];
      print(aToken);
      print(aUid);
    });
  }

  void getFirebaseToken() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();
    String token = snap['nToken'];
    nToken = token;
    print(token);
  }

  void sendPushMessage(String token, String body, String title) async {
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
              'to': token,
            },
          ));
    } catch (e) {
      print('error push notification ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Almost Done")),
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
                "Your almost done!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "We will validate your account and will notify you at the email address you've provided",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 35,
              ),
              const Text(
                "Note: The only allowed users for this app are living at Tagum City and wait for several time for us to validate your profile thank you",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              const SizedBox(
                height: 35,
              ),
              GestureDetector(
                onTap: () async {
                  String title = "New User!";
                  String body = "Account created! Verify the user information";

                  sendPushMessage(aToken!, body, title);

                  FirebaseFirestore firebaseFirestore =
                      FirebaseFirestore.instance;

                  NotificationModel notifModel = NotificationModel();
                  // writing all values
                  notifModel.title = title;
                  notifModel.body = body;
                  notifModel.from = widget.uid;
                  notifModel.to = aUid;
                  notifModel.typeId = 1;

                  await firebaseFirestore
                      .collection("notifications")
                      .add(notifModel.toMap());

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                  logout(context);
                },
                child: Text(
                  "Click here to process",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: HexColor("#C35E12")),
                ),
              )
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
