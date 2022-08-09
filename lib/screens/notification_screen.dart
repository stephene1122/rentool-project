import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/notifications/return_item.dart';
import 'package:rentool/rent_items/contact_borrower.dart';
import 'package:rentool/screens/home_screen.dart';
import 'package:rentool/screens/transaction_granted.dart';
import 'package:rentool/screens/user_validation_table.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final db = FirebaseFirestore.instance;

  TextEditingController username = TextEditingController();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? mtoken = " ";

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   loadFCM();
  //   listenFCM();
  //   requestPermission();
  //   getToken();
  //   FirebaseMessaging.instance.subscribeToTopic("Animal");
  // }

  // void getTokenFromFirestore() async {}

  // void saveToken(String token) async {
  //   await FirebaseFirestore.instance.collection("UserTokens").doc("User3").set({
  //     'token': token,
  //   });
  // }

  // void sendPushMessage(String token) async {
  //   try {
  //     await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization':
  //               'key=AAAARiLOifY:APA91bHzJcIGhL3JSn7HL03yOUS1m-oIH6vvLG1uEr9rBfpacTyH9ldYR5RmhrlioIXNZQ74JTxav8kzrw7gJNCwF6tV5AzLQe-h3wl5MBH9LMOhip7TfXRCClsD_oN8j5mh9rv8cE35',
  //         },
  //         body: jsonEncode(
  //           <String, dynamic>{
  //             'notification': <String, dynamic>{
  //               'body': 'Test',
  //               'title': 'Test Title'
  //             },
  //             'priority': 'high',
  //             'data': <String, dynamic>{
  //               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //               'id': '1',
  //               'status': 'done'
  //             },
  //             'to': token,
  //           },
  //         ));
  //   } catch (e) {
  //     print('error push notification ${e}');
  //   }
  // }

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     setState(() {
  //       mtoken = token;
  //     });
  //     // saveToken(token!);
  //   });
  // }

  // void listenFCM() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null && !kIsWeb) {
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             // TODO add a proper drawable resource to android, for now using
  //             //      one that already exists in example app.
  //             icon: 'launch_background',
  //           ),
  //         ),
  //       );
  //     }
  //   });
  // }

  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   NotificationSettings settings = await messaging.requestPermission(
  //       alert: true,
  //       announcement: false,
  //       badge: true,
  //       carPlay: false,
  //       criticalAlert: false,
  //       provisional: false,
  //       sound: true);

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print("User granted permission");
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print("User granted provisional permission");
  //   } else {
  //     print("User declined or has not accepted permission");
  //   }
  // }

  // void loadFCM() async {
  //   if (!kIsWeb) {
  //     channel = const AndroidNotificationChannel(
  //       'high_importance_channel', // id
  //       'High Importance Notifications', // title
  //       importance: Importance.high,
  //     );

  //     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //     /// Create an Android Notification Channel.
  //     ///
  //     /// We use this channel in the `AndroidManifest.xml` file to override the
  //     /// default FCM channel to enable heads up notifications.
  //     await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //         ?.createNotificationChannel(channel);

  //     /// Update the iOS foreground notification presentation options to allow
  //     /// heads up notifications.
  //     await FirebaseMessaging.instance
  //         .setForegroundNotificationPresentationOptions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  //   }
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   refresh();
  // }

  // Future refresh() async {
  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (BuildContext context) => HomeScreen(
  //                 tabIndex: 2,
  //               )));
  //   print("object");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 95,
                ),
                const Padding(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 5),
                    child: Center(
                        child: Text(
                      "Notifications",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ))),
              ],
            )),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: const Text("Notif"),
      //   onPressed: () {
      //     // getToken();
      //   },
      //   icon: const Icon(Icons.construction_rounded),
      //   backgroundColor: HexColor("#E4B43D"),
      // ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .where("to", isEqualTo: user!.uid)
            .orderBy("dateCreated")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No notification"),
            );
          }
          if (snapshot.hasError) {
            print("Something wrong!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        var typeId =
                            snapshot.data!.docChanges[index].doc['typeId'];
                        if (typeId == 4) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactBorrower(
                                    borrowerUid: snapshot
                                        .data!.docChanges[index].doc['from'],
                                    refId: snapshot.data!.docChanges[index]
                                        .doc['lend-item-id'],
                                  )));
                        } else if (typeId == 5) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TransactionGrantedDetails(
                                    lenderUid: snapshot
                                        .data!.docChanges[index].doc['from'],
                                    refId: snapshot.data!.docChanges[index]
                                        .doc['lend-item-id'],
                                  )));
                        } else if (typeId == 6) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReturnItemNotification(
                                    borrowerUid: snapshot
                                        .data!.docChanges[index].doc['from'],
                                    refId: snapshot.data!.docChanges[index]
                                        .doc['lend-item-id'],
                                  )));
                          print(6);
                          print(snapshot.data!.docChanges[index].doc['from']);
                          print(snapshot
                              .data!.docChanges[index].doc['lend-item-id']);
                        } else if (typeId == 1) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NewUsersTable()));
                        } else {
                          print(
                              "${snapshot.data!.docChanges[index].doc.reference.id}");
                          print(1);
                        }
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 6),
                              tileColor: HexColor("#E3B13B"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  side: BorderSide(color: HexColor("#C35E12"))),
                              title: Text(
                                "${snapshot.data!.docChanges[index].doc['title']}",
                                style: const TextStyle(fontSize: 20),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // leading: Text(
                              //     "${snapshot.data!.docChanges[index].doc['to']}"),
                              subtitle: Text(
                                "${snapshot.data!.docChanges[index].doc['body']}",
                                style: const TextStyle(fontSize: 16),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // trailing: Column(
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       "Price: ${snapshot.data!.docChanges[index].doc['dateCreated']} ",
                              //       style: const TextStyle(fontSize: 15),
                              //     )
                              //   ],
                              // )
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Center(
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       TextFormField(
//         controller: username,
//       ),
//       GestureDetector(
//         onTap: () async{
//           String name = username.text.trim();

//           if(name != ""){
//             DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(name).get();
            
//             String token = snap['token'];
//             print(token);

//             sendPushMessage(token);
//           }
//         },
//       )
//     ],
//   )
// )