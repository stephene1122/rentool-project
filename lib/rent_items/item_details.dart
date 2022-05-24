import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:rentool/model/lend_items_model.dart';
import 'package:rentool/model/rent_items_model.dart';
import 'package:rentool/model/user_model.dart';
import 'package:rentool/rent_items/place_rent.dart';
import 'package:rentool/screens/home_screen.dart';
import '../buildmaterialcolor.dart';

class ItemDetails extends StatefulWidget {
  ItemDetails({Key? key, required this.refId}) : super(key: key);

  // QueryDocumentSnapshot refId;
  // ItemDetails({required this.refId});
  String refId;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  RentItemModel itemDetails = RentItemModel();
  UserModel lenderUser = UserModel();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  // editiing controller
  final lendItemQuantityController = new TextEditingController();
  final lendItemDayController = new TextEditingController();
  final lendSubtotalController = new TextEditingController();
  final lendShippingController = new TextEditingController();
  final lendTotalpaymentController = new TextEditingController();
  final lendItemPriceController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("rent-items")
        .doc(widget.refId)
        .get()
        .then((d1) {
      itemDetails = RentItemModel.fromMap(d1.data());
      setState(() {
        FirebaseFirestore.instance
            .collection("users")
            .doc(itemDetails.uid)
            .get()
            .then((d2) {
          lenderUser = UserModel.fromMap(d2.data());
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // getting the height of the appBar
    double screenHeightMinusAppBarMinusStatusBar =
        MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()))
                  .then((value) {
                setState(() {});
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text("Item Details"),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: screenHeightMinusAppBarMinusStatusBar),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: SizedBox(
                        height: 85,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        )),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: buildMaterialColor(const Color(0xFFE3B13B)),
                          border: Border.all(
                              color:
                                  buildMaterialColor(const Color(0xFFC35E12))),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: buildMaterialColor(
                                        const Color(0xFFE3B13B)),
                                    border: Border.all(
                                        color: buildMaterialColor(
                                            const Color(0xFFC35E12)),
                                        width: 2),
                                  ),
                                  child: Text(
                                    "${itemDetails.itemName}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 150,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: buildMaterialColor(
                                        const Color(0xFFE3B13B)),
                                    border: Border.all(
                                        color: buildMaterialColor(
                                            const Color(0xFFC35E12)),
                                        width: 2),
                                  ),
                                  child: Text(
                                    "${itemDetails.itemDescription}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: buildMaterialColor(
                                        const Color(0xFFE3B13B)),
                                    border: Border.all(
                                        color: buildMaterialColor(
                                            const Color(0xFFC35E12)),
                                        width: 2),
                                  ),
                                  child: Text(
                                    "${lenderUser.fullName}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: buildMaterialColor(
                                              const Color(0xFFE3B13B)),
                                          border: Border.all(
                                              color: buildMaterialColor(
                                                  const Color(0xFFC35E12)),
                                              width: 2),
                                        ),
                                        child: Text(
                                          "${itemDetails.itemQuantity}",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: buildMaterialColor(
                                              const Color(0xFFE3B13B)),
                                          border: Border.all(
                                              color: buildMaterialColor(
                                                  const Color(0xFFC35E12)),
                                              width: 2),
                                        ),
                                        child: Text(
                                          "₱${itemDetails.itemPrice} /Day",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                _imageItem(imageRefId: widget.refId),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: lendItemQuantityController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        textAlign: TextAlign.center,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 1) {
                                            return 'Quantity cannot be empty';
                                          }
                                          if (value == 0 || value == "0") {
                                            return "Quantity cannot be zero";
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Quantity to rent",
                                          contentPadding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color: buildMaterialColor(
                                                      const Color(
                                                          0xFFC35E12)))),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: lendItemDayController,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 1) {
                                            return 'Days cannot be empty';
                                          }
                                          if (value == 0 || value == "0") {
                                            return "Day cannot be zero";
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Days to rent",
                                          contentPadding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color: buildMaterialColor(
                                                      const Color(
                                                          0xFFC35E12)))),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(30),
                                    color: HexColor("#C35E12"),
                                    child: MaterialButton(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 20, 5),
                                      minWidth: 350,
                                      onPressed: () {
                                        postLendedItem();
                                      },
                                      child: const Text(
                                        "Rent Now",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void postLendedItem() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;

      LendItemModel lendedModel = LendItemModel();

      // calculation
      num price = int.parse(itemDetails.itemPrice!);
      num a = int.parse(lendItemDayController.text);
      num b = int.parse(lendItemQuantityController.text);
      num dayPrice = price * a;
      num c = dayPrice * b;
      num d = 10;
      num e = c + d;
      num f = int.parse(itemDetails.itemQuantity!);
      num g = f - b;
      lendSubtotalController.text = c.toString();
      lendShippingController.text = d.toString();
      lendTotalpaymentController.text = e.toString();

      // writing all the values
      lendedModel.uid = lendedModel.itemId = user!.uid;
      lendedModel.itemId = widget.refId;
      lendedModel.lendItemQuantity = lendItemQuantityController.text;
      lendedModel.dayLended = lendItemDayController.text;
      lendedModel.subtotalPayment = lendSubtotalController.text;
      lendedModel.shippingPayment = lendShippingController.text;
      lendedModel.totalPayment = lendTotalpaymentController.text;

      // updating rent-items/itemQuantity
      await firebaseFirestore
          .collection("rent-items")
          .doc("${widget.refId}")
          .update({
        "itemQuantity": g.toString(),
      });

      // saving data into lend-items collection
      await firebaseFirestore
          .collection("lend-items")
          .add(lendedModel.toMap())
          .then((value) {
        Navigator.push(
            (context),
            MaterialPageRoute(
                builder: (context) => PlaceRentDetails(
                    refId: value.id,
                    rentItemsRefId: widget.refId,
                    rentItemQuantity: g)));
      });

      Fluttertoast.showToast(msg: "created");
    }
  }
}

