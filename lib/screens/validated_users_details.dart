import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/screens/hero_image.dart';

import '../widgets/info_card.dart';

class VerifiedUserDetails extends StatefulWidget {
  VerifiedUserDetails({Key? key, required this.uid}) : super(key: key);
  String uid;

  @override
  State<VerifiedUserDetails> createState() => _VerifiedUserDetailsState();
}

class _VerifiedUserDetailsState extends State<VerifiedUserDetails> {
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
            height: 80,
            child: Image.asset("assets/square-image.png"),
          );
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
                  maxRadius: 60,
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: NetworkImage(url),
                )),
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
              appBar: AppBar(title: const Text("Verified User Details")),
              body: SingleChildScrollView(
                child: Center(
                  child: SafeArea(
                      minimum: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: <Widget>[
                          userImage,
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${snapshot.data!.docChanges[0].doc['fullName']}",
                            style: GoogleFonts.fjallaOne(
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
                          SizedBox(
                            width: 350,
                            child: userValidId,
                          ),
                          // MaterialButton(
                          //   color: HexColor("#E4B43D"),
                          //   onPressed: () {
                          //     FirebaseFirestore firebaseFirestore =
                          //         FirebaseFirestore.instance;

                          //     firebaseFirestore
                          //         .collection("users")
                          //         .doc(snapshot.data!.docChanges[0].doc['uid'])
                          //         .update({"isUserGranted": "1"});
                          //     Fluttertoast.showToast(msg: "Success!");
                          //     Navigator.of(context).pop();
                          //   },
                          //   child: const Text("Verify User"),
                          // )
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      )),
                ),
              ));
        });
  }
}
