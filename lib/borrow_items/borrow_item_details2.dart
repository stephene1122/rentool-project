import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentool/buildmaterialcolor.dart';
import 'package:rentool/chat/chatpage.dart';
import 'package:rentool/model/lend_items_model.dart';
import 'package:rentool/model/notifications_model.dart';
import 'package:rentool/model/rent_items_model.dart';
import 'package:rentool/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rentool/screens/home_screen.dart';
import 'package:rentool/screens/home_screen_default.dart';
import 'package:rentool/screens/navigation_bar.dart';

import '../services/check_token_notification.dart';

class BorrowitemDetails2 extends StatefulWidget {
  BorrowitemDetails2({Key? key, required this.rentItemId, required this.lendId})
      : super(key: key);

  String rentItemId;
  String lendId;

  @override
  State<BorrowitemDetails2> createState() => _BorrowitemDetails2State();
}

class _BorrowitemDetails2State extends State<BorrowitemDetails2> {
  double rating = 0;
  String? nToken;
  String? aUid;
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  RentItemModel rentItemDetails = RentItemModel();
  LendItemModel lendItemDetails = LendItemModel();
  UserModel lenderDetails = UserModel();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController dayLendedController = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();
  TextEditingController lendItemQuantityController = TextEditingController();
  TextEditingController lendMessageController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController rentPeriodController = TextEditingController();
  TextEditingController shippingPaymentController = TextEditingController();
  TextEditingController subtotalPaymentController = TextEditingController();
  TextEditingController totalPaymentController = TextEditingController();
  TextEditingController extendRentDayController = TextEditingController();

