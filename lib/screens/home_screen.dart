// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:rentool/chat/recent_chat_people.dart';
// import 'package:rentool/model/user_model.dart';
// import 'package:rentool/screens/home_screen_default.dart';
// import 'package:rentool/screens/lend_items_screen.dart';
// import 'package:rentool/screens/notification_screen.dart';

// class HomeScreen extends StatefulWidget {
//   HomeScreen({Key? key, this.tabIndex}) : super(key: key);

//   var tabIndex;

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   User? user = FirebaseAuth.instance.currentUser;
//   UserModel loggedInUser = UserModel();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(user!.uid)
//         .get()
//         .then((value) {
//       this.loggedInUser = UserModel.fromMap(value.data());
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) => CupertinoTabScaffold(
//         tabBar: CupertinoTabBar(
//           backgroundColor: HexColor("#E4B43D"),
//           activeColor: HexColor("#C35E12"),
//           inactiveColor: Colors.white,
//           onTap: (tabIndex) {
//             print("Clicked Tab $tabIndex");
//             // tapBar == 1;
//             // print(tapBar);
//           },
//           items: const [
//             BottomNavigationBarItem(
//               label: 'Home',
//               icon: Icon(
//                 CupertinoIcons.house_fill,
//                 size: 25,
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: 'Chat',
//               icon: Icon(
//                 CupertinoIcons.chat_bubble_text_fill,
//                 size: 25,
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: 'Notification',
//               icon: Icon(
//                 CupertinoIcons.bell_solid,
//                 size: 25,
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: 'Profile',
//               icon: Icon(
//                 CupertinoIcons.person_circle_fill,
//                 size: 25,
//               ),
//             ),
//           ],
//         ),
//         tabBuilder: (context, tabIndex) {
//           switch (tabIndex) {
//             case 0:
//               return const LendItemsScreen();
//             case 1:
//               return RecentChatPeople();
//             case 2:
//               return NotificationScreen();
//             case 3:
//             default:
//               return const HomeScreenDefault();
//           }
//         },
//       );
// }
