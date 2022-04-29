import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/imageupload/registration_upload_validid.dart';
import 'package:rentool/model/user_model.dart';
import 'package:rentool/screens/home_screen_default.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: HexColor("#E4B43D"),
          activeColor: HexColor("#C35E12"),
          inactiveColor: Colors.white,
          onTap: (index) {
            print("Clicked Tab $index");
          },
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(CupertinoIcons.home),
            ),
            BottomNavigationBarItem(
              label: 'Chat',
              icon: Icon(CupertinoIcons.conversation_bubble),
            ),
            BottomNavigationBarItem(
              label: 'Notification',
              icon: Icon(CupertinoIcons.bell_circle),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(CupertinoIcons.person),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 1:
              return SizedBox(
                child: Text("Page 2"),
              );
            case 2:
              return SizedBox(
                child: Text("Page 3"),
              );
            case 3:
              return SizedBox(
                child: Text("Page 4"),
              );
            case 0:
            default:
              return HomeScreenDefault();
          }
        },
      );

  // {
  //   // Borrowed Items btn
  //   final borrowedItemsBtn = Material(
  //       elevation: 5,
  //       borderRadius: BorderRadius.circular(6),
  //       color: HexColor("#C35E12"),
  //       child: MaterialButton(
  //         padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
  //         minWidth: 265,
  //         onPressed: () {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) =>
  //                       UploadValidId(userId: loggedInUser.uid)));
  //         },
  //         child: Text(
  //           "Borrowed Items",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //               fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
  //         ),
  //       ));

  //   // Lended Items btn
  //   final lendedItemsBtn = Material(
  //       elevation: 5,
  //       borderRadius: BorderRadius.circular(6),
  //       color: HexColor("#C35E12"),
  //       child: MaterialButton(
  //         padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
  //         minWidth: 265,
  //         onPressed: () {
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => UploadValidId()));
  //         },
  //         child: Text(
  //           "Lended Items",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //               fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
  //         ),
  //       ));

  //   final userImage = StreamBuilder(
  //     stream: FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(loggedInUser.uid)
  //         .collection("images")
  //         .snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (!snapshot.hasData) {
  //         return SizedBox(
  //             height: 80, child: Image.asset("assets/square-image.png"));
  //       } else {
  //         return ListView.builder(
  //             itemCount: snapshot.data!.docs.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               String url = snapshot.data!.docs[index]['downloadURL'];
  //               return Image.network(
  //                 url,
  //                 height: 80,
  //                 fit: BoxFit.cover,
  //               );
  //             });
  //       }
  //     },
  //   );

  //   return Scaffold(
  //     appBar: _appBar(),
  //     body: Center(
  //       child: Padding(
  //         padding: EdgeInsets.all(20),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             SizedBox(
  //               height: 110,
  //               child: Image.asset(
  //                 "assets/logo.png",
  //                 fit: BoxFit.contain,
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             Text(
  //               "Good Day, ${loggedInUser.fullName}",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(
  //               height: 25,
  //             ),
  //             SizedBox(
  //                 height: 80, child: Image.asset("assets/square-image.png")),
  //             SizedBox(
  //               height: 15,
  //             ),
  //             SizedBox(
  //               height: 15,
  //             ),
  //             borrowedItemsBtn,
  //             SizedBox(
  //               height: 15,
  //             ),
  //             lendedItemsBtn,
  //             SizedBox(
  //               height: 15,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              icon: Icon(Icons.logout),
            )
          ],
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}

// taking the URL and returning dynamic image type
class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String Image) async {
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}
