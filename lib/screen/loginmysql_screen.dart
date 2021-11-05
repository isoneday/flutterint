import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/helper/general_helper.dart';
import 'package:flutter_intermediate/helper/rounded_button.dart';
import 'package:flutter_intermediate/network/network_api.dart';
import 'package:flutter_intermediate/screen/beranda_screen.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';

class LoginMysqlScreen extends StatefulWidget {
  static String id = "mysqllogin";
  const LoginMysqlScreen({Key? key}) : super(key: key);

  @override
  _LoginMysqlScreenState createState() => _LoginMysqlScreenState();
}

class _LoginMysqlScreenState extends State<LoginMysqlScreen> {
  String? email, password, nama, phone;
  bool? loading;
  Network network = Network();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(hintText: "email"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(hintText: "password"),
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
      ),
    );
  }

  Future<void> prosesLogin() async {
    loading = true;
    String device = await getId();
    network.loginUser(email, password, device).then((response) {
      if (response?.result == "true") {
        Toast.show(response?.msg, context);
        Navigator.popAndPushNamed(context, BerandaScreen.id);
        setState(() {
          loading = false;
        });
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal Register: ${response?.msg}"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }
}
