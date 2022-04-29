import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/screens/login_screen.dart';

class RegistrationScreenNotif extends StatefulWidget {
  const RegistrationScreenNotif({Key? key}) : super(key: key);

  @override
  State<RegistrationScreenNotif> createState() =>
      _RegistrationScreenNotifState();
}

class _RegistrationScreenNotifState extends State<RegistrationScreenNotif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Almost Done")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 110,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Your almost done!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "We will validate your account and will notify you at the email address you've provided",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                "Note: The only allowed users for this app are living at Tagum City and wait for several time for us to validate your profile thank you",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              SizedBox(
                height: 35,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => LoginScreen()));
                  logout(context);
                },
                child: Text(
                  "Click here to process",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: HexColor("#C35E12")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
