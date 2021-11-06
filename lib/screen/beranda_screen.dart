import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/main.dart';
import 'package:flutter_intermediate/screen/adaptive_screen.dart';
import 'package:flutter_intermediate/screen/auth_screen.dart';
import 'package:flutter_intermediate/screen/chat_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class BerandaScreen extends StatefulWidget {
  static String id = "beranda";
  const BerandaScreen({Key? key}) : super(key: key);

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   Authentication.customSnackBar(
      //     content: 'Error signing out. Try again.',
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
        actions: [
          IconButton(
              onPressed: () async {
                //signout google 1
                signOut(context: context);
                SharedPreferences pref = await SharedPreferences.getInstance();
                Navigator.pushReplacementNamed(context, AuthScreen.id);
                pref.clear();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: Row(
              children: [
                tampilanMenu("Adaptive", "gambar/bg2.png", Colors.blue, context,
                    AdaptiveScreen.id),
                SizedBox(
                  width: 10,
                ),
                tampilanMenu("Chat", "gambar/bg1.png", Colors.yellow, context,
                    ChatScreen.id)
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: [
                tampilanMenu("Camera", "gambar/bg1.png", Colors.yellow, context,
                    AuthScreen.id),
                SizedBox(
                  width: 10,
                ),
                tampilanMenu("Berita", "gambar/bg2.png", Colors.blue, context,
                    AuthScreen.id)
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: [
                tampilanMenu("SqliteDB", "gambar/bg1.png", Colors.blue, context,
                    AuthScreen.id),
                tampilanMenu("Tab", "gambar/bg2.png", Colors.yellow, context,
                    AuthScreen.id)
              ],
            ),
          )
        ],
      ),
    );
  }

  void notification() {
    FirebaseMessaging.instance
        .getToken()
        .then((value) => print("token saya :$value"));

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        var notificationData = message.data;
        var view = notificationData["view"];
        if (view == "url") {
          openWeb(message);
        } else {
          showAlertDialog(context, message);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
      if (message != null) {
        var notificationData = message.data;
        var view = notificationData["view"];
        if (view == "url") {
          openWeb(message);
        } else {
          showAlertDialog(context, message);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message != null) {
        var notificationData = message.data;
        var view = notificationData["view"];
        if (view == "url") {
          openWeb(message);
        } else {
          showAlertDialog(context, message);
        }
      }
    });
  }

  Future<void> openWeb(RemoteMessage message) async {
    bool _validUrl = Uri.parse(message.notification!.body!).isAbsolute;
    if (_validUrl) {
      await canLaunch(message.notification!.body!)
          ? await launch(message.notification!.body!)
          : throw 'Could not launch ${message.notification!.body!}';
    }
  }

  void showAlertDialog(BuildContext context, RemoteMessage message) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("OK"));

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      backgroundColor: Colors.yellow[800],
      title: Text(
        message.notification!.title!,
        style: TextStyle(fontSize: 15),
      ),
      content: Text(message.notification!.body!),
      actions: [okButton],
    );

    showDialog(context: context, builder: (context) => alert);
  }
}

Widget tampilanMenu(String title, String nameImage, Color color,
    BuildContext context, String kelasTujuan) {
  return Flexible(
    child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, kelasTujuan);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: color,
              // border: Border.all(width: 3, style: BorderStyle.solid),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  nameImage,
                  width: 150,
                  height: 150,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