  // some initialization
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  // image picker gallery
  Future imagePickerMethod(ImageSource sourceType) async {
    try {
      // picking the file
      final pick = await imagePicker.pickImage(source: sourceType);

      setState(() {
        if (pick != null) {
          _image = File(pick.path);
        } else {
          // showing a snackbar error
          showSnackBar("No file selected", const Duration(milliseconds: 400));
        }
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future uploadImage() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${_auth.currentUser!.uid}/images/rental_items")
        .child("post_$postID");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();

    // uploading to cloudfirestore
    await firebaseFirestore
        .collection("rent-items")
        .doc(widget.rentItemId)
        .collection("images")
        .add({
      'downloadURL': downloadURL,
      'dateCreated': DateTime.now(),
    }).whenComplete(() => showSnackBar(
            "Item created successfully", const Duration(seconds: 2)));
  }

  // snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildRating() => RatingBar.builder(
        minRating: 1,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) => setState(() {
          this.rating = rating;
          print(rating);
        }),
        updateOnDrag: true,
      );

  void showRating() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text("Rate This Item"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Please leave a star rating.",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                const SizedBox(
                  height: 32,
                ),
                buildRating(),
              ],
            ),
            actions: [
              TextButton(
                  child: const Text(
                    "Ok",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    var cRating = num.parse(rentItemDetails.ratings!);
                    var computeRating = cRating + rating;

                    // adding total ratings
                    await FirebaseFirestore.instance
                        .collection("rent-items")
                        .doc(lendItemDetails.itemId)
                        .update(
                      {
                        "ratings": computeRating.toString(),
                      },
                    );
                    // adding item rate
                    await FirebaseFirestore.instance
                        .collection("rent-items")
                        .doc(lendItemDetails.itemId)
                        .collection("rating")
                        .add(
                      {
                        "itemRate": rating.toString(),
                        "uid": _auth.currentUser!.uid.toString(),
                      },
                    ).then((value) async {
                      await FirebaseFirestore.instance
                          .collection("rent-items")
                          .doc(lendItemDetails.itemId)
                          .collection("rating")
                          .doc(value.id)
                          .update(
                        {
                          "id": value.id,
                        },
                      );
                    });
                    // creating notification for the lender
                    await FirebaseFirestore.instance
                        .collection("notifications")
                        .add({
                      "title": "Return Item",
                      "body": "Get your item from the borrower",
                      "from": _auth.currentUser!.uid.toString(),
                      "to": rentItemDetails.uid.toString(),
                      "lend-item-id": lendItemDetails.id.toString(),
                      "typeId": 6
                    }).then(
                      (value) async {
                        await FirebaseFirestore.instance
                            .collection("notifications")
                            .doc(value.id)
                            .update({"id": value.id.toString()});
                        Navigator.pop(context);
                      },
                    );
                  }),
            ]),
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("rent-items")
        .doc(widget.rentItemId)
        .get()
        .then((value) {
      rentItemDetails = RentItemModel.fromMap(value.data());
      setState(() {
        //rent item details
        itemNameController =
            TextEditingController(text: rentItemDetails.itemName);
        itemDescriptionController =
            TextEditingController(text: rentItemDetails.itemDescription);
        itemPriceController =
            TextEditingController(text: rentItemDetails.itemPrice);
        itemQuantityController =
            TextEditingController(text: rentItemDetails.itemQuantity);
        //getLenderDetails
        FirebaseFirestore.instance
            .collection("users")
            .doc(rentItemDetails.uid)
            .get()
            .then((value) {
          lenderDetails = UserModel.fromMap(value.data());
          setState(() {});
        });
      });
    });
    FirebaseFirestore.instance
        .collection("lend-items")
        .doc(widget.lendId)
        .get()
        .then((d) {
      lendItemDetails = LendItemModel.fromMap(d.data());
      setState(() {
        dayLendedController =
            TextEditingController(text: lendItemDetails.dayLended);
        deliveryAddressController =
            TextEditingController(text: lendItemDetails.deliveryAddress);
        lendItemQuantityController =
            TextEditingController(text: lendItemDetails.lendItemQuantity);
        lendMessageController =
            TextEditingController(text: lendItemDetails.lendMessage);
        paymentMethodController =
            TextEditingController(text: lendItemDetails.paymentMethod);
        rentPeriodController =
            TextEditingController(text: lendItemDetails.rentPeriod);
        shippingPaymentController =
            TextEditingController(text: lendItemDetails.shippingPayment);
        subtotalPaymentController =
            TextEditingController(text: lendItemDetails.subtotalPayment);
        totalPaymentController =
            TextEditingController(text: lendItemDetails.totalPayment);
      });
    });
    // notification for extended duration
    getFirebaseToken();
    // NotificationToken().getAdminToken().then((QuerySnapshot d) {
    //   aToken = d.docs[0]['nToken'];
    //   aUid = d.docs[0]['uid'];
    //   print(aToken);
    //   print(aUid);
    // });
  }

  void getFirebaseToken() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(lendItemDetails.lenderUid)
        .get();
    String token = snap['nToken'];
    nToken = token;
    print(token);
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAARiLOifY:APA91bHzJcIGhL3JSn7HL03yOUS1m-oIH6vvLG1uEr9rBfpacTyH9ldYR5RmhrlioIXNZQ74JTxav8kzrw7gJNCwF6tV5AzLQe-h3wl5MBH9LMOhip7TfXRCClsD_oN8j5mh9rv8cE35',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{'body': body, 'title': title},
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to': token,
            },
          ));
    } catch (e) {
      print('error push notification ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateDateExpire(int xday) async {
      // rent period calculation
      DateTime cDateFrom = DateTime.parse(lendItemDetails.rentPeriodFrom!);
      var extendedDate = cDateFrom.add(Duration(days: xday));
      var dateFromFormat = DateFormat().format(cDateFrom);
      var dateToFormat = DateFormat().format(extendedDate);

      await FirebaseFirestore.instance
          .collection("lend-items")
          .doc(widget.lendId)
          .update({
        "rentPeriodTo": "${extendedDate}",
        "rentCountDown": "${extendedDate}",
        "rentPeriod": "${dateFromFormat} to ${dateToFormat}",
      });
    }

    void borrowerExtendNotification(int xday) async {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      NotificationModel notifModel = NotificationModel();

      String title = "Rent Extended!";
      String body = "Borrower extended the rent by ${xday} day.";

      // writing all values
      notifModel.title = title;
      notifModel.body = body;
      notifModel.from = lendItemDetails.uid;
      notifModel.to = lendItemDetails.lenderUid;
      notifModel.typeId = 7;

      await firebaseFirestore
          .collection("notifications")
          .add(notifModel.toMap());

      // send notification on phone
      sendPushMessage(nToken!, body, title);
    }

    // item name field
    final itemNameField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: itemNameController,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Name",
            labelStyle: const TextStyle(fontSize: 20)));

    // item description field
    final itemDescriptionField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: itemDescriptionController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Description",
            labelStyle: const TextStyle(fontSize: 20)));

    // item Price field
    final itemPriceField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: itemPriceController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Price",
            labelStyle: const TextStyle(fontSize: 20)));

    // item quantity field
    final itemQuantityField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: itemQuantityController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Quantity",
            labelStyle: const TextStyle(fontSize: 20)));

    // item name field
    final dayLendedField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: dayLendedController,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Rent Days",
            labelStyle: const TextStyle(fontSize: 20)));

    // item name field
    final deliveryAddressField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: deliveryAddressController,
        keyboardType: TextInputType.name,
        maxLines: null,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Delivery Address",
            labelStyle: const TextStyle(fontSize: 20)));

    // item name field
    final lendItemQuantityField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: lendItemQuantityController,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(Color(0xFFC35E12)), width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Item Borrowed Quantity",
            labelStyle: const TextStyle(fontSize: 20)));

    // item description field
    final lendMessageField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: lendMessageController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Additional Message",
            labelStyle: const TextStyle(fontSize: 20)));

    // item Price field
    final paymentMethodField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: paymentMethodController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Payment Method",
            labelStyle: const TextStyle(fontSize: 20)));

    // item quantity field
    final rentPeriodField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: rentPeriodController,
        keyboardType: TextInputType.number,
        maxLines: null,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Rent Period",
            labelStyle: const TextStyle(fontSize: 20)));

    // item quantity field
    final shippingPaymentField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: shippingPaymentController,
        keyboardType: TextInputType.number,
        maxLines: null,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Shipping Payment",
            labelStyle: const TextStyle(fontSize: 20)));

    // item quantity field
    final subtotalPaymentField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: subtotalPaymentController,
        keyboardType: TextInputType.number,
        maxLines: null,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Subtotal Payment",
            labelStyle: const TextStyle(fontSize: 20)));

    // item quantity field
    final totalPaymentField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: totalPaymentController,
        keyboardType: TextInputType.number,
        maxLines: null,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: buildMaterialColor(const Color(0xFFC35E12)),
                  width: 2.0),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Total Payment",
            labelStyle: const TextStyle(fontSize: 20)));

    // gellery btn
    final galleryBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            imagePickerMethod(ImageSource.gallery);
          },
          child: const Text(
            "Choose from album",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // camera btn
    final contactLender = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            Navigator.push(
                (context),
                MaterialPageRoute(
                    builder: (context) => chatpage(
                          friendUid: rentItemDetails.uid,
                          friendEmail: lenderDetails.emailAddress,
                          friendName: lenderDetails.fullName,
                        )));
            print(lenderDetails.fullName);
          },
          child: const Text(
            "Contact Lender",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // returnItem button
    final returnItem = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(6),
        color: HexColor("#E91B1B"),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Are you sure to return this item?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () async {
                              // update the for rent item quantity
                              // var lendedItemQuantity =
                              //     int.parse(lendItemDetails.lendItemQuantity!);
                              // var cRentItemQuantity =
                              //     int.parse(rentItemDetails.itemQuantity!);
                              // var com = lendedItemQuantity + cRentItemQuantity;
                              // await FirebaseFirestore.instance
                              //     .collection("rent-items")
                              //     .doc(lendItemDetails.itemId)
                              //     .update({
                              //   "itemQuantity": com.toString(),
                              // });

                              // update lend-items status into expired to notify the lender
                              await FirebaseFirestore.instance
                                  .collection("lend-items")
                                  .doc(lendItemDetails.id)
                                  .update({"status": "expired"});
                              Navigator.pop(context);
                              showRating();
                            },
                            child: const Text("Ok"))
                      ],
                    ));
          },
          child: const Text(
            "Return Item",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // extendRent button
    final extendRentDayBtn = // Delete button
        Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(6),
            color: Colors.blue,
            child: MaterialButton(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: 265,
              onPressed: () {
                // widget.docId.reference.delete().whenComplete(() {
                //   Navigator.pushReplacement(context,
                //       MaterialPageRoute(builder: (context) => LendedItems()));
                // });

                // validation
                if (extendRentDayController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Please, input a number"),
                            actions: [
                              TextButton(
                                  onPressed: () => {Navigator.pop(context)},
                                  child: const Text("Ok")),
                            ],
                          ));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                                "Are you sure to extend the rent of this item?"),
                            actions: [
                              TextButton(
                                  onPressed: () => {Navigator.pop(context)},
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () async {
                                    if (lendItemDetails.extendedDay == "0") {
                                      // Day rent extended + Day rent current
                                      var currentDaylended =
                                          int.parse(lendItemDetails.dayLended!);
                                      var addDay = int.parse(
                                          extendRentDayController.text);
                                      var extendDay = currentDaylended + addDay;
                                      var itemPrice =
                                          int.parse(rentItemDetails.itemPrice!);
                                      var extendPrice = itemPrice * addDay + 10;
                                      var cExtendDay = int.parse(
                                          lendItemDetails.extendedDay!);
                                      var extendedDay = cExtendDay + addDay;

                                      await FirebaseFirestore.instance
                                          .collection("lend-items")
                                          .doc(widget.lendId)
                                          .update({
                                        "dayLended": "${extendDay}",
                                        "extendPrice": "${extendPrice}",
                                        "serviceFee": "10",
                                        "extendedDay": "${extendedDay}",
                                      });
                                      // update day return date of the item
                                      updateDateExpire(extendDay);
                                      // send notification to lender for rent extended by borrower
                                      borrowerExtendNotification(addDay);
                                      Navigator.pop(context);
                                      // new alert
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(
                                                      "ADDITIONAL PAYMENT\nService Fee: 10\nDay Extended: ${addDay} day\nItem Price: ${rentItemDetails.itemPrice}\nTotal: ${extendPrice} payment"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        title: const Text(
                                                                            "Day Extended!, Thank you"),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () => {
                                                                                    Navigator.pop(context)
                                                                                  },
                                                                              child: const Text("Ok")),
                                                                        ],
                                                                      ));
                                                        },
                                                        child:
                                                            const Text("Ok")),
                                                  ],
                                                ));
                                      });
                                    } else {
                                      // Day rent extended + Day rent current
                                      var currentDaylended =
                                          int.parse(lendItemDetails.dayLended!);
                                      var addDay = int.parse(
                                          extendRentDayController.text);
                                      var extendDay = currentDaylended + addDay;
                                      var cExtendDay = int.parse(
                                          lendItemDetails.extendedDay!);
                                      var extendedDay = cExtendDay + addDay;
                                      var itemPrice =
                                          int.parse(rentItemDetails.itemPrice!);
                                      var extendPrice =
                                          itemPrice * extendedDay + 10;

                                      await FirebaseFirestore.instance
                                          .collection("lend-items")
                                          .doc(widget.lendId)
                                          .update({
                                        "dayLended": "${extendDay}",
                                        "extendPrice": "${extendPrice}",
                                        "serviceFee": "10",
                                        "extendedDay": "${extendedDay}",
                                      });
                                      // update day return date of the item
                                      updateDateExpire(extendDay);
                                      // send notification to lender for rent extended by borrower
                                      borrowerExtendNotification(addDay);
                                      Navigator.pop(context);
                                      // new alert
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(
                                                      "ADDITIONAL PAYMENT\nService Fee: 10\nDay Extended: ${addDay} day\nItem Price: ${rentItemDetails.itemPrice}\nTotal: ${extendPrice} payment"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        title: const Text(
                                                                            "Day Extended!, Thank you"),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () => {
                                                                                    Navigator.pop(context)
                                                                                  },
                                                                              child: const Text("Ok")),
                                                                        ],
                                                                      ));
                                                        },
                                                        child:
                                                            const Text("Ok")),
                                                  ],
                                                ));
                                      });
                                    }
                                  },
                                  child: const Text("Ok"))
                            ],
                          ));
                }
              },
              child: const Text(
                "Extend",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ));

    // return timer
    final returnTimerField = CountDownText(
      due: DateTime.parse("${lendItemDetails.rentCountDown}"),
      finishedText: "Done",
      showLabel: true,
      longDateName: true,
      daysTextLong: " d : ",
      hoursTextLong: " hr : ",
      minutesTextLong: " min : ",
      secondsTextLong: " sec ",
      style: const TextStyle(color: Colors.red, fontSize: 18),
    );

    // extend rent days field
    final extendRentDayField = TextFormField(
        autofocus: false,
        controller: extendRentDayController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        maxLines: null,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0)),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: "Day",
            hintText: "Input the days to extend",
            labelStyle: const TextStyle(fontSize: 20, color: Colors.blue)));

    return Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Borrowed Item Details2",
          ),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              // passing this to our root
              onPressed: () {
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (context) => NavigationBarScreen(
                //           tabIndex: 2,
                //         )));
                Navigator.pop(context);
              }),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(
                        //     child: Text(
                        //   'Lender: ${lenderDetails.fullName}',
                        //   style: TextStyle(
                        //     fontSize: 22,
                        //   ),
                        // )),
                        // SizedBox(
                        //   height: 25,
                        // ),
                        itemNameField,
                        const SizedBox(
                          height: 15,
                        ),
                        itemDescriptionField,
                        const SizedBox(
                          height: 15,
                        ),
                        itemPriceField,
                        const SizedBox(
                          height: 15,
                        ),
                        itemQuantityField,
                        const SizedBox(
                          height: 15,
                        ),
                        dayLendedField,
                        const SizedBox(
                          height: 15,
                        ),
                        deliveryAddressField,
                        const SizedBox(
                          height: 15,
                        ),
                        lendItemQuantityField,
                        const SizedBox(
                          height: 15,
                        ),
                        lendMessageField,
                        const SizedBox(
                          height: 15,
                        ),
                        paymentMethodField,
                        const SizedBox(
                          height: 15,
                        ),
                        rentPeriodField,
                        const SizedBox(
                          height: 15,
                        ),
                        shippingPaymentField,
                        const SizedBox(
                          height: 15,
                        ),
                        subtotalPaymentField,
                        const SizedBox(
                          height: 15,
                        ),
                        totalPaymentField,
                        const SizedBox(
                          height: 25,
                        ),
                        _image != null
                            ? Image.file(_image!)
                            : _imageItem(refId: widget.rentItemId),
                        const SizedBox(
                          height: 40,
                        ),
                        const SizedBox(
                          height: 20,
                          child: Text(
                            "RETURN ITEM COUNTDOWN",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        returnTimerField,
                        const SizedBox(
                          height: 40,
                        ),
                        (lendItemDetails.extendedDay != "0")
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Extended Rent Payment",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Service fee: ₱${lendItemDetails.serviceFee}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Additional Day: ${lendItemDetails.extendedDay} day",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Item Price: ₱${rentItemDetails.itemPrice}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Total: (${rentItemDetails.itemPrice} * ${lendItemDetails.extendedDay}) + ${lendItemDetails.serviceFee} = ₱${lendItemDetails.extendPrice}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                ],
                              )
                            : const Text("EXTEND RENT DURATION",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 265,
                          child: extendRentDayField,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        extendRentDayBtn,
                        const SizedBox(
                          height: 10,
                        ),
                        returnItem,
                        const SizedBox(
                          height: 15,
                        ),
                        contactLender
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}

class _imageItem extends StatelessWidget {
  _imageItem({Key? key, required this.refId}) : super(key: key);

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
              height: 60,
              width: 60,
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
                  child: Image.network(
                url,
                fit: BoxFit.contain,
              )));
        }
      },
    );
  }
}
