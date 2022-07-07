import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/chat/chatpage.dart';

import '../screens/hero_image.dart';

class BorrowitemDetails extends StatefulWidget {
  BorrowitemDetails({Key? key, required this.borrowRefId}) : super(key: key);

  String borrowRefId;

  @override
  State<BorrowitemDetails> createState() => _BorrowitemDetailsState();
}

class _BorrowitemDetailsState extends State<BorrowitemDetails> {
  @override
  Widget build(BuildContext context) {
    // get item image
    final itemImage = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .doc(widget.borrowRefId)
          .collection("images")
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
            .collection("rent-items")
            .where('postID', isEqualTo: widget.borrowRefId)
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
              appBar: AppBar(title: Text("${widget.borrowRefId}")),
              body: SingleChildScrollView(
                child: Center(
                  child: SafeArea(
                      minimum: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 350,
                            height: 150,
                            child: itemImage,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${snapshot.data!.docChanges[0].doc['itemName']}",
                            style: GoogleFonts.fjallaOne(
                                textStyle: TextStyle(
                                    fontSize: 30.0,
                                    color: HexColor("#E4B43D"),
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: ListTile(
                              title: Text(
                                snapshot
                                    .data!.docChanges[0].doc['itemDescription'],
                                style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: Colors.black, fontSize: 24)),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: ListTile(
                              leading: const Icon(Icons.paid),
                              title: Text(
                                snapshot.data!.docChanges[0].doc['itemPrice'],
                                style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: Colors.black, fontSize: 24)),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: ListTile(
                              leading:
                                  const Icon(Icons.production_quantity_limits),
                              title: Text(
                                snapshot
                                    .data!.docChanges[0].doc['itemQuantity'],
                                style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: Colors.black, fontSize: 24)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          MessageLender(
                              uid: snapshot.data!.docChanges[0].doc['uid']),
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

class MessageLender extends StatelessWidget {
  MessageLender({Key? key, this.uid}) : super(key: key);

  String? uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Text("no data!");
          } else {
            String lenderName = snapshot.data!.docs[0]['fullName'];
            String lenderUid = snapshot.data!.docs[0]['uid'];
            String lenderEmail = snapshot.data!.docs[0]['emailAddress'];

            return SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => chatpage(
                              friendUid: lenderUid,
                              friendName: lenderName,
                              friendEmail: lenderEmail)));
                },
                icon: const Icon(
                  Icons.message,
                  size: 24.0,
                ),
                label: Text(
                  "${lenderName}",
                  style: const TextStyle(fontSize: 20),
                ), // <-- Text
              ),
            );
          }
        });
  }
}
