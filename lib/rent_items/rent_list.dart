import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rentool/rent_items/add_rent.dart';

class LendedItems extends StatefulWidget {
  String? userId;
  LendedItems({Key? key, this.userId}) : super(key: key);

  @override
  State<LendedItems> createState() => _LendedItemsState();
}

class _LendedItemsState extends State<LendedItems> {
  // final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
  //     .collection("rent-items")
  //     .where("uid", isEqualTo: "${widget.userId}")
  //     .snapshots();

  final priceField = <TextSpan>[
    new TextSpan(text: 'Hello'),
    new TextSpan(
        text: 'World', style: new TextStyle(fontWeight: FontWeight.bold)),
  ];

  @override
  Widget build(BuildContext context) {
    // get selfie image url
    final userImage = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .doc()
          .collection("images")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/square-image.png"));
        } else {
          String url = snapshot.data!.docs[0]["downloadURL"];
          return CircleAvatar(
            radius: 80 / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: NetworkImage(url),
          );
        }
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddRent()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("For Rent Items")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("rent-items")
            .where("uid", isEqualTo: "${widget.userId}")
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
          return Container(
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
                    //         builder: (_) => editnote(
                    //               docid: snapshot.data!.docs[index],
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
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: ListTile(
                            tileColor: HexColor("#E3B13B"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                                side: BorderSide(color: HexColor("#C35E12"))),
                            title: Text(
                              "${snapshot.data!.docChanges[index].doc['itemName']}",
                              style: const TextStyle(fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: _imageItem(
                              refId: snapshot
                                  .data!.docChanges[index].doc.reference.id,
                            ),
                            subtitle: Text(
                              "${snapshot.data!.docChanges[index].doc['itemDescription']}",
                              style: const TextStyle(fontSize: 16),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Price: ${snapshot.data!.docChanges[index].doc['itemPrice']} \n\nQuantity: ${snapshot.data!.docChanges[index].doc['itemQuantity']}",
                                  style: const TextStyle(fontSize: 15),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                );
              },
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
          .collection("rent-items")
          .doc(refId)
          .collection("images")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/square-album.png"));
        } else {
          // return ListView.builder(
          //     itemCount: snapshot.data!.docs.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       String url = snapshot.data!.docs[index]["downloadURL"];
          //       return GestureDetector(
          //         onTap: () {
          //           print("images");
          //         },
          //         child: CircleAvatar(
          //           radius: 30,
          //           backgroundImage: NetworkImage(url),
          //         ),
          //       );
          //     });
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
