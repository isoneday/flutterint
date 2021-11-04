import 'package:flutter/material.dart';
import 'package:flutter_intermediate/model/joke.dart';

class DeviceScreen extends StatefulWidget {
  Joke? joke;
  ValueChanged<Joke>? jokeCallback;

  DeviceScreen({Key? key, this.joke, this.jokeCallback}) : super(key: key);

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: jokesList.map((itemJoke) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              shape: BoxShape.rectangle),
          child: ListTile(
            onTap: () {
              widget.jokeCallback!(itemJoke);
            },
            selected: widget.joke == itemJoke,
            title: Text(
              itemJoke.setup!,
              style: TextStyle(color: Colors.blue, fontSize: 25),
            ),
          ),
        );
      }).toList(),
    );
  }
}
