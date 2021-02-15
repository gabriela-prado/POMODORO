import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPress;
  final String text;
  final double width;
  final double height;
  final IconData icon;

  const Button(
      {Key key,
      @required this.onPress,
      @required this.text,
      this.width,
      this.height, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: () {
          onPress();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(icon, color: Colors.black),
            ),
            Text(text, style: TextStyle(color: Colors.black)),
          ],
        ),
        style: TextButton.styleFrom(
          fixedSize: Size(width, height),
          backgroundColor: Colors.indigoAccent[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
