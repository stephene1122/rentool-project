import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/borrow_items/borrow_item_details.dart';
import 'package:rentool/rent_items/add_rent.dart';
import 'package:rentool/screens/home_screen.dart';
import 'package:rentool/screens/lend_items_screen.dart';

class BorrowItemsList extends StatefulWidget {
  BorrowItemsList({Key? key, required this.userId}) : super(key: key);
  String? userId;
  @override
  State<BorrowItemsList> createState() => _BorrowItemsListState();
}

class _BorrowItemsListState extends State<BorrowItemsList> {
  @override
  Widget build(BuildContext context) {
    var rentItemDetails;
    Future<void> getItemDetails(refId) async {
      //query the rent item
      await FirebaseFirestore.instance
          .collection("rent-items")
          .doc(refId)
          .snapshots()
          .listen((event) {
        setState(() {
          rentItemDetails = event.get("itemName");
          print(rentItemDetails);
        });
      });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        tabIndex: 0,
                      )));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("Borrowed Items")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("lend-items")
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BorrowitemDetails(
                                borrowRefId: snapshot
                                    .data!.docChanges[index].doc['itemId'])));
                    print(snapshot.data!.docChanges[index].doc['itemId']);
                  },
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      getRentItemDetails(
                          refId: snapshot.data!.docChanges[index].doc['itemId'])
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
      stream: FirebaseFirestore.instance.collection("rent-items").snapshots(),
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

class getRentItemDetails extends StatefulWidget {
  getRentItemDetails({Key? key, required this.refId}) : super(key: key);

  String refId;

  @override
  State<getRentItemDetails> createState() => _getRentItemDetailsState();
}

class _getRentItemDetailsState extends State<getRentItemDetails> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rent-items")
          .where("postID", isEqualTo: widget.refId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Text("no data!");
        } else {
          String rentItemName = snapshot.data!.docs[0]["itemName"];
          String rentItemDescription =
              snapshot.data!.docs[0]["itemDescription"];
          String rentItemPrice = snapshot.data!.docs[0]['itemPrice'];
          String rentItemQuantity = snapshot.data!.docs[0]['itemQuantity'];
          return Padding(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: ListTile(
                tileColor: HexColor("#E3B13B"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                    side: BorderSide(color: HexColor("#C35E12"))),
                title: Text(rentItemName,
                    style: const TextStyle(fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                // leading: _imageItem(
                //   refId: snapshot
                //       .data!.docChanges[index].doc.reference.id,
                // ),
                subtitle: Text(
                  rentItemDescription,
                  style: const TextStyle(fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "\nPrice: ${rentItemPrice} \nQuantity: ${rentItemQuantity}",
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ));
        }
      },
    );
  }
}
