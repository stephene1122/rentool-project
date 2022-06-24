import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 95,
                ),
                const Padding(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 5),
                    child: Center(
                        child: Text(
                      "Notifications",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ))),
              ],
            )),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("chatted-friend")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("something wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => ItemDetails(
                        //               refId: snapshot.data!.docChanges[index]
                        //                   .doc.reference.id,
                        //             )));
                        print(
                            "${snapshot.data!.docChanges[index].doc.reference.id}");
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 6),
                              tileColor: HexColor("#E3B13B"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  side: BorderSide(color: HexColor("#C35E12"))),
                              title: Text(
                                "${snapshot.data!.docChanges[index].doc['friend-chat-name']}",
                                style: const TextStyle(fontSize: 20),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // leading: _imageItem(
                              //   refId:
                              //       snapshot.data!.docChanges[index].doc['uid'],
                              // ),
                              subtitle: Text(
                                "Email: ${snapshot.data!.docChanges[index].doc['friend-chat-email']} \nContact#: ${snapshot.data!.docChanges[index].doc['friend-chat-contact']}",
                                style: const TextStyle(fontSize: 16),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // contentPadding: const EdgeInsets.symmetric(
                              //     vertical: 12, horizontal: 16),
                              // trailing: Column(
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       "Price: ${snapshot.data!.docChanges[index].doc['itemPrice']} \n\nQuantity: ${snapshot.data!.docChanges[index].doc['itemQuantity']}",
                              //       style: const TextStyle(fontSize: 15),
                              //     )
                              //   ],
                              // )
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
