import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/helper/rounded_button.dart';
import 'package:flutter_intermediate/screen/loginemailpass_screen.dart';
import 'package:flutter_intermediate/screen/loginmysql_screen.dart';
import 'package:flutter_intermediate/screen/loginphone_screen.dart';
import 'package:flutter_intermediate/screen/registeremailpass_screen.dart';
import 'package:flutter_intermediate/screen/registermysql_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

import 'beranda_screen.dart';

class AuthScreen extends StatelessWidget {
  static String id = "auth";
  FirebaseAuth auth = FirebaseAuth.instance;

  AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: Column(
          children: [
            RoundedButton(
              color: Colors.blue[700],
              text: "Login by Email Pass",
              callback: () {
                Navigator.pushNamed(context, LoginEmailPassScreen.id);
              },
            ),
            RoundedButton(
              color: Colors.blue[700],
              text: "Login by Google",
              callback: () {
                _signInWithGoogle(context);
              },
            ),
            RoundedButton(
              color: Colors.blue[700],
              text: "Login by Phone",
              callback: () {
                Navigator.pushNamed(context, LoginPhoneScreen.id);
              },
            ),
            RoundedButton(
              color: Colors.blue[700],
              text: "Login by MySql",
              callback: () {
                Navigator.pushNamed(context, LoginMysqlScreen.id);
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Register",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            RoundedButton(
              color: Colors.blue[700],
              text: "Register Email Pass",
              callback: () {
                Navigator.pushNamed(context, RegisterEmailPassScreen.id);
              },
            ),
            RoundedButton(
              color: Colors.blue[700],
              text: "Register by MySql",
              callback: () {
                Navigator.pushNamed(context, RegisterMysqlSCreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  //Example code of how to sign in with Google.
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;

      Toast.show('Sign In ${user?.uid} with Google', context);

      Navigator.popAndPushNamed(context, BerandaScreen.id);
    } catch (e) {
      print(e);
      Toast.show('Failed to sign in with Google: $e', context);
    }
  }
}
