import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/helper/rounded_button.dart';
import 'package:flutter_intermediate/screen/beranda_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginEmailPassScreen extends StatefulWidget {
  static String id = "loginemailpass";
  const LoginEmailPassScreen({Key? key}) : super(key: key);

  @override
  _LoginEmailPassScreenState createState() => _LoginEmailPassScreenState();
}

class _LoginEmailPassScreenState extends State<LoginEmailPassScreen> {
  String? email, password;
  bool? loading;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            RoundedButton(
              text: "Login",
              color: Colors.blue[700],
              callback: () {
                prosesLogin();
              },
            ),
            loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<void> prosesLogin() async {
    loading = true;
    User? user = (await auth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    ))
        .user;
    if (user!.emailVerified) {
      setState(() {
        loading = false;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("sesi", true);
      preferences.setString("email", user.email!);
      Navigator.popAndPushNamed(context, BerandaScreen.id);
      Toast.show("Berhasil Login", context);
    } else {
      setState(() {
        loading = false;
      });
      Toast.show("Gagal Login", context);
    }
  }
}
