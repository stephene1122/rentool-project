import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/screens/user_validation_table.dart';
import 'package:rentool/screens/validated_users_datatable.dart';

import 'buildmaterialcolor.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: const Text("Admininistration"),
              accountEmail: const Text("qwerty"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    "assets/user-icon.png",
                    width: 90,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration:
                  BoxDecoration(color: buildMaterialColor(Color(0xFFC35E12)))),
          // ListTile(
          //   leading: const Icon(Icons.favorite),
          //   title: const Text("Favorites"),
          //   onTap: () => null,
          // ),
          // ListTile(
          //   leading: const Icon(Icons.people),
          //   title: const Text("Friends"),
          //   onTap: () => null,
          // ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("Validated Users"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => VerifiedUserList())),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("New Users"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewUsersTable())),
            // trailing: ClipOval(
            //   child: Container(
            //     color: Colors.red,
            //     width: 20,
            //     height: 20,
            //     child: const Center(
            //       child: Text(
            //         "6",
            //         style: TextStyle(color: Colors.white, fontSize: 12),
            //       ),
            //     ),
            //   ),
            // ),
          ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text("Settings"),
          //   onTap: () => null,
          // ),
          // ListTile(
          //   leading: const Icon(Icons.policy),
          //   title: const Text("Policies"),
          //   onTap: () => null,
          // ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.exit_to_app),
          //   title: const Text("Exit"),
          //   onTap: () => null,
          // ),
        ],
      ),
    );
  }
}
