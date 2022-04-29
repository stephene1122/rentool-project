import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LendedItems extends StatefulWidget {
  LendedItems({Key? key, this.userId}) : super(key: key);
  String? userId;

  @override
  State<LendedItems> createState() => _LendedItemsState();
}

class _LendedItemsState extends State<LendedItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: HexColor("#C35E12"),
              ),
              // passing this to our root
              onPressed: () {
                Navigator.of(context).pop();
              })),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("rent-items")
              .doc()
              .collection("images")
              .where("uid" == "YBvqnLLzVcXFVgKMqlp266m8yCH3")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return (const Center(
                child: Text("No Data Found"),
              ));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String rentItems =
                        snapshot.data!.docs[index]['downloadURL'];
                    return Image.network(
                      rentItems,
                      height: 160,
                      fit: BoxFit.cover,
                    );
                  });
            }
          }),
    );
  }
}
