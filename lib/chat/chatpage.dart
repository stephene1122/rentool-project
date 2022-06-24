import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rentool/model/chatted_friend_model.dart';
import 'package:rentool/screens/login_screen.dart';
import 'package:rentool/services/chatted_friend.dart';
import '../model/user_model.dart';
import 'message.dart';

class chatpage extends StatefulWidget {
  chatpage(
      {Key? key,
      required this.friendUid,
      required this.friendName,
      required this.friendEmail});
  String? friendName;
  String? friendUid;
  String? friendEmail;
  @override
  _chatpageState createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  _chatpageState();

  ChattedFriendModel getChattedUser = ChattedFriendModel();
  UserModel getUser = UserModel();

  CollectionReference chats = FirebaseFirestore.instance.collection("chats");

  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController message = new TextEditingController();

  var chatDocId;
  var chatFriendId;
  var isChattedFriend;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.friendUid)
        .get()
        .then((value) {
      getUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    chats
        .where("users",
            isEqualTo: {widget.friendUid: null, _auth.currentUser!.uid: null})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            chatDocId = querySnapshot.docs.single.id;
          } else {
            chats.add({
              "users": {widget.friendUid: null, _auth.currentUser!.uid: null}
            }).then((value) => {chatDocId = value});
          }
        })
        .catchError((error) {});

    ChattedFriendService()
        .getFriendChat(_auth.currentUser!.uid, widget.friendUid!)
        .then((QuerySnapshot d) {
      if (d.docs.isNotEmpty) {
        isChattedFriend = true;
      } else {
        isChattedFriend = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // get selfie image url
    final userImage = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("chatted-friend")
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("data");
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
      appBar: AppBar(
        title: Text(
          '${widget.friendName}',
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              // _auth.signOut().whenComplete(() {
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => LoginScreen(),
              //     ),
              //   );
              // });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            },
            child: const Text(
              "refresh",
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.79,
              child: messages(
                  email: _auth.currentUser!.email,
                  chatsId: chatDocId,
                  currentUser: _auth.currentUser!.uid),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    maxLines: null,
                    controller: message,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.purple[100],
                      hintText: 'message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.purple),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.purple),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (message.text.isNotEmpty) {
                      fs
                          .collection('chats')
                          .doc(chatDocId)
                          .collection("messages")
                          .add({
                        'message': message.text.trim(),
                        'time': DateTime.now(),
                        'email': _auth.currentUser!.email,
                        'isSeen': false
                      });
                      // adding chat friend list
                      if (isChattedFriend == false) {
                        fs
                            .collection("users")
                            .doc(_auth.currentUser!.uid)
                            .collection("chatted-friend")
                            .add({
                          "uid": widget.friendUid,
                          "friend-chat-name": getUser.fullName,
                          "friend-chat-contact": getUser.contactNumber,
                          "friend-chat-email": getUser.emailAddress,
                          "dateCreated": DateTime.now(),
                        }).then((value) {});
                      }
                      message.clear();
                    }
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
