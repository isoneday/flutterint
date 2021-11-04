import 'package:flutter/material.dart';
import 'package:flutter_intermediate/screen/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BerandaScreen extends StatelessWidget {
  static String id = "beranda";
  const BerandaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                Navigator.pushReplacementNamed(context, AuthScreen.id);
                pref.clear();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: Row(
              children: [
                tampilanMenu("list wisata", "gambar/bg2.png", Colors.blue,
                    context, AuthScreen.id),
                SizedBox(
                  width: 10,
                ),
                tampilanMenu("grid wisata", "gambar/bg1.png", Colors.yellow,
                    context, AuthScreen.id)
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
