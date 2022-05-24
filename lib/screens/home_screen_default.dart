import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/rent_items/add_rent.dart';
import 'package:rentool/rent_items/rent_list.dart';

import '../imageupload/registration_upload_validid.dart';
import '../model/user_model.dart';
import 'login_screen.dart';

class HomeScreenDefault extends StatefulWidget {
  const HomeScreenDefault({Key? key}) : super(key: key);

  @override
  State<HomeScreenDefault> createState() => _HomeScreenDefaultState();
}

class _HomeScreenDefaultState extends State<HomeScreenDefault> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

// Stream for the users images
  Stream<QuerySnapshot> getUserSelfieStreamSnapshot(
      BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection("users")
        .doc(loggedInUser.uid)
        .collection("images-user-selfie")
        .snapshots();
  }

  final Stream<QuerySnapshot> usersSelfie = FirebaseFirestore.instance
      .collection("users")
      .doc()
      .collection("images-user-selfie")
      .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Borrowed Items btn
    final borrowedItemsBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(6),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             UploadValidId(userId: loggedInUser.uid)));
          },
          child: const Text(
            "Borrowed Items",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // Lended Items btn
    final lendedItemsBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(6),
        color: HexColor("#C35E12"),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 265,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LendedItems(userId: loggedInUser.uid)));
          },
          child: const Text(
            "Lended Items",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));

    // get selfie image url
    final userImage = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(loggedInUser.uid)
          .collection("images-user-selfie")
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80, child: Image.asset("assets/square-image.png"));
        } else {
          String url = snapshot.data!.docs[0]['downloadURL'];
          return CircleAvatar(
            radius: 100 / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: NetworkImage(url),
          );
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appBar(),
      floatingActionButton: buildRentalButton(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(
                height: 20,
              ),
              Text(
                "Good Day, ${loggedInUser.fullName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              // StreamBuilder<QuerySnapshot>(
              //   stream: usersSelfie,
              //   builder: (
              //     BuildContext context,
              //     AsyncSnapshot<QuerySnapshot> snapshot,
              //   ) {
              //     if (snapshot.hasError) {
              //       return Text("Something went wrong!");
              //     }
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Text("Loading");
              //     }
              //     final data = snapshot.requireData;
              //     return ListView.builder(
              //       itemCount: data.size,
              //       itemBuilder: (context, index) {
              //         String url = data.docs[index]['downloadURL'];
              //         return Text(url);
              //       },
              //     );
              //   },
              // ),
              userImage,
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              borrowedItemsBtn,
              const SizedBox(
                height: 15,
              ),
              lendedItemsBtn,
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRentalButton() => FloatingActionButton.extended(
        label: const Text("Rental"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LendedItems(userId: loggedInUser.uid)));
        },
        icon: const Icon(Icons.construction_rounded),
        backgroundColor: HexColor("#E4B43D"),
      );

  // logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  _appBar() {
    // getting the height of our appbar
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
