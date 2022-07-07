import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rentool/screens/user_validation_details.dart';
import 'package:rentool/services/user_admin.dart';

class NewUsersTable extends StatefulWidget {
  const NewUsersTable({Key? key}) : super(key: key);

  @override
  State<NewUsersTable> createState() => _NewUsersTableState();
}

class _NewUsersTableState extends State<NewUsersTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Registered Users"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('isUserGranted', isEqualTo: '0')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("something wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ListTile(
                        onLongPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserValidationDetails(
                                  uid: snapshot
                                      .data!.docChanges[index].doc['uid'],
                                ),
                              ));
                        },
                        leading: _userImage(
                            uid: snapshot.data!.docChanges[index].doc['uid']),
                        title: Text(
                            "${snapshot.data!.docChanges[index].doc['fullName']}"),
                        subtitle: Text(
                            "${snapshot.data!.docChanges[index].doc['homeAddress']}"),
                        trailing: MaterialButton(
                          onPressed: () {
                            userAdminService().approvedUser(
                                "${snapshot.data!.docChanges[index].doc['uid']}",
                                "context");
                          },
                          child: Icon(
                            Icons.verified_user,
                            color: HexColor("#E4B43D"),
                          ),
                        ),
                      ));
                });
          },
        ));
  }
}

class _userImage extends StatelessWidget {
  _userImage({Key? key, this.uid}) : super(key: key);
  String? uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("images-user-selfie")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/square-album.png"));
        } else {
          String url = snapshot.data!.docs[0]["downloadURL"];
          return SizedBox(
              width: 60,
              height: 80,
              child: CircleAvatar(
                backgroundImage: NetworkImage(url),
              ));
        }
      },
    );
  }
}
