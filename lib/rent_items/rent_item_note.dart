import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/rent_items/rent_list.dart';
import 'package:rentool/screens/home_screen.dart';

class RentItemThankYouScreen extends StatefulWidget {
  const RentItemThankYouScreen({Key? key}) : super(key: key);

  @override
  State<RentItemThankYouScreen> createState() => _RentItemThankYouScreenState();
}

class _RentItemThankYouScreenState extends State<RentItemThankYouScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 110,
              ),
              const Text(
                "Thank you",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '"Your item is available now for rent"',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Note: The only allowed users for this app are living at Tagum City.',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: HexColor("#C35E12"),
                  child: MaterialButton(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    minWidth: 350,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: false)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LendedItems(
                                        userId: _auth.currentUser!.uid,
                                      )),
                              (route) => route.isFirst);
                    },
                    child: const Text(
                      "Check your Item",
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
    );
  }
}
