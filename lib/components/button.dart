import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPress;

  const Button({Key key, @required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPress();
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.access_alarm_outlined, color: Colors.black),
          Text(" ALTERAR O TIMER", style: TextStyle(color: Colors.black)),
        ],
      ),
      style: TextButton.styleFrom(
        fixedSize: Size(180, 40),
        backgroundColor: Colors.indigoAccent[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
