import 'package:flutter/material.dart';
import 'package:flutter_intermediate/helper/rounded_button.dart';
import 'package:flutter_intermediate/screen/loginemailpass_screen.dart';

class AuthScreen extends StatelessWidget {
  static String id = "auth";

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Column(
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
              Navigator.pushNamed(context, LoginEmailPassScreen.id);
            },
          ),
           RoundedButton(
            color: Colors.blue[700],
            text: "Login by Phone",
            callback: () {
              Navigator.pushNamed(context, LoginEmailPassScreen.id);
            },
          ),
           RoundedButton(
            color: Colors.blue[700],
            text: "Login by MySql",
            callback: () {
              Navigator.pushNamed(context, LoginEmailPassScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
