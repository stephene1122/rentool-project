import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/chat/chatpage.dart';
import 'package:rentool/screens/home_screen.dart';

import '../buildmaterialcolor.dart';

class People extends StatefulWidget {
  People({Key? key}) : super(key: key);

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  final searchItemEditingController = new TextEditingController();
  String? searchString;

  @override
  Widget build(BuildContext context) {
    final searchItemField = TextFormField(
        autofocus: false,
        controller: searchItemEditingController,
        keyboardType: TextInputType.name,
        // validator: (value) {
        //   RegExp regex = new RegExp(r'^.{6,}$');
        //   if (value!.isEmpty) {
        //     return ("Fullname cannot be empty");
        //   }
        //   if (!regex.hasMatch(value)) {
        //     return ("Please enter valid name(Min. 6 Character)");
        //   }
        //   return null;
        // },
        onChanged: (val) {
          setState(() {
            searchString = val.toUpperCase();
            print(searchString);
          });
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            labelText: "Search a person"));
    return Scaffold(
      appBar: AppBar(
        leading: SafeArea(
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(150.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 95,
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 5),
                    child: searchItemField),
              ],
            )),
      ),
      body: StreamBuilder(
        stream: (searchString == null || searchString == '')
            ? FirebaseFirestore.instance
                .collection("users")
                .where("uid", isNotEqualTo: currentUser)
                .snapshots()
            : FirebaseFirestore.instance
                .collection("users")
                .where(
                  "emailAddress",
                  isGreaterThan: searchString,
                )
                .where("uid", isNotEqualTo: currentUser)
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
                        var vfriendUid =
                            snapshot.data!.docChanges[index].doc['uid'];
                        var vfriendName =
                            snapshot.data!.docChanges[index].doc['fullName'];
                        var vfriendEmail = snapshot
                            .data!.docChanges[index].doc['emailAddress'];
                        var vfriendContactNumber = snapshot
                            .data!.docChanges[index].doc['contactNumber'];

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => chatpage(
                                      friendUid: snapshot
                                          .data!.docChanges[index].doc['uid'],
                                      friendName: snapshot.data!
                                          .docChanges[index].doc['fullName'],
                                      friendEmail: snapshot
                                          .data!
                                          .docChanges[index]
                                          .doc['emailAddress'],
                                    )));
                        // adding chat friend list
                        if (vfriendUid != currentUser) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(currentUser)
                              .collection("chatted-friend")
                              .add({
                            "uid": vfriendUid,
                            "friend-chat-name": vfriendName,
                            "friend-chat-contact": vfriendEmail,
                            "friend-chat-email": vfriendContactNumber,
                            "dateCreated": DateTime.now(),
                          }).then((value) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(currentUser)
                                .collection("chatted-friend")
                                .doc(value.id)
                                .update({
                              "id": value.id,
                            });
                          });
                        }
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
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 6),
                              tileColor: HexColor("#E3B13B"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  side: BorderSide(color: HexColor("#C35E12"))),
                              title: Text(
                                "${snapshot.data!.docChanges[index].doc['fullName']}",
                                style: const TextStyle(fontSize: 20),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: _imageItem(
                                refId: snapshot
                                    .data!.docChanges[index].doc.reference.id,
                              ),
                              subtitle: Text(
                                "Email: ${snapshot.data!.docChanges[index].doc['emailAddress']} \nContact#: ${snapshot.data!.docChanges[index].doc['contactNumber']}",
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

class _imageItem extends StatelessWidget {
  _imageItem({Key? key, this.refId}) : super(key: key);

  String? refId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(refId)
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
          return GestureDetector(
              onTap: () {
                print("image");
              },
              child: SizedBox(
                  width: 60,
                  height: 80,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                  )));
        }
      },
    );
  }
}
