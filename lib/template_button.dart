import 'package:flutter/material.dart';

class ButtonModal extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  ButtonModal({required this.text, required this.onPressed});

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<ButtonModal> {
  @override
  Widget build(BuildContext context) =>
      buildButton(text: widget.text, onClicked: widget.onPressed);
}

Widget buildButton({required String text, required VoidCallback onClicked}) =>
    FittedBox(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(229, 13, 115, 1),
              Color.fromRGBO(247, 98, 7, 1),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: GestureDetector(
            onTap: onClicked,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
