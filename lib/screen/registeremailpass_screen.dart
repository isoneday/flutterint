import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/helper/rounded_button.dart';
import 'package:flutter_intermediate/screen/loginemailpass_screen.dart';
import 'package:toast/toast.dart';

class RegisterEmailPassScreen extends StatefulWidget {
  static String id = "registeremailpas";
  const RegisterEmailPassScreen({Key? key}) : super(key: key);

  @override
  _RegisterEmailPassScreenState createState() =>
      _RegisterEmailPassScreenState();
}

class _RegisterEmailPassScreenState extends State<RegisterEmailPassScreen> {
  String? email, password;
  bool? loading;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: 
      SingleChildScrollView(
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
              text: "Register",
              color: Colors.blue[700],
              callback: () {
                prosesRegister();
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

  Future<void> prosesRegister() async {
    loading = true;
    User user = await auth.createUserWithEmailAndPassword(
        email: email!, password: password!) as User;
    if (user != null) {
      setState(() {
        loading = false;
      });
      user.sendEmailVerification();
      Navigator.popAndPushNamed(context, LoginEmailPassScreen.id);
      Toast.show("Berhasil Register,Silahkan Periksa Email Anda", context);
    } else {
      setState(() {
        loading = false;
      });
      Toast.show("Gagal Register", context);
    }
  }
}
