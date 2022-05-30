import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/chat/chatpage.dart';
import 'package:rentool/screens/home_screen.dart';
import 'package:rentool/screens/lend_items_screen.dart';

class ContactLender extends StatefulWidget {
  ContactLender({Key? key, this.lenderUid, this.lenderEmail, this.lenderName})
      : super(key: key);
  String? lenderUid;
  String? lenderEmail;
  String? lenderName;
  @override
  State<ContactLender> createState() => _ContactLenderState();
}

class _ContactLenderState extends State<ContactLender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
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
                height: 150,
              ),
              const Text("Thank you, your order has been process."),
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
                      Navigator.push(
                          (context),
                          MaterialPageRoute(
                              builder: (context) => chatpage(
                                    friendUid: widget.lenderUid,
                                    friendEmail: widget.lenderEmail,
                                    friendName: widget.lenderName,
                                  )));
                    },
                    child: const Text(
                      "Contact Lender",
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
