import 'package:flutter/material.dart';
import 'package:flutter_intermediate/model/joke.dart';

class DetailDeviceScreen extends StatelessWidget {
  static String id = "detail";
  bool? deviceType;
  Joke? joke;

  DetailDeviceScreen({Key? key, this.deviceType, this.joke}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Text(
          joke?.setup ?? "belum dipilih",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          joke?.punchline ?? "belum dipilih",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        )
      ],
    );
    if (deviceType == true) {
      return Center(
        child: content,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(joke?.type ?? "belum dipilih"),
        ),
        body: Center(
          child: content,
        ),
        backgroundColor: Colors.yellow,
      );
    }
  }
}
