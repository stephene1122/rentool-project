import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rentool/screens/login_screen.dart';
import 'buildmaterialcolor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessaging);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RenTool',
        theme: ThemeData(
          primarySwatch: buildMaterialColor(Color(0xFFC35E12)),
        ),
        home: const LoginScreen());
  }
}

Future<void> _handleBackgroundMessaging(RemoteMessage message) async {
  // notification click listener
}