// class _itemField extends StatelessWidget {
//   _itemField({Key? key, this.fieldName}) : super(key: key);

//   String? fieldName;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: buildMaterialColor(const Color(0xFFE3B13B)),
//         border: Border.all(
//             color: buildMaterialColor(const Color(0xFFC35E12)), width: 2),
//       ),
//       alignment: Alignment.center,
//       width: 350,
//       padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       child: Text("${fieldName}"),
//     );
//   }
// }

// class _itemFieldSmall extends StatelessWidget {
//   _itemFieldSmall({Key? key, this.fieldNameSmall}) : super(key: key);
//   String? fieldNameSmall;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: buildMaterialColor(const Color(0xFFE3B13B)),
//         border: Border.all(
//             color: buildMaterialColor(const Color(0xFFC35E12)), width: 2),
//       ),
//       alignment: Alignment.center,
//       width: 150,
//       padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       child: Text("${fieldNameSmall}"),
//     );
//   }
// }

// class _customTextfield extends StatelessWidget {
//   _customTextfield({Key? key, this.fieldName}) : super(key: key);

//   String? fieldName;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: buildMaterialColor(const Color(0xFFE3B13B)),
//         border: Border.all(
//             color: buildMaterialColor(const Color(0xFFC35E12)), width: 2),
//       ),
//       alignment: Alignment.center,
//       width: 150,
//       padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//             hintText: "${fieldName}", border: OutlineInputBorder()),
//       ),
//     );
//   }
// }

// class _customRow extends StatelessWidget {
//   const _customRow({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Column(
//           children: [
//             TextFormField(
//               textAlign: TextAlign.center,
//               readOnly: true,
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.only(top: 5, bottom: 5),
//                 border:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
//                 focusColor: buildMaterialColor(const Color(0xFFC35E12)),
//               ),
//               initialValue: "Item Name",
//             ),
//           ],
//         ),
//         Column(
//           children: [],
//         )
//       ],
//     );
//   }
// }

class _imageItem extends StatelessWidget {
  _imageItem({Key? key, this.imageRefId}) : super(key: key);

  String? imageRefId;

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
              height: 80,
              width: 80,
              child: Image.asset("assets/square-album.png"));
        } else {
          String url = snapshot.data!.docs[0]["downloadURL"];
          return Container(
              height: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: buildMaterialColor(const Color(0xFFE3B13B)),
                border: Border.all(
                    color: buildMaterialColor(const Color(0xFFC35E12)),
                    width: 2),
              ),
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ));
        }
      },
    );
  }
}
