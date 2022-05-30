import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/model/lend_items_model.dart';
import 'package:rentool/model/rent_items_model.dart';
import 'package:rentool/model/user_model.dart';
import 'package:rentool/rent_items/contact_lender.dart';
import '../buildmaterialcolor.dart';

class PlaceRentDetails extends StatefulWidget {
  PlaceRentDetails(
      {Key? key,
      this.refId,
      this.rentItemsRefId,
      this.rentItemQuantity,
      this.lenderUid})
      : super(key: key);

  // QueryDocumentSnapshot refId;
  // PlaceRentDetails({required this.refId});
  String? refId;
  String? rentItemsRefId;
  num? rentItemQuantity;
  String? lenderUid;

  @override
  State<PlaceRentDetails> createState() => _PlaceRentDetailsState();
}

class _PlaceRentDetailsState extends State<PlaceRentDetails> {
  LendItemModel lendedItemDetails = LendItemModel();
  UserModel lenderDetails = UserModel();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  // editiing controller
  final lendItemDeliveryAddressController = new TextEditingController();
  final lendItemMessageLenderController = new TextEditingController();
  final lendItemPaymentMethodController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("lend-items")
        .doc(widget.refId)
        .get()
        .then((d1) {
      lendedItemDetails = LendItemModel.fromMap(d1.data());
      setState(() {
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.lenderUid)
            .get()
            .then((d2) {
          lenderDetails = UserModel.fromMap(d2.data());
          setState(() {});
        });
      });
    });
    lendItemPaymentMethodController.text = "COD / Cash on delivery";
  }

  @override
  Widget build(BuildContext context) {
    // getting the height of the appBar
    double screenHeightMinusAppBarMinusStatusBar =
        MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top;

    final List<String> paymentMethodItems = [
      'COD',
      'GCash',
    ];

    final paymentMethodField = DropdownButtonFormField2(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
        ),
        hintText: "Payment Method",
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: paymentMethodItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'PaymentMethod cannot be empty';
        }
      },
      onChanged: (String? newValue) {
        // update data when value change
        setState(() {
          lendItemPaymentMethodController.text = newValue.toString();
        });
      },
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            num a = widget.rentItemQuantity!;
            num b = int.parse(lendedItemDetails.lendItemQuantity!);
            num c = a + b;
            c.toInt();
            await FirebaseFirestore.instance
                .collection('rent-items')
                .doc(widget.rentItemsRefId)
                .update({"itemQuantity": c.toString()});
            await FirebaseFirestore.instance
                .collection('lend-items')
                .doc(widget.refId)
                .delete();

            Navigator.of(context).pop();
          },
        ),
        title: const Text("Rent Details"),
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
                                TextFormField(
                                  controller: lendItemDeliveryAddressController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  textAlign: TextAlign.center,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 1) {
                                      return 'Delivery cannot be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Delivery Address",
                                    contentPadding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: buildMaterialColor(
                                                const Color(0xFFC35E12)))),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  maxLines: 7,
                                  controller: lendItemMessageLenderController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "Message Lender(Optional)",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: buildMaterialColor(
                                                const Color(0xFFC35E12)))),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: lendItemPaymentMethodController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  textAlign: TextAlign.center,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 1) {
                                      return 'Payment Method cannot be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Payment Method",
                                    contentPadding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: buildMaterialColor(
                                                const Color(0xFFC35E12)))),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: buildMaterialColor(
                                        const Color(0xFFE3B13B)),
                                    border: Border.all(
                                        width: 2,
                                        color: buildMaterialColor(
                                            const Color(0xFFC35E12))),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Rent Subtotal: ₱${lendedItemDetails.subtotalPayment}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Shipping Payment: ₱${lendedItemDetails.shippingPayment}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Total Payment: ₱${lendedItemDetails.totalPayment}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
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
                                        postLendedItem(
                                            lenderDetails.uid,
                                            lenderDetails.emailAddress,
                                            lenderDetails.fullName);
                                      },
                                      child: const Text(
                                        "Place Order",
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

  void postLendedItem(String? uid, String? email, String? name) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    LendItemModel lendedModel = LendItemModel();

    // writing all the values
    lendedModel.deliveryAddress = lendItemDeliveryAddressController.text;
    lendedModel.lendMessage = lendItemMessageLenderController.text;
    lendedModel.paymentMethod = lendItemPaymentMethodController.text;
    // lendedModel.subtotalPayment = lendSubtotalController.text;
    // lendedModel.shippingPayment = lendShippingController.text;
    // lendedModel.totalPayment = lendTotalpaymentController.text;

    await firebaseFirestore.collection("lend-items").doc(widget.refId).update({
      "deliveryAddress": lendItemDeliveryAddressController.text,
      "lendMessage": lendItemMessageLenderController.text,
      "paymentMethod": lendItemPaymentMethodController.text,
    });
    Fluttertoast.showToast(msg: "created");
    Navigator.push(
        (context),
        MaterialPageRoute(
            builder: (context) => ContactLender(
                  lenderUid: uid,
                  lenderEmail: email,
                  lenderName: name,
                )));
  }
}
