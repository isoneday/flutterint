import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/helper/constant.dart';
import 'package:flutter_intermediate/helper/general_helper.dart';
import 'package:flutter_intermediate/helper/messagebubble.dart';
import 'package:flutter_intermediate/helper/rounded_button.dart';
import 'package:flutter_intermediate/network/network_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

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
  Network network = Network();
  TextEditingController msgEdtController = TextEditingController();
  String? msgText, idUser, fcm, tokenUpdate, token, device, email;
  var dataEmail;
  ScrollController _controller = ScrollController();
  dynamic user;
  String? userEmail;
  String? userPhoneNumber;

  void getCurrentUserInfo() async {
    user = await _auth.currentUser;
    userEmail = user?.email ?? email;
    // userPhoneNumber = user.phoneNumber;
    // print("userphone :" + userPhoneNumber.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                              controller: _controller,
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
                      Timer(
                          Duration(milliseconds: 300),
                          () => _controller
                              .jumpTo(_controller.position.maxScrollExtent));
                      if (msgEdtController.text.length > 0) {
                        await _firestore.collection("messages").add({
                          "text": msgEdtController.text,
                          "sender": userEmail ?? email,
                          "createdAt": Timestamp.now()
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                        insertChatToDatabase(msgEdtController.text);
                        setState(() {
                          msgEdtController.clear();
                        });
                        Timer(
                            Duration(milliseconds: 500),
                            () => _controller
                                .jumpTo(_controller.position.maxScrollExtent));
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
    setState(() {
      email = preferences.getString("email");
    });

    // setState(() {
    //   dataEmail = _auth.currentUser?.email;
    // });
    if (_currentUser?.email != null) {
      dataEmail = _auth.currentUser?.email;
    } else {
      dataEmail = email;
    }
    getCurrentUserInfo();
  }

  Future<void> insertChatToDatabase(String text) async {
    var device = await getId();
    return network
        .insertChat(idUser, "-6.896754", "107.6133727", "-6.9202814",
            "107.6080291", "Eduplex", "De Braga", text, "5km", token, device)
        .then((response) {
      Toast.show(response?.msg, context);
      // if (response?.result == "true") {
      //   Toast.show(response?.msg, context);
      // } else {
      //   Toast.show(response?.msg, context);
      // }
    });
  }
}
