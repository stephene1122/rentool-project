import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/rent_items/item_details.dart';
import 'package:rentool/rent_items/rent_details.dart';

import '../buildmaterialcolor.dart';

class LendItemsScreen extends StatefulWidget {
  const LendItemsScreen({Key? key}) : super(key: key);

  @override
  State<LendItemsScreen> createState() => _LendItemsScreenState();
}

class _LendItemsScreenState extends State<LendItemsScreen> {
  final _formKey = GlobalKey<FormState>();
  final searchItemEditingController = new TextEditingController();

  // Future<void> searchList =

  @override
  Widget build(BuildContext context) {
    final searchItemField = TextFormField(
        autofocus: false,
        controller: searchItemEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Fullname cannot be empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter valid name(Min. 6 Character)");
          }
          return null;
        },
        onSaved: (value) {
          searchItemEditingController.text = value!;
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
            labelText: "Search item to borrow"));

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
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String url = snapshot.data!.docs[index]["downloadURL"];
                return Text(url);
              });
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 5),
                    child: searchItemField),
              ],
            )),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("rent-items")
            .orderBy("dateCreated", descending: true)
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ItemDetails(
                                      refId: snapshot.data!.docChanges[index]
                                          .doc.reference.id,
                                    )));
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
                                    side:
                                        BorderSide(color: HexColor("#C35E12"))),
                                title: Flexible(
                                  child: Text(
                                    "${snapshot.data!.docChanges[index].doc['itemName']}",
                                    style: const TextStyle(fontSize: 20),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                leading: _imageItem(
                                  refId: snapshot
                                      .data!.docChanges[index].doc.reference.id,
                                ),
                                subtitle: Flexible(
                                  child: Text(
                                    "${snapshot.data!.docChanges[index].doc['itemDescription']}",
                                    style: const TextStyle(fontSize: 16),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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

class _searchList extends StatelessWidget {
  _searchList({Key? key, required this.search}) : super(key: key);

  String search;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .where("itemName", isGreaterThanOrEqualTo: search)
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
                              title: Flexible(
                                child: Text(
                                  "${snapshot.data!.docChanges[index].doc['itemName']}",
                                  style: const TextStyle(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              leading: _imageItem(
                                refId: snapshot
                                    .data!.docChanges[index].doc.reference.id,
                              ),
                              subtitle: Flexible(
                                child: Text(
                                  "${snapshot.data!.docChanges[index].doc['itemDescription']}",
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
            ),
          ),
        );
      },
    );
  }
}
