import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/helper/constant.dart';
import 'package:flutter_intermediate/helper/messagebubble.dart';
import 'package:flutter_intermediate/helper/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  TextEditingController msgEdtController = TextEditingController();
  String? msgText, idUser, fcm, tokenUpdate, token, device, email;
  var dataEmail;

  dynamic user;
  String? userEmail;
  String? userPhoneNumber;

  void getCurrentUserInfo() async {
    user = await _auth.currentUser;
    userEmail = user.email;
    userPhoneNumber = user.phoneNumber;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserInfo();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("messages")
                      .orderBy("createdAt", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      List<DocumentSnapshot> docs = snapshot.data!.docs;
                      List<MessageBubble> textItems = [];

                      for (DocumentSnapshot doc in docs) {
                        textItems.add(MessageBubble(
                          from: (doc.data() as dynamic)["sender"],
                          text: (doc.data() as dynamic)["text"],
                          date: (doc.data() as dynamic)["createdAt"],
                          fromMe:
                              userEmail == (doc.data() as dynamic)["sender"],
                        ));
                      }
                      return textItems == null
                          ? Center(child: Text("belum ada chatting"))
                          : ListView(
                              children: textItems,
                            );
                    }
                  })),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        style: TextStyle(fontSize: 20),
                        controller: msgEdtController,
                        decoration: kMessageTextFieldDecoration)),
                TextButton(
                    onPressed: () async {
                      if (msgEdtController.text.length > 0) {
                        await _firestore.collection("messages").add({
                          "text": msgEdtController.text,
                          "sender": userEmail ?? email,
                          "createdAt": Timestamp.now()
                        });
                        msgEdtController.clear();
                      }
                    },
                    child: Text("Send"))
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<void> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString("iduser");
    fcm = preferences.getString("fcm");
    token = preferences.getString("token");
    // setState(() {
    //   dataEmail = _auth.currentUser?.email;
    // });
    if (_currentUser?.email != null) {
      dataEmail = _auth.currentUser?.email;
    } else {
      dataEmail = email;
    }
  }
}
