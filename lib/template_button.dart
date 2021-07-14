import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  Button({required this.text, required this.onPressed});

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) => buildButton(text: widget.text, onClicked: widget.onPressed);
}

Widget buildButton({required String text, required VoidCallback onClicked}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      ),
      child: Text(text, style: TextStyle(fontSize: 20)),
      onPressed: onClicked,
    );
