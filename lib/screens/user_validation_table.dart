import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/screens/user_validation_details.dart';
import 'package:rentool/services/user_admin.dart';
import 'package:http/http.dart' as http;
import '../model/notifications_model.dart';

class NewUsersTable extends StatefulWidget {
  const NewUsersTable({Key? key}) : super(key: key);

  @override
  State<NewUsersTable> createState() => _NewUsersTableState();
}

class _NewUsersTableState extends State<NewUsersTable> {
  String? nToken;

  void getFirebaseToken(String uid) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
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
              'notification': <String, dynamic>{
                'body': 'Test',
                'title': 'Test Title'
              },
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
        appBar: AppBar(
          title: const Text("New Registered Users"),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 10),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('isUserGranted', isEqualTo: '0')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("something wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ListTile(
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserValidationDetails(
                                    uid: snapshot
                                        .data!.docChanges[index].doc['uid'],
                                  ),
                                ));
                          },
                          leading: _userImage(
                              uid: snapshot.data!.docChanges[index].doc['uid']),
                          title: Text(
                              "${snapshot.data!.docChanges[index].doc['fullName']}"),
                          subtitle: Text(
                              "${snapshot.data!.docChanges[index].doc['homeAddress']}"),
                          trailing: MaterialButton(
                            onPressed: () async {
                              String title = "Account Validated!";
                              String body =
                                  "Your account has been validated! you can now login your account. Thank you";
                              String uid =
                                  snapshot.data!.docChanges[index].doc['uid'];
                              getFirebaseToken(uid);
                              sendPushMessage(nToken!, body, title);

                              FirebaseFirestore firebaseFirestore =
                                  FirebaseFirestore.instance;

                              User? user = FirebaseAuth.instance.currentUser;
                              NotificationModel notifModel =
                                  NotificationModel();
                              // writing all values
                              notifModel.title = title;
                              notifModel.body = body;
                              notifModel.from = user!.uid;
                              notifModel.to = uid;

                              await firebaseFirestore
                                  .collection("notifications")
                                  .add(notifModel.toMap());

                              userAdminService().approvedUser(
                                  "${snapshot.data!.docChanges[index].doc['uid']}",
                                  "context");
                            },
                            child: Icon(
                              Icons.verified_user,
                              color: HexColor("#E4B43D"),
                            ),
                          ),
                        ));
                  });
            },
          ),
        ));
  }
}

class _userImage extends StatelessWidget {
  _userImage({Key? key, this.uid}) : super(key: key);
  String? uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("images-user-selfie")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/square-album.png"));
        } else {
          String url = snapshot.data!.docs[0]["downloadURL"];
          return SizedBox(
              width: 60,
              height: 80,
              child: CircleAvatar(
                backgroundImage: NetworkImage(url),
              ));
        }
      },
    );
  }
}
