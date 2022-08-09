import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/chat/recent_chat_people.dart';
import 'package:rentool/screens/home_screen_default.dart';
import 'package:rentool/screens/lend_items_screen.dart';
import 'package:rentool/screens/notification_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  NavigationBarScreen({Key? key, this.tabIndex}) : super(key: key);
  var tabIndex;
  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if tab index has value get value
    if (widget.tabIndex != null) {
      currentIndex = widget.tabIndex;
    } else {
      currentIndex = 0;
    }
  }

  int? currentIndex;
  final screens = [
    const LendItemsScreen(),
    RecentChatPeople(),
    const NotificationScreen(),
    const HomeScreenDefault()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex!],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex!,
          onTap: (index) => setState(() => currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: HexColor("#E4B43D"),
          selectedItemColor: Colors.white70,
          unselectedItemColor: HexColor("#C35E12"),
          iconSize: 26,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Profile",
            )
          ]),
    );
  }
}
