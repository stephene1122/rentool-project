import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/model/notifications_model.dart';
import 'package:http/http.dart' as http;
import 'package:rentool/screens/user_validation_table.dart';

import '../widgets/info_card.dart';
import 'hero_image.dart';

class UserValidationDetails extends StatefulWidget {
  UserValidationDetails({Key? key, required this.uid}) : super(key: key);
  String uid;
  @override
  State<UserValidationDetails> createState() => _UserValidationDetailsState();
}

class _UserValidationDetailsState extends State<UserValidationDetails> {
  String? nToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseToken();
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

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // get selfie image url
    final userImage = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection("images-user-selfie")
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80, child: Image.asset("assets/square-image.png"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          String url = snapshot.data!.docs[0]['downloadURL'];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HeroImage(tagUrl: url)));
            },
            child: Hero(
              tag: url,
              child: CircleAvatar(
                radius: 100 / 2,
                backgroundColor: Colors.grey.shade800,
                backgroundImage: NetworkImage(url),
              ),
            ),
          );
        }
      },
    );

    // get validid image url
    final userValidId = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection("images-user-validid")
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80, child: Image.asset("assets/square-image.png"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          String url = snapshot.data!.docs[0]['downloadURL'];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HeroImage(tagUrl: url)));
            },
            child: Hero(
              tag: url,
              child: Image.network(url),
            ),
          );
        }
      },
    );

    // get user selfie image url
    final userSelfie = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection("images-user-selfie")
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80, child: Image.asset("assets/square-image.png"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          String url = snapshot.data!.docs[0]['downloadURL'];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HeroImage(tagUrl: url)));
            },
            child: Hero(
              tag: url,
              child: Image.network(url),
            ),
          );
        }
      },
    );

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('uid', isEqualTo: widget.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Text("has no data!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
              appBar: AppBar(title: Text("Details")),
              body: SingleChildScrollView(
                child: Center(
                  child: SafeArea(
                      minimum: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: <Widget>[
                          userImage,
                          Text(
                            "${snapshot.data!.docChanges[0].doc['fullName']}",
                            style: GoogleFonts.pacifico(
                                textStyle: TextStyle(
                                    fontSize: 30.0,
                                    color: HexColor("#E4B43D"),
                                    fontWeight: FontWeight.bold)),
                          ),
                          // Text(
                          //   "Passionate Learner",
                          //   style: GoogleFonts.sourceSansPro(
                          //       textStyle: TextStyle(
                          //           fontSize: 25,
                          //           color: Colors.blueGrey[200],
                          //           letterSpacing: 2.5,
                          //           fontWeight: FontWeight.bold)),
                          // ),
                          const SizedBox(
                            height: 20,
                            width: 200,
                            child: Divider(color: Colors.white),
                          ),
                          InfoCard(
                              text: snapshot
                                  .data!.docChanges[0].doc['contactNumber'],
                              icon: Icons.phone),
                          InfoCard(
                              text: snapshot
                                  .data!.docChanges[0].doc['emailAddress'],
                              icon: Icons.email),
                          InfoCard(
                              text: snapshot
                                  .data!.docChanges[0].doc['homeAddress'],
                              icon: Icons.home),
                          InfoCard(
                              text: snapshot.data!.docChanges[0].doc['gender'],
                              icon: Icons.person),
                          InfoCard(
                              text:
                                  snapshot.data!.docChanges[0].doc['birthDate'],
                              icon: Icons.cake),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            child: Text(
                              "User Selfie",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 340,
                            child: userSelfie,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            child: Text(
                              "Valid ID",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 340,
                            child: userValidId,
                          ),
                          MaterialButton(
                            color: HexColor("#E4B43D"),
                            onPressed: () async {
                              String title = "Account Validated!";
                              String body =
                                  "Your account has been validated! you can now login your account. Thank you";

                              sendPushMessage(nToken!, body, title);

                              FirebaseFirestore firebaseFirestore =
                                  FirebaseFirestore.instance;

                              User? user = _auth.currentUser;
                              NotificationModel notifModel =
                                  NotificationModel();
                              // writing all values
                              notifModel.title = title;
                              notifModel.body = body;
                              notifModel.from = user!.uid;
                              notifModel.to = widget.uid;

                              await firebaseFirestore
                                  .collection("notifications")
                                  .add(notifModel.toMap());

                              await firebaseFirestore
                                  .collection("users")
                                  .doc(snapshot.data!.docChanges[0].doc['uid'])
                                  .update({"isUserGranted": "1"});
                              Fluttertoast.showToast(msg: "Success!");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NewUsersTable()));
                            },
                            child: const Text("Verify User"),
                          )
                        ],
                      )),
                ),
              ));
        });
  }

  void approvedUser(String uid) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .update({"isUserGranted": "1"});
    Fluttertoast.showToast(msg: "Success!");
    Navigator.of(context).pop();
  }
}
