import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/borrow_items/borrow_item_details.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:rentool/rent_items/add_rent.dart';
import 'package:rentool/screens/home_screen.dart';
import 'package:rentool/screens/home_screen_default.dart';
import 'package:rentool/screens/lend_items_screen.dart';
import 'package:rentool/screens/navigation_bar.dart';

import '../screens/hero_image.dart';

class BorrowItemsList extends StatefulWidget {
  BorrowItemsList({Key? key, required this.userId}) : super(key: key);
  String? userId;
  @override
  State<BorrowItemsList> createState() => _BorrowItemsListState();
}

class _BorrowItemsListState extends State<BorrowItemsList> {
  @override
  Widget build(BuildContext context) {
    String itemName, itemPrice, itemDescription;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NavigationBarScreen()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("My Borrowed Items"),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            // passing this to our root
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => NavigationBarScreen(
                        tabIndex: 3,
                      )));
            }),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("lend-items")
            .where("uid", isEqualTo: widget.userId)
            .where("status", isEqualTo: "accepted")
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BorrowitemDetails(
                                  rentItemId: snapshot
                                      .data!.docChanges[index].doc['itemId'],
                                  lendId: snapshot
                                      .data!.docChanges[index].doc['id'],
                                  lenderUid: snapshot
                                      .data!.docChanges[index].doc['lenderUid'],
                                )));
                    print(snapshot.data!.docChanges[index].doc['id']);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 5, right: 5),
                        child: ListTile(
                          tileColor: HexColor("#E3B13B"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                              side: BorderSide(color: HexColor("#C35E12"))),
                          title: _itemName(
                              id: snapshot
                                  .data!.docChanges[index].doc['itemId']),
                          leading: _imageItem(
                              imageRefId: snapshot
                                  .data!.docChanges[index].doc['itemId']),
                          subtitle: Text(
                            "DATE RENTED: \nFrom ${snapshot.data!.docChanges[index].doc['rentPeriod']}",
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
                                "Rent Day: ${snapshot.data!.docChanges[index].doc['dayLended']} \n Quantity: ${snapshot.data!.docChanges[index].doc['lendItemQuantity']}",
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
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
  _imageItem({Key? key, required this.imageRefId}) : super(key: key);

  String imageRefId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .doc(imageRefId)
          .collection("images")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 60,
              width: 60,
              child: Image.asset("assets/square-album.png"));
        } else {
          String url = snapshot.data!.docs[0]["downloadURL"];
          return SizedBox(
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }
}

class _itemName extends StatelessWidget {
  _itemName({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .where('itemId', isEqualTo: id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Text("No data!");
        } else {
          String d = snapshot.data!.docs[0]["itemName"];
          return Text(
            "Item: ${d}",
            style: const TextStyle(fontSize: 20),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}

class _itemDescription extends StatelessWidget {
  _itemDescription({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .where('itemId', isEqualTo: id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Text("No data!");
        } else {
          String d = snapshot.data!.docs[0]["itemDescription"];
          return Text(
            d,
            style: const TextStyle(fontSize: 16),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}

class itemPriceQuantity extends StatelessWidget {
  itemPriceQuantity({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .where('itemId', isEqualTo: id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Text("No data!");
        } else {
          String d = snapshot.data!.docs[0]["itemPrice"];
          String e = snapshot.data!.docs[0]["itemQuantity"];
          return Text(
            "Price: ${d} \nQuantity: ${e}",
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}
