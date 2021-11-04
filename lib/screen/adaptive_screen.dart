import 'package:flutter/material.dart';
import 'package:flutter_intermediate/argument/adaptive_argument.dart';
import 'package:flutter_intermediate/model/joke.dart';
import 'package:flutter_intermediate/screen/detaildevice_screen.dart';

import 'device_screen.dart';

class AdaptiveScreen extends StatefulWidget {
  static String id = "adaptive";
  const AdaptiveScreen({Key? key}) : super(key: key);

  @override
  _AdaptiveScreenState createState() => _AdaptiveScreenState();
}

class _AdaptiveScreenState extends State<AdaptiveScreen> {
  Joke? pilihanJoke;

  @override
  Widget build(BuildContext context) {
    Widget content;
    var ukuranLayar = MediaQuery.of(context).size.shortestSide;
    var orientasiLayar = MediaQuery.of(context).orientation;

    if (orientasiLayar == Orientation.portrait && ukuranLayar < 600) {
      content = buildNotTablet();
    } else {
      content = buildTablet();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("adaptive screen"),
      ),
      body: content,
    );
  }

  Widget buildTablet() {
    return Row(
      children: [
        Flexible(
          child: DeviceScreen(
            joke: pilihanJoke,
            jokeCallback: (value) {
              setState(() {
                pilihanJoke = value;
              });
            },
          ),
        ),
        Flexible(
          child: DetailDeviceScreen(
            deviceType: true,
            joke: pilihanJoke,
          ),
        )
      ],
    );
  }

  Widget buildNotTablet() {
    return DeviceScreen(
      jokeCallback: (value) {
        Navigator.pushNamed(context, DetailDeviceScreen.id,
            arguments: AdaptiveArgument(false, value));
      },
    );
  }
}
