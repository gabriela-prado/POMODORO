import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerTimer extends StatefulWidget {
  @override
  _PickerTimerState createState() => _PickerTimerState();
}

class _PickerTimerState extends State<PickerTimer> {
  int minute = 0;

  var minutes = [for (var i = 1; i <= 60; i++) i];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                "Escolha o novo timer\ndo Pomodoro:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Align(
            child: Container(
              height: 150,
              width: 150,
              child: CupertinoPicker(
                itemExtent: 50,
                backgroundColor: Colors.transparent,
                onSelectedItemChanged: (int value) {
                  minute = value;
                },
                children: <Widget>[
                  for (var number in minutes)
                    Center(
                      child: Text(
                        number.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, right: 40.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, minute + 1);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.check_outlined, color: Colors.black),
                      Text(
                        " OK",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
                  style: TextButton.styleFrom(
                    fixedSize: Size(95, 50),
                    backgroundColor: Colors.indigoAccent[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
